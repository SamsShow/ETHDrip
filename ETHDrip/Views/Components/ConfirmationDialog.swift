//
//  ConfirmationDialog.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct ConfirmationDialog: View {
    let title: String
    let message: String
    let confirmTitle: String
    let confirmAction: () -> Void
    let cancelAction: () -> Void
    let isDestructive: Bool
    
    init(
        title: String,
        message: String,
        confirmTitle: String = "Confirm",
        isDestructive: Bool = false,
        confirmAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.isDestructive = isDestructive
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: iconName)
                    .font(.system(size: 40))
                    .foregroundColor(iconColor)
            }
            
            // Content
            VStack(spacing: AppSpacing.small) {
                Text(title)
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                
                Text(message)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.medium)
            }
            
            // Buttons
            VStack(spacing: AppSpacing.small) {
                Button(action: confirmAction) {
                    Text(confirmTitle)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(isDestructive ? AppColors.error : AppColors.primaryPurple)
                        .foregroundColor(.white)
                        .cornerRadius(AppCornerRadius.medium)
                }
                
                Button(action: cancelAction) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.secondaryBackground)
                        .foregroundColor(AppColors.primaryText)
                        .cornerRadius(AppCornerRadius.medium)
                }
            }
        }
        .padding(AppSpacing.large)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.large)
        .shadow(color: Color.black.opacity(0.2), radius: 20)
        .padding(AppSpacing.extraLarge)
    }
    
    private var iconColor: Color {
        isDestructive ? AppColors.error : AppColors.warning
    }
    
    private var iconName: String {
        isDestructive ? "exclamationmark.triangle.fill" : "questionmark.circle.fill"
    }
}

// MARK: - Confirmation Dialog Modifier
struct ConfirmationDialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let confirmTitle: String
    let isDestructive: Bool
    let confirmAction: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                
                ConfirmationDialog(
                    title: title,
                    message: message,
                    confirmTitle: confirmTitle,
                    isDestructive: isDestructive,
                    confirmAction: {
                        confirmAction()
                        withAnimation {
                            isPresented = false
                        }
                    },
                    cancelAction: {
                        withAnimation {
                            isPresented = false
                        }
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(), value: isPresented)
    }
}

extension View {
    func confirmationDialog(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmTitle: String = "Confirm",
        isDestructive: Bool = false,
        confirmAction: @escaping () -> Void
    ) -> some View {
        modifier(ConfirmationDialogModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            confirmTitle: confirmTitle,
            isDestructive: isDestructive,
            confirmAction: confirmAction
        ))
    }
}

#Preview {
    VStack {
        Text("Content Behind")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColors.background)
    .overlay(
        ConfirmationDialog(
            title: "Delete Notification?",
            message: "This action cannot be undone. Are you sure you want to proceed?",
            confirmTitle: "Delete",
            isDestructive: true,
            confirmAction: {},
            cancelAction: {}
        )
    )
}

