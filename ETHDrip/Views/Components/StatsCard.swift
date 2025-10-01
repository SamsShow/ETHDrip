//
//  StatsCard.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct StatsCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppSpacing.small) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(AppFonts.title3)
                .fontWeight(.bold)
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.medium)
    }
}

#Preview {
    HStack(spacing: AppSpacing.medium) {
        StatsCard(icon: "calendar", title: "Active", value: "5", color: .green)
        StatsCard(icon: "clock.fill", title: "Upcoming", value: "12", color: AppColors.primaryPurple)
        StatsCard(icon: "bell.badge.fill", title: "Notifications", value: "234", color: .orange)
    }
    .padding()
    .background(AppColors.background)
}

