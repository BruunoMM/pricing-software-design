import Foundation

class LoginService {
    static let shared = LoginService()
    var loggedUser: Person?
    
    private init() {}
}
