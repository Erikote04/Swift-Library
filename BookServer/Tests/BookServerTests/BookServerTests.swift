@testable import BookServer
import VaporTesting
import Testing
import Fluent

@Suite("App Tests with DB", .serialized)
struct BookServerTests {
    private let baseURL = "api/books/"
    
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        
        do {
            try await configure(app)
            try await app.autoMigrate()
            try await test(app)
            try await app.autoRevert()
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        
        try await app.asyncShutdown()
    }
    
    @Test("Test books route")
    func booksRoute() async throws {
        try await withApp { app in
            try await app.testing().test(.GET, baseURL, afterResponse: { res async in
                #expect(res.status == .ok)
            })
        }
    }
    
    @Test("Getting all the Books")
    func getAllBooks() async throws {
        try await withApp { app in
            let sampleBooks = [
                BookBuilder().isbn("1111111111111").build(),
                BookBuilder().isbn("2222222222222").build()
            ]
            
            try await sampleBooks.create(on: app.db)
            
            try await app.testing().test(.GET, baseURL, afterResponse: { res async throws in
                #expect(res.status == .ok)
                #expect(try res.content.decode([BookDTO].self) == sampleBooks.map { $0.toDTO()} )
            })
        }
    }
    
    @Test("Getting a Book by ID")
    func getBook() async throws {
        try await withApp { app in
            let sampleBook = BookBuilder().build()
            
            try await sampleBook.create(on: app.db)
            
            try await app.testing().test(.GET, "\(baseURL)/\(sampleBook.id!)", afterResponse: { res async throws in
                #expect(res.status == .ok)
                #expect(try res.content.decode(BookDTO.self) == sampleBook.toDTO())
            })
        }
    }
    
    @Test("Creating a Book")
    func createBook() async throws {
        let newDTO = BookDTOBuilder().title("Test Title").build()
        
        try await withApp { app in
            try await app.testing().test(.POST, baseURL, beforeRequest: { req in
                try req.content.encode(newDTO)
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)
                let models = try await Book.query(on: app.db).all()
                #expect(models.map({ $0.toDTO().title }) == [newDTO.title])
            })
        }
    }
    
    @Test("Updating a Book")
    func updateBook() async throws {
        try await withApp { app in
            let sampleBook = BookBuilder().title("Original Title").build()
            let updatedDTO = BookDTOBuilder().title("Updated Title").build()
            
            try await sampleBook.create(on: app.db)
            
            try await app.testing().test(.PUT, "\(baseURL)\(sampleBook.requireID())", beforeRequest: { req in
                try req.content.encode(updatedDTO)
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)
                let updatedBook = try await Book.find(sampleBook.id, on: app.db)
                #expect(updatedBook?.toDTO().title == updatedDTO.title)
            })
        }
    }
    
    @Test("Deleting a Book")
    func deleteBook() async throws {
        let sampleBooks = [
            BookBuilder().isbn("1111111111111").build(),
            BookBuilder().isbn("2222222222222").build()
        ]
        
        try await withApp { app in
            try await sampleBooks.create(on: app.db)
            
            try await app.testing().test(.DELETE, "\(baseURL)\(sampleBooks[0].requireID())", afterResponse: { res async throws in
                #expect(res.status == .noContent)
                let model = try await Book.find(sampleBooks[0].id, on: app.db)
                #expect(model == nil)
            })
        }
    }
}
