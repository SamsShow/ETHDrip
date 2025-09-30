//
//  EventCard.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

// MARK: - Featured Event Card
struct FeaturedEventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Event Image
            ZStack(alignment: .topTrailing) {
                // Gradient placeholder
                LinearGradient(
                    colors: [
                        AppColors.primaryPurple.opacity(0.6),
                        AppColors.accentPurple.opacity(0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 180)
                
                // Status Badge
                StatusBadge(text: event.statusText, isLive: event.isOngoing)
                    .padding(AppSpacing.medium)
            }
            
            // Event Info
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text(event.name)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(2)
                
                HStack(spacing: AppSpacing.small) {
                    Label(event.location, systemImage: "location.fill")
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    Label("\(event.totalBooths) booths", systemImage: "building.2.fill")
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                HStack(spacing: AppSpacing.small) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(event.shortDateRange)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    if event.totalNotifications > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "bell.badge.fill")
                                .font(.caption)
                                .foregroundColor(AppColors.primaryPurple)
                            Text("\(event.totalNotifications)")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.primaryPurple)
                        }
                    }
                }
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.large)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

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

// MARK: - Status Badge
struct StatusBadge: View {
    let text: String
    let isLive: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            if isLive {
                Circle()
                    .fill(Color.green)
                    .frame(width: 6, height: 6)
            }
            
            Text(text)
                .font(AppFonts.caption)
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(isLive ? Color.green.opacity(0.9) : AppColors.primaryPurple)
        )
    }
}

// MARK: - Stats Card
struct StatsCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppSpacing.small) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(AppFonts.title3)
                .fontWeight(.bold)
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.medium)
    }
}

#Preview {
    VStack(spacing: 20) {
        FeaturedEventCard(event: Event(
            id: "1",
            name: "ETHGlobal San Francisco",
            description: "The largest Ethereum hackathon",
            location: "San Francisco, CA",
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 3),
            organizerAddress: "0x123",
            totalBooths: 24,
            totalNotifications: 156,
            isActive: true
        ))
        
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
