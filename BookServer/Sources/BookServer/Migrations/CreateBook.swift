//
//  File.swift
//  BookServer
//
//  Created by Erik Sebastian de Erice Jerez on 16/6/25.
//

import Fluent

struct CreateBook: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("books")
            .id()
            .field("title", .string, .required)
            .field("author", .string, .required)
            .field("isbn", .string, .required)
            .field("publication_year", .int, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "isbn")
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("books").delete()
    }
}
