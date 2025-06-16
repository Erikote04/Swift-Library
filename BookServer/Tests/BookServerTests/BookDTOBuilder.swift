//
//  File.swift
//  BookServer
//
//  Created by Erik Sebastian de Erice Jerez on 16/6/25.
//

import Foundation
@testable import BookServer

class BookDTOBuilder {
    private var id: UUID? = UUID()
    private var title: String = ""
    private var author: String = ""
    private var isbn: String = ""
    private var publicationYear: Int = 0
    
    func id(_ id: UUID?) -> BookDTOBuilder {
        self.id = id
        return self
    }
    
    func title(_ title: String) -> BookDTOBuilder {
        self.title = title
        return self
    }
    
    func author(_ author: String) -> BookDTOBuilder {
        self.author = author
        return self
    }
    
    func isbn(_ isbn: String) -> BookDTOBuilder {
        self.isbn = isbn
        return self
    }
    
    func publicationYear(_ year: Int) -> BookDTOBuilder {
        self.publicationYear = year
        return self
    }
    
    func build() -> BookDTO {
        BookDTO(
            id: id,
            title: title,
            author: author,
            isbn: isbn,
            publicationYear: publicationYear
        )
    }
}

extension BookDTO: Equatable {
    public static func == (lhs: BookDTO, rhs: BookDTO) -> Bool {
        lhs.id == rhs.id && lhs.isbn == rhs.isbn
    }
}
