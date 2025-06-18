import Foundation
@testable import BookApp

class BookBuilder {
    private var id: UUID = UUID()
    private var title: String = ""
    private var author: String = ""
    private var isbn: String = ""
    private var publicationYear: Int = 0
    
    func id(_ id: UUID) -> BookBuilder {
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
            id: id,
            title: title,
            author: author,
            isbn: isbn,
            publicationYear: publicationYear
        )
    }
}

class BookRequestBuilder {
    private var title: String = ""
    private var author: String = ""
    private var isbn: String = ""
    private var publicationYear: Int = 0
    
    func title(_ title: String) -> BookRequestBuilder {
        self.title = title
        return self
    }
    
    func author(_ author: String) -> BookRequestBuilder {
        self.author = author
        return self
    }
    
    func isbn(_ isbn: String) -> BookRequestBuilder {
        self.isbn = isbn
        return self
    }
    
    func publicationYear(_ year: Int) -> BookRequestBuilder {
        self.publicationYear = year
        return self
    }
    
    func build() -> BookRequest {
        return BookRequest(
            title: title,
            author: author,
            isbn: isbn,
            publicationYear: publicationYear
        )
    }
}
