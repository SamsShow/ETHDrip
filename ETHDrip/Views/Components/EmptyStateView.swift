//
//  EmptyStateView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(AppColors.tertiaryText)
            
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
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                }
                .secondaryButtonStyle()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

#Preview {
    EmptyStateView(
        icon: "calendar.badge.exclamationmark",
        title: "No events found",
        message: "Check back later for new events",
        actionTitle: "Refresh",
        action: {}
    )
}

