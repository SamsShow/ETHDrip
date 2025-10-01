//
//  BoothDetailView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct BoothDetailView: View {
    let booth: Booth
    let eventId: String
    @StateObject private var viewModel = NotificationViewModel()
    @State private var showCreateNotification = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.large) {
                    // Header
                    boothHeader
                    
                    Divider()
                        .padding(.horizontal, AppSpacing.large)
                    
                    // Description
                    boothDescription
                    
                    Divider()
                        .padding(.horizontal, AppSpacing.large)
                    
                    // Stats
                    boothStats
                    
                    // Post Notification Button
                    if booth.isActive {
                        postNotificationButton
                    }
                    
                    // Notifications Feed
                    notificationsFeed
                }
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Booth Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCreateNotification) {
            CreateNotificationView(
                boothId: booth.id,
                boothName: booth.name,
                eventId: eventId
            )
        }
        .task {
            await viewModel.loadNotifications(for: booth.id)
        }
    }
    
    // MARK: - Booth Header
    private var boothHeader: some View {
        VStack(spacing: AppSpacing.medium) {
            // Logo
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primaryPurple, AppColors.accentPurple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: booth.category.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 20)
            
            VStack(spacing: AppSpacing.small) {
                Text(booth.name)
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: AppSpacing.small) {
                    Image(systemName: booth.category.icon)
                        .font(.caption)
                    Text(booth.category.rawValue)
                        .font(AppFonts.callout)
                }
                .foregroundColor(AppColors.secondaryText)
                
                if let location = booth.location {
                    HStack(spacing: AppSpacing.small) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                        Text(location)
                            .font(AppFonts.callout)
                    }
                    .foregroundColor(AppColors.tertiaryText)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.large)
    }
    
    // MARK: - Booth Description
    private var boothDescription: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("About")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            Text(booth.description)
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .lineSpacing(4)
        }
        .padding(.horizontal, AppSpacing.large)
    }
    
    // MARK: - Booth Stats
    private var boothStats: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Activity")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, AppSpacing.large)
            
            HStack(spacing: AppSpacing.medium) {
                StatCard(
                    icon: "bell.badge.fill",
                    value: "\(booth.notificationCount)",
                    label: "Notifications",
                    color: AppColors.primaryPurple
                )
                
                StatCard(
                    icon: booth.isActive ? "checkmark.circle.fill" : "xmark.circle.fill",
                    value: booth.isActive ? "Active" : "Inactive",
                    label: "Status",
                    color: booth.isActive ? .green : .gray
                )
            }
            .padding(.horizontal, AppSpacing.large)
        }
    }
    
    // MARK: - Post Notification Button
    private var postNotificationButton: some View {
        VStack(spacing: AppSpacing.medium) {
            Button {
                showCreateNotification = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Post Swag Notification")
                }
            }
            .primaryButtonStyle()
            .padding(.horizontal, AppSpacing.large)
            
            Text("Notify attendees about available swag at this booth")
                .font(AppFonts.caption)
                .foregroundColor(AppColors.tertiaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.large)
        }
    }
    
    // MARK: - Notifications Feed
    private var notificationsFeed: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            HStack {
                Text("Recent Notifications")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(viewModel.notifications.count)")
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, AppSpacing.large)
            
            if viewModel.isLoading && viewModel.notifications.isEmpty {
                LoadingView(message: "Loading notifications...")
                    .frame(height: 200)
            } else if viewModel.notifications.isEmpty {
                EmptyStateView(
                    icon: "bell.slash",
                    title: "No notifications yet",
                    message: "Be the first to post about swag at this booth!"
                )
                .frame(height: 200)
            } else {
                LazyVStack(spacing: AppSpacing.medium) {
                    ForEach(viewModel.notifications) { notification in
                        NotificationCard(notification: notification)
                    }
                }
                .padding(.horizontal, AppSpacing.large)
            }
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppSpacing.small) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(AppFonts.title3)
                .fontWeight(.bold)
                .foregroundColor(AppColors.primaryText)
            
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
        BoothDetailView(
            booth: Booth(
                id: "1",
                eventId: "event1",
                name: "Chainlink",
                description: "Get exclusive Chainlink swag and learn about decentralized oracles",
                sponsorAddress: "0x123",
                logoURL: nil,
                notificationCount: 12,
                isActive: true,
                location: "Booth #42",
                category: .sponsor
            ),
            eventId: "event1"
        )
        .environmentObject(AuthViewModel())
    }
}

