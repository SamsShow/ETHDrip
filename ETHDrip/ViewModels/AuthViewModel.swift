//
//  AuthViewModel.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var authState: AuthState = .unauthenticated
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Dependencies
    private let authService: AuthServiceProtocol
    
    // MARK: - Initialization
    init(authService: AuthServiceProtocol = FirebaseAuthService.shared) {
        self.authService = authService
        checkAuthState()
    }
    
    // MARK: - Auth Methods
    func signUp(email: String, password: String, displayName: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signUp(email: email, password: password, displayName: displayName)
            authState = .authenticated(user)
            isLoading = false
        } catch let error as AuthError {
            handleError(error)
        } catch {
            handleError(.unknown(error.localizedDescription))
        }
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signIn(email: email, password: password)
            authState = .authenticated(user)
            isLoading = false
        } catch let error as AuthError {
            handleError(error)
        } catch {
            handleError(.unknown(error.localizedDescription))
        }
    }
    
    func signOut() {
        do {
            try authService.signOut()
            authState = .unauthenticated
        } catch {
            handleError(.unknown("Failed to sign out"))
        }
    }
    
    func resetPassword(email: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.resetPassword(email: email)
            isLoading = false
            errorMessage = "Password reset email sent! Check your inbox."
            showError = true
        } catch let error as AuthError {
            handleError(error)
        } catch {
            handleError(.unknown(error.localizedDescription))
        }
    }
    
    // MARK: - Helper Methods
    private func checkAuthState() {
        if let user = authService.getCurrentUser() {
            authState = .authenticated(user)
        } else {
            authState = .unauthenticated
        }
    }
    
    private func handleError(_ error: AuthError) {
        isLoading = false
        errorMessage = error.errorDescription
        showError = true
    }
    
    func clearError() {
        errorMessage = nil
        showError = false
    }
}
