//
//  ErrorStateView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct ErrorStateView: View {
    let title: String
    let message: String
    let retryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            ZStack {
                Circle()
                    .fill(AppColors.error.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.error)
            }
            
            VStack(spacing: AppSpacing.small) {
                Text(title)
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                
                Text(message)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.extraLarge)
            }
            
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Try Again")
                    }
                }
                .primaryButtonStyle()
                .padding(.horizontal, AppSpacing.extraLarge)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

#Preview {
    ErrorStateView(
        title: "Failed to load",
        message: "Something went wrong. Please try again.",
        retryAction: {}
    )
}

