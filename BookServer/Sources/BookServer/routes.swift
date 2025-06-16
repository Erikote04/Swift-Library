import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "Book API Server is running!"
    }

    try app.register(collection: BookController())
}
