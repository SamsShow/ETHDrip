//
//  NotificationFeedView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct NotificationFeedView: View {
    let eventId: String
    @StateObject private var viewModel = NotificationViewModel()
    @State private var sortOption: SortOption = .recent
    @State private var showSortMenu = false
    
    enum SortOption: String, CaseIterable {
        case recent = "Most Recent"
        case popular = "Most Popular"
        case oldest = "Oldest First"
        
        var icon: String {
            switch self {
            case .recent: return "clock.fill"
            case .popular: return "flame.fill"
            case .oldest: return "clock.arrow.circlepath"
            }
        }
    }
    
    var sortedNotifications: [SwagNotification] {
        switch sortOption {
        case .recent:
            return viewModel.notifications.sorted { $0.timestamp > $1.timestamp }
        case .popular:
            return viewModel.notifications.sorted { $0.upvotes > $1.upvotes }
        case .oldest:
            return viewModel.notifications.sorted { $0.timestamp < $1.timestamp }
        }
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Sort Bar
                sortBar
                
                if viewModel.isLoading && viewModel.notifications.isEmpty {
                    LoadingView(message: "Loading notifications...")
                } else if viewModel.error != nil {
                    ErrorStateView(
                        title: "Failed to load notifications",
                        message: viewModel.error?.localizedDescription ?? "Unknown error",
                        retryAction: {
                            Task {
                                await viewModel.loadNotifications(for: eventId)
                            }
                        }
                    )
                } else if viewModel.notifications.isEmpty {
                    EmptyStateView(
                        icon: "bell.slash",
                        title: "No notifications yet",
                        message: "Be the first to post about swag availability!"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppSpacing.medium) {
                            ForEach(sortedNotifications) { notification in
                                NotificationCard(notification: notification)
                            }
                        }
                        .padding(AppSpacing.large)
                    }
                    .refreshable {
                        await viewModel.loadNotifications(for: eventId)
                    }
                }
            }
        }
        .navigationTitle("Swag Feed")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadNotifications(for: eventId)
        }
    }
    
    // MARK: - Sort Bar
    private var sortBar: some View {
        HStack {
            Text("Sort by:")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
            
            Menu {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button {
                        sortOption = option
                    } label: {
                        HStack {
                            Image(systemName: option.icon)
                            Text(option.rawValue)
                            if sortOption == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: sortOption.icon)
                    Text(sortOption.rawValue)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .font(AppFonts.callout)
                .foregroundColor(AppColors.primaryPurple)
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.large)
        .padding(.vertical, AppSpacing.small)
        .background(AppColors.secondaryBackground)
    }
}

// MARK: - Notification Card
struct NotificationCard: View {
    let notification: SwagNotification
    @State private var hasUpvoted = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(notification.title)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "building.2.fill")
                            .font(.caption2)
                        Text(notification.boothName)
                            .font(AppFonts.caption)
                    }
                    .foregroundColor(AppColors.primaryPurple)
                }
                
                Spacer()
                
                Text(notification.timeAgo)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.tertiaryText)
            }
            
            // Description
            Text(notification.description)
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .lineSpacing(4)
            
            // Image if available
            if let imageURL = notification.imageURL {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(AppCornerRadius.medium)
                    case .failure:
                        ZStack {
                            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                .fill(AppColors.cardBackground)
                                .frame(height: 200)
                            Image(systemName: "photo")
                                .foregroundColor(AppColors.tertiaryText)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            // Footer
            HStack {
                // Notifier
                HStack(spacing: 4) {
                    Image(systemName: "person.circle.fill")
                        .font(.caption)
                    Text(notification.notifierName ?? formatAddress(notification.notifierAddress))
                        .font(AppFonts.caption)
                }
                .foregroundColor(AppColors.secondaryText)
                
                Spacer()
                
                // Upvote Button
                Button {
                    hasUpvoted.toggle()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: hasUpvoted ? "hand.thumbsup.fill" : "hand.thumbsup")
                        Text("\(notification.upvotes + (hasUpvoted ? 1 : 0))")
                    }
                    .font(AppFonts.callout)
                    .foregroundColor(hasUpvoted ? AppColors.primaryPurple : AppColors.secondaryText)
                }
            }
        }
        .padding(AppSpacing.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.medium)
    }
    
    private func formatAddress(_ address: String) -> String {
        guard address.count > 10 else { return address }
        return "\(address.prefix(6))...\(address.suffix(4))"
    }
}

#Preview {
    NavigationView {
        NotificationFeedView(eventId: "event1")
    }
}

