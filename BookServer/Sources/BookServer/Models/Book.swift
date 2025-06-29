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
            publicationYear: self.publicationYear
        )
    }
}
