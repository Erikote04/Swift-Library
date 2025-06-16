@testable import BookServer
import VaporTesting
import Testing
import Fluent

@Suite("App Tests with DB", .serialized)
struct BookServerTests {
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
            try await app.testing().test(.GET, "api/books", afterResponse: { res async in
                #expect(res.status == .ok)
            })
        }
    }
    
    @Test("Getting all the Books")
    func getAllBooks() async throws {
        try await withApp { app in
            let sampleTodos = [
                BookBuilder().isbn("1111111111111").build(),
                BookBuilder().isbn("2222222222222").build()
            ]
            
            try await sampleTodos.create(on: app.db)
            
            try await app.testing().test(.GET, "api/books", afterResponse: { res async throws in
                #expect(res.status == .ok)
                #expect(try res.content.decode([BookDTO].self) == sampleTodos.map { $0.toDTO()} )
            })
        }
    }
    
    @Test("Creating a Book")
    func createTodo() async throws {
        let newDTO = BookDTOBuilder().title("Test Title").build()
        
        try await withApp { app in
            try await app.testing().test(.POST, "api/books", beforeRequest: { req in
                try req.content.encode(newDTO)
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)
                let models = try await Book.query(on: app.db).all()
                #expect(models.map({ $0.toDTO().title }) == [newDTO.title])
            })
        }
    }
    
    @Test("Deleting a Book")
    func deleteTodo() async throws {
        let sampleTodos = [
            BookBuilder().isbn("1111111111111").build(),
            BookBuilder().isbn("2222222222222").build()
        ]
        
        try await withApp { app in
            try await sampleTodos.create(on: app.db)
            
            try await app.testing().test(.DELETE, "api/books/\(sampleTodos[0].requireID())", afterResponse: { res async throws in
                #expect(res.status == .noContent)
                let model = try await Book.find(sampleTodos[0].id, on: app.db)
                #expect(model == nil)
            })
        }
    }
}
