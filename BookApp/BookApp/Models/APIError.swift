import Foundation

struct APIError: Codable, Error {
    let error: Bool
    let reason: String
}
