//
//  BookAPIService.swift
//  BookApp
//
//  Created by Erik Sebastian de Erice Jerez on 16/6/25.
//

import Foundation

class BookAPIService: ObservableObject {
    static let shared = BookAPIService()
    
    private let baseURL = "http://localhost:8080/api/books"
    private let session = URLSession.shared
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
    }
    
    // MARK: GET
    
    func getAllBooks() async throws -> [Book] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode >= 400 {
            let apiError = try decoder.decode(APIError.self, from: data)
            throw NSError(domain: "APIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: apiError.reason])
        }
        
        return try decoder.decode([Book].self, from: data)
    }
    
    func getBook(id: UUID) async throws -> Book {
        guard let url = URL(string: "\(baseURL)/\(id.uuidString)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode >= 400 {
            let apiError = try decoder.decode(APIError.self, from: data)
            throw NSError(domain: "APIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: apiError.reason])
        }
        
        return try decoder.decode(Book.self, from: data)
    }
    
    // MARK: POST
    
    func createBook(_ bookRequest: BookRequest) async throws -> Book {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(bookRequest)
        
        let (data, response) = try await session.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode >= 400 {
            let apiError = try decoder.decode(APIError.self, from: data)
            throw NSError(domain: "APIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: apiError.reason])
        }
        
        return try decoder.decode(Book.self, from: data)
    }
    
    // MARK: PUT
    
    func updateBook(id: UUID, with updateRequest: BookRequest) async throws -> Book {
        guard let url = URL(string: "\(baseURL)/\(id.uuidString)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(updateRequest)
        
        let (data, response) = try await session.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode >= 400 {
            let apiError = try decoder.decode(APIError.self, from: data)
            throw NSError(domain: "APIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: apiError.reason])
        }
        
        return try decoder.decode(Book.self, from: data)
    }
    
    // MARK: DELETE
    
    func deleteBook(id: UUID) async throws {
        guard let url = URL(string: "\(baseURL)/\(id.uuidString)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await session.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode >= 400 {
            let apiError = try decoder.decode(APIError.self, from: data)
            throw NSError(domain: "APIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: apiError.reason])
        }
    }
}
