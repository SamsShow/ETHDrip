//
//  FirebaseAuthService.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import Foundation
import Combine

// MARK: - Firebase Auth Service Protocol
protocol AuthServiceProtocol {
    func signUp(email: String, password: String, displayName: String) async throws -> User
    func signIn(email: String, password: String) async throws -> User
    func signOut() throws
    func resetPassword(email: String) async throws
    func getCurrentUser() -> User?
}

// MARK: - Mock Firebase Auth Service (Replace with actual Firebase implementation)
class FirebaseAuthService: AuthServiceProtocol {
    static let shared = FirebaseAuthService()
    
    private var currentUser: User?
    
    private init() {}
    
    func signUp(email: String, password: String, displayName: String) async throws -> User {
        // Validate email
        guard isValidEmail(email) else {
            throw AuthError.invalidEmail
        }
        
        // Validate password
        guard password.count >= 6 else {
            throw AuthError.weakPassword
        }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // TODO: Replace with actual Firebase Auth implementation
        // Example:
        // let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        // let changeRequest = authResult.user.createProfileChangeRequest()
        // changeRequest.displayName = displayName
        // try await changeRequest.commitChanges()
        
        // Mock user creation
        let user = User(
            id: UUID().uuidString,
            email: email,
            displayName: displayName
        )
        
        currentUser = user
        return user
    }
    
    func signIn(email: String, password: String) async throws -> User {
        // Validate email
        guard isValidEmail(email) else {
            throw AuthError.invalidEmail
        }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // TODO: Replace with actual Firebase Auth implementation
        // Example:
        // let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        // return User(from: authResult.user)
        
        // Mock sign in
        let user = User(
            id: UUID().uuidString,
            email: email,
            displayName: "Mock User"
        )
        
        currentUser = user
        return user
    }
    
    func signOut() throws {
        // TODO: Replace with actual Firebase Auth implementation
        // try Auth.auth().signOut()
        
        currentUser = nil
    }
    
    func resetPassword(email: String) async throws {
        guard isValidEmail(email) else {
            throw AuthError.invalidEmail
        }
        
        // TODO: Replace with actual Firebase Auth implementation
        // try await Auth.auth().sendPasswordReset(withEmail: email)
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    func getCurrentUser() -> User? {
        // TODO: Replace with actual Firebase Auth implementation
        // if let firebaseUser = Auth.auth().currentUser {
        //     return User(from: firebaseUser)
        // }
        
        return currentUser
    }
    
    // MARK: - Helper Methods
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
