import Fluent

struct CreateBook: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("books")
            .id()
            .field("title", .string, .required)
            .field("author", .string, .required)
            .field("isbn", .string, .required)
            .field("publication_year", .int, .required)
            .unique(on: "isbn")
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("books").delete()
    }
}
