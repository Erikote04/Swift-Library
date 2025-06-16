//
//  APIError.swift
//  BookApp
//
//  Created by Erik Sebastian de Erice Jerez on 16/6/25.
//

import Foundation

struct APIError: Codable, Error {
    let error: Bool
    let reason: String
}
