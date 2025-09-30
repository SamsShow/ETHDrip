//
//  View+Extensions.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

extension View {
    // Custom button style for primary actions
    func primaryButtonStyle() -> some View {
        self
            .font(AppFonts.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [AppColors.primaryPurple, AppColors.primaryPurpleDark],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(AppCornerRadius.medium)
    }
    
    // Custom button style for secondary actions
    func secondaryButtonStyle() -> some View {
        self
            .font(AppFonts.headline)
            .foregroundColor(AppColors.primaryPurple)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(AppColors.secondaryBackground)
            .cornerRadius(AppCornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .stroke(AppColors.primaryPurple, lineWidth: 2)
            )
    }
    
    // Custom text field style
    func customTextFieldStyle() -> some View {
        self
            .font(AppFonts.body)
            .padding()
            .frame(height: 56)
            .background(AppColors.secondaryBackground)
            .cornerRadius(AppCornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .stroke(AppColors.tertiaryText.opacity(0.3), lineWidth: 1)
            )
    }
    
    // Card style
    func cardStyle() -> some View {
        self
            .background(AppColors.cardBackground)
            .cornerRadius(AppCornerRadius.large)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // Hide keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Custom Text Field
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var icon: String? = nil
    
    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(AppColors.secondaryText)
                    .frame(width: 20)
            }
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(AppFonts.body)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                TextField(placeholder, text: $text)
                    .font(AppFonts.body)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .padding()
        .frame(height: 56)
        .background(AppColors.secondaryBackground)
        .cornerRadius(AppCornerRadius.medium)
    }
}
