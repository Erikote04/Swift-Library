//
//  File.swift
//  BookServer
//
//  Created by Erik Sebastian de Erice Jerez on 16/6/25.
//

import Foundation
@testable import BookServer

class BookBuilder {
    private var id: UUID? = UUID()
    private var title: String = ""
    private var author: String = ""
    private var isbn: String = ""
    private var publicationYear: Int = 0
    
    func id(_ id: UUID?) -> BookBuilder {
        self.id = id
        return self
    }
    
    func title(_ title: String) -> BookBuilder {
        self.title = title
        return self
    }
    
    func author(_ author: String) -> BookBuilder {
        self.author = author
        return self
    }
    
    func isbn(_ isbn: String) -> BookBuilder {
        self.isbn = isbn
        return self
    }
    
    func publicationYear(_ year: Int) -> BookBuilder {
        self.publicationYear = year
        return self
    }
    
    func build() -> Book {
        Book(
            title: title,
            author: author,
            isbn: isbn,
            publicationYear: publicationYear
        )
    }
}

extension Book: Equatable {
    public static func == (lhs: Book, rhs: Book) -> Bool {
        lhs.id == rhs.id && lhs.isbn == rhs.isbn
    }
}
