//
//  LoginView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    @State private var showForgotPassword = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        AppColors.primaryPurple.opacity(0.1),
                        AppColors.accentPurple.opacity(0.05),
                        AppColors.background
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.large) {
                        Spacer()
                            .frame(height: 40)
                        
                        // Logo and Title
                        VStack(spacing: AppSpacing.medium) {
                            // T-shirt logo
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [AppColors.primaryPurple, AppColors.accentPurple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                    .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 20, x: 0, y: 10)
                                
                                Image(systemName: "tshirt.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            }
                            
                            Text("ETHDrip")
                                .font(AppFonts.largeTitle)
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Swag notifications for hackathons")
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.bottom, AppSpacing.large)
                        
                        // Login Form
                        VStack(spacing: AppSpacing.medium) {
                            CustomTextField(
                                placeholder: "Email",
                                text: $email,
                                icon: "envelope.fill"
                            )
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            
                            CustomTextField(
                                placeholder: "Password",
                                text: $password,
                                isSecure: true,
                                icon: "lock.fill"
                            )
                            .textContentType(.password)
                            
                            // Forgot Password
                            HStack {
                                Spacer()
                                Button {
                                    showForgotPassword = true
                                } label: {
                                    Text("Forgot Password?")
                                        .font(AppFonts.footnote)
                                        .foregroundColor(AppColors.primaryPurple)
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.large)
                        
                        // Login Button
                        Button {
                            hideKeyboard()
                            Task {
                                await viewModel.signIn(email: email, password: password)
                            }
                        } label: {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign In")
                            }
                        }
                        .primaryButtonStyle()
                        .disabled(viewModel.isLoading || email.isEmpty || password.isEmpty)
                        .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1.0)
                        .padding(.horizontal, AppSpacing.large)
                        .padding(.top, AppSpacing.medium)
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(AppColors.tertiaryText.opacity(0.3))
                                .frame(height: 1)
                            
                            Text("or")
                                .font(AppFonts.footnote)
                                .foregroundColor(AppColors.tertiaryText)
                                .padding(.horizontal, AppSpacing.small)
                            
                            Rectangle()
                                .fill(AppColors.tertiaryText.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.horizontal, AppSpacing.large)
                        .padding(.vertical, AppSpacing.small)
                        
                        // Sign Up Button
                        Button {
                            showSignUp = true
                        } label: {
                            HStack(spacing: AppSpacing.small) {
                                Text("Don't have an account?")
                                    .foregroundColor(AppColors.secondaryText)
                                Text("Sign Up")
                                    .foregroundColor(AppColors.primaryPurple)
                                    .fontWeight(.semibold)
                            }
                            .font(AppFonts.callout)
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSignUp) {
                SignupView()
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
            .alert("Notice", isPresented: $viewModel.showError) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Forgot Password View
struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AuthViewModel()
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                VStack(spacing: AppSpacing.large) {
                    // Header
                    VStack(spacing: AppSpacing.small) {
                        Image(systemName: "lock.rotation")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.primaryPurple)
                            .padding(.bottom, AppSpacing.small)
                        
                        Text("Reset Password")
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Enter your email address and we'll send you a link to reset your password.")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AppSpacing.large)
                    }
                    .padding(.top, AppSpacing.extraLarge)
                    
                    // Email Input
                    CustomTextField(
                        placeholder: "Email",
                        text: $email,
                        icon: "envelope.fill"
                    )
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal, AppSpacing.large)
                    
                    // Reset Button
                    Button {
                        Task {
                            await viewModel.resetPassword(email: email)
                            if viewModel.errorMessage?.contains("sent") == true {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    dismiss()
                                }
                            }
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Send Reset Link")
                        }
                    }
                    .primaryButtonStyle()
                    .disabled(viewModel.isLoading || email.isEmpty)
                    .opacity(email.isEmpty ? 0.6 : 1.0)
                    .padding(.horizontal, AppSpacing.large)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(AppColors.primaryText)
                    }
                }
            }
            .alert("Notice", isPresented: $viewModel.showError) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
