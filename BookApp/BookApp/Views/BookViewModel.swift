import SwiftUI

@MainActor
final class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingError = false
    
    private let apiService = BookAPIService.shared
    
    func loadBooks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            books = try await apiService.getAllBooks()
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
        
        isLoading = false
    }
    
    func createBook(title: String, author: String, isbn: String, year: Int) async {
        isLoading = true
        errorMessage = nil
        
        let request = BookRequest(
            title: title,
            author: author,
            isbn: isbn,
            publicationYear: year
        )
        
        do {
            let newBook = try await apiService.createBook(request)
            books.append(newBook)
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
        
        isLoading = false
    }
    
    func updateBook(id: UUID, title: String?, author: String?, isbn: String?, year: Int?) async {
        isLoading = true
        errorMessage = nil
        
        let request = BookRequest(
            title: title,
            author: author,
            isbn: isbn,
            publicationYear: year
        )
        
        do {
            let updatedBook = try await apiService.updateBook(id: id, with: request)
            if let index = books.firstIndex(where: { $0.id == id }) {
                books[index] = updatedBook
            }
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
        
        isLoading = false
    }
    
    func deleteBook(id: UUID) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await apiService.deleteBook(id: id)
            books.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
        showingError = false
    }
    
    func refreshBooks() {
        Task {
            await loadBooks()
        }
    }
}
