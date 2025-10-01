//
//  FeaturedEventCard.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct FeaturedEventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Hero Image with Gradient
            ZStack(alignment: .topTrailing) {
                LinearGradient(
                    colors: [
                        AppColors.primaryPurple.opacity(0.8),
                        AppColors.accentPurple.opacity(0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 150)
                
                StatusBadge(text: event.statusText, isLive: event.isOngoing)
                    .padding(AppSpacing.small)
            }
            
            // Event Info
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text(event.name)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                    Text(event.location)
                        .font(AppFonts.caption)
                }
                .foregroundColor(AppColors.secondaryText)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                    Text(event.shortDateRange)
                        .font(AppFonts.caption)
                }
                .foregroundColor(AppColors.tertiaryText)
                
                Divider()
                    .padding(.vertical, 4)
                
                HStack {
                    Label("\(event.totalBooths)", systemImage: "building.2.fill")
                    Spacer()
                    Label("\(event.totalNotifications)", systemImage: "bell.badge.fill")
                }
                .font(AppFonts.caption)
                .foregroundColor(AppColors.primaryPurple)
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.large)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    FeaturedEventCard(event: Event(
        id: "1",
        name: "ETHGlobal San Francisco 2025",
        description: "The largest Ethereum hackathon",
        location: "San Francisco, CA",
        startDate: Date(),
        endDate: Date().addingTimeInterval(86400 * 3),
        organizerAddress: "0x123",
        totalBooths: 24,
        totalNotifications: 156,
        isActive: true
    ))
    .frame(width: 300)
    .padding()
    .background(AppColors.background)
}

