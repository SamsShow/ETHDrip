//
//  SignupView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AuthViewModel()
    @State private var displayName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    
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
                        // Header
                        VStack(spacing: AppSpacing.small) {
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
                                    .frame(width: 80, height: 80)
                                    .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 15, x: 0, y: 8)
                                
                                Image(systemName: "tshirt.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                            .padding(.top, AppSpacing.medium)
                            
                            Text("Create Account")
                                .font(AppFonts.title)
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Join the ETHDrip community")
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.bottom, AppSpacing.medium)
                        
                        // Sign Up Form
                        VStack(spacing: AppSpacing.medium) {
                            CustomTextField(
                                placeholder: "Display Name",
                                text: $displayName,
                                icon: "person.fill"
                            )
                            .textContentType(.name)
                            
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
                            .textContentType(.newPassword)
                            
                            CustomTextField(
                                placeholder: "Confirm Password",
                                text: $confirmPassword,
                                isSecure: true,
                                icon: "lock.fill"
                            )
                            .textContentType(.newPassword)
                            
                            // Password requirements
                            if !password.isEmpty {
                                HStack(spacing: AppSpacing.small) {
                                    Image(systemName: password.count >= 6 ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(password.count >= 6 ? AppColors.success : AppColors.error)
                                    
                                    Text("At least 6 characters")
                                        .font(AppFonts.footnote)
                                        .foregroundColor(AppColors.secondaryText)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, AppSpacing.small)
                            }
                            
                            if !confirmPassword.isEmpty && !password.isEmpty {
                                HStack(spacing: AppSpacing.small) {
                                    Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(password == confirmPassword ? AppColors.success : AppColors.error)
                                    
                                    Text("Passwords match")
                                        .font(AppFonts.footnote)
                                        .foregroundColor(AppColors.secondaryText)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, AppSpacing.small)
                            }
                            
                            // Terms and Conditions
                            HStack(spacing: AppSpacing.small) {
                                Button {
                                    agreedToTerms.toggle()
                                } label: {
                                    Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                                        .foregroundColor(agreedToTerms ? AppColors.primaryPurple : AppColors.tertiaryText)
                                        .font(.system(size: 24))
                                }
                                
                                Text("I agree to the ")
                                    .font(AppFonts.footnote)
                                    .foregroundColor(AppColors.secondaryText)
                                +
                                Text("Terms & Conditions")
                                    .font(AppFonts.footnote)
                                    .foregroundColor(AppColors.primaryPurple)
                                    .underline()
                                
                                Spacer()
                            }
                            .padding(.top, AppSpacing.small)
                        }
                        .padding(.horizontal, AppSpacing.large)
                        
                        // Sign Up Button
                        Button {
                            hideKeyboard()
                            Task {
                                await viewModel.signUp(email: email, password: password, displayName: displayName)
                                if case .authenticated = viewModel.authState {
                                    dismiss()
                                }
                            }
                        } label: {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Create Account")
                            }
                        }
                        .primaryButtonStyle()
                        .disabled(!isFormValid || viewModel.isLoading)
                        .opacity(isFormValid ? 1.0 : 0.6)
                        .padding(.horizontal, AppSpacing.large)
                        .padding(.top, AppSpacing.small)
                        
                        // Sign In Link
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: AppSpacing.small) {
                                Text("Already have an account?")
                                    .foregroundColor(AppColors.secondaryText)
                                Text("Sign In")
                                    .foregroundColor(AppColors.primaryPurple)
                                    .fontWeight(.semibold)
                            }
                            .font(AppFonts.callout)
                        }
                        .padding(.bottom, AppSpacing.large)
                    }
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
            .alert("Error", isPresented: $viewModel.showError) {
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
    
    private var isFormValid: Bool {
        !displayName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password.count >= 6 &&
        password == confirmPassword &&
        agreedToTerms
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SignupView()
}
