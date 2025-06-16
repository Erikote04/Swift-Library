//
//  Book.swift
//  BookApp
//
//  Created by Erik Sebastian de Erice Jerez on 16/6/25.
//

import Foundation

struct Book: Identifiable, Codable {
    let id: UUID
    let title: String
    let author: String
    let isbn: String
    let publicationYear: Int
    let createdAt: Date?
    let updatedAt: Date?
}

struct BookRequest: Codable {
    let title: String
    let author: String
    let isbn: String
    let publicationYear: Int
}
