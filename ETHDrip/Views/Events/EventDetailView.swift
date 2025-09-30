//
//  EventDetailView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct EventDetailView: View {
    let event: Event
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image
                ZStack(alignment: .topTrailing) {
                    LinearGradient(
                        colors: [
                            AppColors.primaryPurple.opacity(0.7),
                            AppColors.accentPurple.opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 250)
                    
                    StatusBadge(text: event.statusText, isLive: event.isOngoing)
                        .padding(AppSpacing.medium)
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.large) {
                    // Event Info
                    VStack(alignment: .leading, spacing: AppSpacing.medium) {
                        Text(event.name)
                            .font(AppFonts.title)
                            .foregroundColor(AppColors.primaryText)
                        
                        // Location
                        HStack(spacing: AppSpacing.small) {
                            Image(systemName: "location.fill")
                                .foregroundColor(AppColors.primaryPurple)
                            Text(event.location)
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.secondaryText)
                        }
                        
                        // Date
                        HStack(spacing: AppSpacing.small) {
                            Image(systemName: "calendar")
                                .foregroundColor(AppColors.primaryPurple)
                            Text(event.dateRange)
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                    
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("About")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text(event.description)
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.secondaryText)
                            .lineSpacing(4)
                    }
                    
                    Divider()
                    
                    // Stats
                    HStack(spacing: AppSpacing.large) {
                        StatItem(icon: "building.2.fill", value: "\(event.totalBooths)", label: "Booths")
                        StatItem(icon: "bell.badge.fill", value: "\(event.totalNotifications)", label: "Notifications")
                    }
                    
                    // Action Buttons
                    if event.isOngoing || event.isUpcoming {
                        VStack(spacing: AppSpacing.medium) {
                            if event.isOngoing {
                                Button {
                                    // Navigate to NFC verification
                                } label: {
                                    HStack {
                                        Image(systemName: "wave.3.right")
                                        Text("Verify with NFC")
                                    }
                                }
                                .primaryButtonStyle()
                            }
                            
                            Button {
                                // Navigate to booths
                            } label: {
                                HStack {
                                    Image(systemName: "building.2")
                                    Text("View Booths")
                                }
                            }
                            .secondaryButtonStyle()
                            
                            Button {
                                // Navigate to notifications
                            } label: {
                                HStack {
                                    Image(systemName: "bell.fill")
                                    Text("View Notifications")
                                }
                            }
                            .secondaryButtonStyle()
                        }
                    }
                }
                .padding(AppSpacing.large)
            }
        }
        .background(AppColors.background)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Stat Item
struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: AppSpacing.small) {
            HStack(spacing: AppSpacing.small) {
                Image(systemName: icon)
                    .foregroundColor(AppColors.primaryPurple)
                Text(value)
                    .font(AppFonts.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primaryText)
            }
            
            Text(label)
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
    NavigationView {
        EventDetailView(event: Event(
            id: "1",
            name: "ETHGlobal San Francisco",
            description: "The largest Ethereum hackathon in the Bay Area. Join developers from around the world to build the future of Web3.",
            location: "San Francisco, CA",
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 3),
            organizerAddress: "0x123",
            totalBooths: 24,
            totalNotifications: 156,
            isActive: true
        ))
    }
}
