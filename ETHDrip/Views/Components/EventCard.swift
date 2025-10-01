//
//  EventCard.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

// MARK: - Regular Event Card
struct EventCard: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            // Event Icon/Image
            ZStack {
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.primaryPurple.opacity(0.6),
                                AppColors.accentPurple.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
            
            // Event Info
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(event.name)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    StatusBadge(text: event.statusText, isLive: event.isOngoing)
                }
                
                Label(event.location, systemImage: "location.fill")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(1)
                
                HStack(spacing: AppSpacing.medium) {
                    Label(event.shortDateRange, systemImage: "calendar")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                    
                    if event.totalNotifications > 0 {
                        Label("\(event.totalNotifications)", systemImage: "bell.fill")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.primaryPurple)
                    }
                }
            }
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppColors.tertiaryText)
        }
        .padding(AppSpacing.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.medium)
    }
}

#Preview {
    VStack(spacing: 20) {
        EventCard(event: Event(
            id: "2",
            name: "ETHDenver 2025",
            description: "The world's largest Web3 #BUIDLathon",
            location: "Denver, CO",
            startDate: Date().addingTimeInterval(86400 * 15),
            endDate: Date().addingTimeInterval(86400 * 18),
            organizerAddress: "0x123",
            totalBooths: 48,
            totalNotifications: 0,
            isActive: true
        ))
    }
    .padding()
    .background(AppColors.background)
}
