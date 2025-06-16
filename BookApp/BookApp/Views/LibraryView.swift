//
//  ContentView.swift
//  BookApp
//
//  Created by Erik Sebastian de Erice Jerez on 16/6/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BookViewModel()
    @State private var showingAddSheet = false
    @State private var selectedBook: Book?
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.books) { book in
                        BookRowView(book: book) {
                            selectedBook = book
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Delete", role: .destructive) {
                                Task {
                                    await viewModel.deleteBook(id: book.id)
                                }
                            }
                        }
                    }
                }
                .refreshable {
                    await viewModel.loadBooks()
                }
                
                if viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView("Loading...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("My Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add", systemImage: "plus") {
                        showingAddSheet = true
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                // TODO: AddBookView
            }
            .sheet(item: $selectedBook) { book in
                // TODO: EditBookView
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown Error")
            }
            .task {
                await viewModel.loadBooks()
            }
        }
    }
}

struct BookRowView: View {
    let book: Book
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(book.title)
                .font(.headline)
                .lineLimit(2)
            
            Text("por \(book.author)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Text("ISBN: \(book.isbn)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(book.publicationYear)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    ContentView()
}
