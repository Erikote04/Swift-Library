import Foundation

struct Book: Identifiable, Codable {
    let id: UUID?
    let title: String?
    let author: String?
    let isbn: String?
    let publicationYear: Int?
}

struct BookRequest: Codable {
    let title: String?
    let author: String?
    let isbn: String?
    let publicationYear: Int?
}
