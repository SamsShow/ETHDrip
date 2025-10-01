//
//  StatusBadge.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct StatusBadge: View {
    let text: String
    let isLive: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            if isLive {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
            }
            
            Text(text)
                .font(AppFonts.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, AppSpacing.small)
        .padding(.vertical, 6)
        .background(
            isLive ?
                Color.green.opacity(0.2) :
                AppColors.cardBackground
        )
        .foregroundColor(
            isLive ?
                Color.green :
                AppColors.secondaryText
        )
        .cornerRadius(AppCornerRadius.small)
    }
}

#Preview {
    VStack {
        StatusBadge(text: "Live Now", isLive: true)
        StatusBadge(text: "Upcoming", isLive: false)
        StatusBadge(text: "Ended", isLive: false)
    }
    .padding()
    .background(AppColors.background)
}

