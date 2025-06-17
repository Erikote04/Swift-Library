import SwiftUI

struct EditBookView: View {
    let book: Book
    
    @ObservedObject var viewModel: BookViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var author: String
    @State private var isbn: String
    @State private var yearString: String
    
    init(book: Book, viewModel: BookViewModel) {
        self.book = book
        self.viewModel = viewModel
        self._title = State(initialValue: book.title ?? "")
        self._author = State(initialValue: book.author ?? "")
        self._isbn = State(initialValue: book.isbn ?? "")
        self._yearString = State(initialValue: String(book.publicationYear ?? 0))
    }
    
    private var hasChanges: Bool {
        title != book.title ||
        author != book.author ||
        isbn != book.isbn ||
        yearString != String(book.publicationYear ?? 0)
    }
    
    private var isValidForm: Bool {
        !title.isEmpty && !author.isEmpty && !isbn.isEmpty && !yearString.isEmpty && Int(yearString) != nil
    }
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Update") {
                        updateBook()
                    }
                    .disabled(!isValidForm || !hasChanges || viewModel.isLoading)
                }
                
                ToolbarItem(placement: .destructiveAction) {
                    Button("Delete") {
                        deleteBook()
                    }
                    .tint(.red)
                    .disabled(viewModel.isLoading)
                }
            }
            .disabled(viewModel.isLoading)
        }
    }
    
    private func updateBook() {
        guard let id = book.id else { return }
        guard let year = Int(yearString) else { return }
        
        Task {
            let updatedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
            let updatedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
            let updatedISBN = isbn.trimmingCharacters(in: .whitespacesAndNewlines)
            
            await viewModel.updateBook(
                id: id,
                title: updatedTitle != book.title ? updatedTitle : nil,
                author: updatedAuthor != book.author ? updatedAuthor : nil,
                isbn: updatedISBN != book.isbn ? updatedISBN : nil,
                year: year != book.publicationYear ? year : nil
            )
            
            if viewModel.errorMessage == nil {
                dismiss()
            }
        }
    }
    
    private func deleteBook() {
        guard let id = book.id else { return }
        
        Task {
            await viewModel.deleteBook(id: id)
            
            if viewModel.errorMessage == nil {
                dismiss()
            }
        }
    }
}

#Preview {
    EditBookView(
        book: Book(
            id: UUID(),
            title: "Ejemplo",
            author: "Autor",
            isbn: "123456789",
            publicationYear: 2023
        ),
        viewModel: BookViewModel()
    )
}
