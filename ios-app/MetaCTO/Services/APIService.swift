import Foundation

class APIService {
    static let shared = APIService()
    private init() {}
    
    private let baseURL = "http://localhost:8000"
    private let session = URLSession.shared
    
    // MARK: - Generic Request Method
    private func performRequest<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: Data? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(APIServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add auth token if available
        if let token = AuthService.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(APIServiceError.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(APIServiceError.noData))
                    return
                }
                
                if httpResponse.statusCode >= 400 {
                    // Try to decode error response
                    if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                        completion(.failure(APIServiceError.serverError(apiError.detail)))
                    } else {
                        completion(.failure(APIServiceError.httpError(httpResponse.statusCode)))
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(responseType, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: - Auth API
    func login(email: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let loginRequest = LoginRequest(username: email, password: password)
        
        // For login, we need to use form data instead of JSON
        let formData = "username=\(email)&password=\(password)"
        guard let bodyData = formData.data(using: .utf8) else {
            completion(.failure(APIServiceError.invalidData))
            return
        }
        
        guard let url = URL(string: baseURL + "/auth/login") else {
            completion(.failure(APIServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(APIServiceError.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(APIServiceError.noData))
                    return
                }
                
                if httpResponse.statusCode >= 400 {
                    if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                        completion(.failure(APIServiceError.serverError(apiError.detail)))
                    } else {
                        completion(.failure(APIServiceError.httpError(httpResponse.statusCode)))
                    }
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func register(name: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let registerRequest = RegisterRequest(name: name, email: email, password: password)
        
        guard let bodyData = try? JSONEncoder().encode(registerRequest) else {
            completion(.failure(APIServiceError.invalidData))
            return
        }
        
        performRequest(
            endpoint: "/auth/register",
            method: .POST,
            body: bodyData,
            responseType: User.self,
            completion: completion
        )
    }
    
    // MARK: - Features API
    func getFeatures(page: Int = 1, limit: Int = 10, completion: @escaping (Result<PaginatedFeatures, Error>) -> Void) {
        performRequest(
            endpoint: "/features/?page=\(page)&limit=\(limit)",
            responseType: PaginatedFeatures.self,
            completion: completion
        )
    }
    
    func getFeature(id: Int, completion: @escaping (Result<Feature, Error>) -> Void) {
        performRequest(
            endpoint: "/features/\(id)",
            responseType: Feature.self,
            completion: completion
        )
    }
    
    func createFeature(title: String, description: String?, completion: @escaping (Result<Feature, Error>) -> Void) {
        let createRequest = CreateFeatureRequest(title: title, description: description)
        
        guard let bodyData = try? JSONEncoder().encode(createRequest) else {
            completion(.failure(APIServiceError.invalidData))
            return
        }
        
        performRequest(
            endpoint: "/features/",
            method: .POST,
            body: bodyData,
            responseType: Feature.self,
            completion: completion
        )
    }
    
    // MARK: - Votes API
    func voteFeature(featureId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let voteRequest = VoteRequest(featureId: featureId)
        
        guard let bodyData = try? JSONEncoder().encode(voteRequest) else {
            completion(.failure(APIServiceError.invalidData))
            return
        }
        
        guard let url = URL(string: baseURL + "/votes/") else {
            completion(.failure(APIServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = AuthService.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = bodyData
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(APIServiceError.invalidResponse))
                    return
                }
                
                if httpResponse.statusCode >= 400 {
                    if let data = data,
                       let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                        completion(.failure(APIServiceError.serverError(apiError.detail)))
                    } else {
                        completion(.failure(APIServiceError.httpError(httpResponse.statusCode)))
                    }
                    return
                }
                
                completion(.success(()))
            }
        }.resume()
    }
}

// MARK: - Helper Enums
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

enum APIServiceError: Error, LocalizedError {
    case invalidURL
    case invalidData
    case invalidResponse
    case noData
    case httpError(Int)
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidData:
            return "Invalid data"
        case .invalidResponse:
            return "Invalid response"
        case .noData:
            return "No data"
        case .httpError(let code):
            return "HTTP Error: \(code)"
        case .serverError(let message):
            return message
        }
    }
}