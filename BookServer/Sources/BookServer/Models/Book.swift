//
//  File.swift
//  BookServer
//
//  Created by Erik Sebastian de Erice Jerez on 16/6/25.
//

import Foundation
import Fluent

final class Book: Model, @unchecked Sendable {
    static let schema = "books"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "author")
    var author: String
    
    @Field(key: "isbn")
    var isbn: String
    
    @Field(key: "publication_year")
    var publicationYear: Int
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, title: String, author: String, isbn: String, publicationYear: Int) {
        self.id = id
        self.title = title
        self.author = author
        self.isbn = isbn
        self.publicationYear = publicationYear
    }
    
    func toDTO() -> BookDTO {
        .init(
            id: self.id,
            title: self.title,
            author: self.author,
            isbn: self.isbn,
            publicationYear: self.publicationYear,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt
        )
    }
}
