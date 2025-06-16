//
//  AddBookView.swift
//  BookApp
//
//  Created by Erik Sebastian de Erice Jerez on 16/6/25.
//

import SwiftUI

struct AddBookView: View {
    @ObservedObject var viewModel: BookViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var isbn = ""
    @State private var yearString = ""
    
    private var isValidForm: Bool {
        !title.isEmpty && !author.isEmpty && !isbn.isEmpty && !yearString.isEmpty && Int(yearString) != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Book Details")) {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Author", text: $author)
                        .textInputAutocapitalization(.words)
                    
                    TextField("ISBN", text: $isbn)
                        .keyboardType(.default)
                    
                    TextField("Publication Year", text: $yearString)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveBook()
                    }
                    .disabled(!isValidForm || viewModel.isLoading)
                }
            }
            .disabled(viewModel.isLoading)
        }
    }
    
    private func saveBook() {
        guard let year = Int(yearString) else { return }
        
        Task {
            await viewModel.createBook(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                author: author.trimmingCharacters(in: .whitespacesAndNewlines),
                isbn: isbn.trimmingCharacters(in: .whitespacesAndNewlines),
                year: year
            )
            
            if viewModel.errorMessage == nil {
                dismiss()
            }
        }
    }
}

#Preview {
    AddBookView(viewModel: BookViewModel())
}
