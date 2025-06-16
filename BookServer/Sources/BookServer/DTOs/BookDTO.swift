//
//  File.swift
//  BookServer
//
//  Created by Erik Sebastian de Erice Jerez on 16/6/25.
//

import Fluent
import Vapor

struct BookDTO: Content {
    let id: UUID
    let title: String
    let author: String
    let isbn: String
    let publicationYear: Int
    let createdAt: Date?
    let updatedAt: Date?
    
    init(from book: Book) throws {
        guard let id = book.id else {
            throw Abort(.internalServerError, reason: "Book ID is nil")
        }
        
        self.id = id
        self.title = book.title
        self.author = book.author
        self.isbn = book.isbn
        self.publicationYear = book.publicationYear
        self.createdAt = book.createdAt
        self.updatedAt = book.updatedAt
    }
}
