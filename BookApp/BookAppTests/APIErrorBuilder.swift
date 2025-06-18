import Foundation
@testable import BookApp

class APIErrorBuilder {
    private var error: Bool = false
    private var reason: String = ""
    
    func error(_ error: Bool) -> Self {
        self.error = error
        return self
    }
    
    func reason(_ reason: String) -> Self {
        self.reason = reason
        return self
    }
    
    func build() -> APIError {
        return APIError(
            error: error,
            reason: reason
        )
    }
}
