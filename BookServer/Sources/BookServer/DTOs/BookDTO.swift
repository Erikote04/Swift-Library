//
//  File.swift
//  BookServer
//
//  Created by Erik Sebastian de Erice Jerez on 16/6/25.
//

import Fluent
import Vapor

struct BookDTO: Content {
    let id: UUID?
    let title: String?
    let author: String?
    let isbn: String?
    let publicationYear: Int?
    
    func toModel() -> Book {
        let model = Book()
        
        model.id = self.id
        
        if let title = self.title {
            model.title = title
        }
        
        if let author = self.author {
            model.author = author
        }
        
        if let isbn = self.isbn {
            model.isbn = isbn
        }
        
        if let publicationYear = self.publicationYear {
            model.publicationYear = publicationYear
        }
        
        return model
    }
}
