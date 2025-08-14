import Foundation

// MARK: - User Models
struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, email
        case createdAt = "created_at"
    }
}

struct LoginRequest: Codable {
    let username: String // API expects username field for email
    let password: String
}

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct AuthResponse: Codable {
    let accessToken: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

// MARK: - Feature Models
struct Feature: Codable {
    let id: Int
    let title: String
    let description: String?
    let authorId: Int
    let createdAt: String
    let author: User
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, author
        case authorId = "author_id"
        case createdAt = "created_at"
        case voteCount = "vote_count"
    }
}

struct CreateFeatureRequest: Codable {
    let title: String
    let description: String?
}

struct PaginatedFeatures: Codable {
    let items: [Feature]
    let total: Int
    let page: Int
    let limit: Int
    let pages: Int
}

// MARK: - Vote Models
struct VoteRequest: Codable {
    let featureId: Int
    
    enum CodingKeys: String, CodingKey {
        case featureId = "feature_id"
    }
}

// MARK: - API Error
struct APIError: Codable {
    let detail: String
}