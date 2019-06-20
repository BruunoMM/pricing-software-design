import Foundation

class LoginService {
    static let shared = LoginService()
    var loggedUser: Person?
    
    private init() {}
    
    func isManager() -> Bool {
        return loggedUser?.occupation == Employment.Manager
    }
    
    func isEmployee() -> Bool {
        return loggedUser?.occupation == Employment.Employee
    }
}
