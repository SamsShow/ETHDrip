//
//  UserModel.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var email: String
    var displayName: String?
    var walletAddress: String?
    var isVerified: Bool = false
    var notificationCount: Int = 0
    var createdAt: Date
    
    init(id: String, email: String, displayName: String? = nil, walletAddress: String? = nil) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.walletAddress = walletAddress
        self.createdAt = Date()
    }
}

// MARK: - Auth State
enum AuthState {
    case authenticated(User)
    case unauthenticated
    case loading
}

// MARK: - Auth Error
enum AuthError: LocalizedError {
    case invalidEmail
    case weakPassword
    case emailAlreadyInUse
    case userNotFound
    case wrongPassword
    case networkError
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address."
        case .weakPassword:
            return "Password must be at least 6 characters long."
        case .emailAlreadyInUse:
            return "This email is already registered. Please sign in instead."
        case .userNotFound:
            return "No account found with this email."
        case .wrongPassword:
            return "Incorrect password. Please try again."
        case .networkError:
            return "Network error. Please check your connection."
        case .unknown(let message):
            return message
        }
    }
}
