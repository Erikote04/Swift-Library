import Vapor
import Fluent

struct BookController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let books = routes.grouped("api", "books")
        
        books.get(use: getAllBooks)
        books.post(use: createBook)
        books.group(":bookID") { book in
            book.get(use: getBook)
            book.put(use: updateBook)
            book.delete(use: deleteBook)
        }
    }
    
    // MARK: GET
    
    func getAllBooks(req: Request) async throws -> [BookDTO] {
        try await Book.query(on: req.db).all().map { $0.toDTO() }
    }
    
    func getBook(req: Request) async throws -> BookDTO {
        guard let book = try await Book.find(req.parameters.get("bookID"), on: req.db) else {
            throw Abort(.notFound, reason: "Book not found")
        }
        
        return book.toDTO()
    }
    
    // MARK: POST
    
    func createBook(req: Request) async throws -> BookDTO {
        let createData = try req.content.decode(BookDTO.self).toModel()
        
        let existingBook = try await Book.query(on: req.db)
            .filter(\.$isbn == createData.isbn)
            .first()
        
        if existingBook != nil {
            throw Abort(.conflict, reason: "A book with this ISBN already exists")
        }
        
        let book = Book(
            title: createData.title,
            author: createData.author,
            isbn: createData.isbn,
            publicationYear: createData.publicationYear
        )
        
        try await book.save(on: req.db)
        
        return  book.toDTO()
    }
    
    // MARK: PUT
    
    func updateBook(req: Request) async throws -> BookDTO {
        let updateData = try req.content.decode(BookDTO.self)
        
        guard let book = try await Book.find(req.parameters.get("bookID"), on: req.db) else {
            throw Abort(.notFound, reason: "Book not found")
        }
        
        if let newISBN = updateData.isbn, newISBN != book.isbn {
            let existingBook = try await Book.query(on: req.db)
                .filter(\.$isbn == newISBN)
                .first()
            
            if existingBook != nil {
                throw Abort(.conflict, reason: "A book with this ISBN already exists")
            }
        }
        
        if let title = updateData.title {
            book.title = title
        }
        
        if let author = updateData.author {
            book.author = author
        }
        
        if let isbn = updateData.isbn {
            book.isbn = isbn
        }
        
        if let year = updateData.publicationYear {
            book.publicationYear = year
        }
        
        try await book.save(on: req.db)
        
        return book.toDTO()
    }
    
    // MARK: DELETE
    
    func deleteBook(req: Request) async throws -> Response {
        guard let book = try await Book.find(req.parameters.get("bookID"), on: req.db) else {
            throw Abort(.notFound, reason: "Book not found")
        }
        
        try await book.delete(on: req.db)
        
        return Response(status: .noContent)
    }
}


