import Foundation

class AuthService {
    static let shared = AuthService()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let accessTokenKey = "access_token"
    private let userKey = "user"
    
    var accessToken: String? {
        get { userDefaults.string(forKey: accessTokenKey) }
        set { 
            if let token = newValue {
                userDefaults.set(token, forKey: accessTokenKey)
            } else {
                userDefaults.removeObject(forKey: accessTokenKey)
            }
        }
    }
    
    var currentUser: User? {
        get {
            guard let userData = userDefaults.data(forKey: userKey) else { return nil }
            return try? JSONDecoder().decode(User.self, from: userData)
        }
        set {
            if let user = newValue {
                let userData = try? JSONEncoder().encode(user)
                userDefaults.set(userData, forKey: userKey)
            } else {
                userDefaults.removeObject(forKey: userKey)
            }
        }
    }
    
    var isLoggedIn: Bool {
        return accessToken != nil && currentUser != nil
    }
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        APIService.shared.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let authResponse):
                // Store the access token
                self?.accessToken = authResponse.accessToken
                
                // For now, create a mock user since the login response doesn't include user data
                // In a real app, you might need to fetch user data after login
                let mockUser = User(
                    id: 1,
                    name: "User",
                    email: email,
                    createdAt: ISO8601DateFormatter().string(from: Date())
                )
                self?.currentUser = mockUser
                completion(.success(mockUser))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func register(name: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        APIService.shared.register(name: name, email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                // After successful registration, log the user in
                self?.login(email: email, password: password, completion: completion)
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logout() {
        accessToken = nil
        currentUser = nil
    }
}