//
//  StandaloneLeaderboardView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct StandaloneLeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    @State private var selectedFilter: TimeFilter = .global
    
    enum TimeFilter: String, CaseIterable {
        case global = "Global"
        case weekly = "This Week"
        case monthly = "This Month"
        
        var icon: String {
            switch self {
            case .global: return "globe"
            case .weekly: return "calendar.badge.clock"
            case .monthly: return "calendar"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Filter Tabs
                    filterTabs
                    
                    if viewModel.isLoading {
                        LoadingView(message: "Loading leaderboard...")
                    } else if viewModel.errorMessage != nil {
                        ErrorStateView(
                            title: "Failed to load leaderboard",
                            message: viewModel.errorMessage ?? "Unknown error",
                            retryAction: {
                                Task {
                                    await viewModel.loadLeaderboard()
                                }
                            }
                        )
                    } else if viewModel.leaderboard.isEmpty {
                        EmptyStateView(
                            icon: "trophy",
                            title: "No rankings yet",
                            message: "Be the first to post notifications and climb the leaderboard!"
                        )
                    } else {
                        leaderboardList
                    }
                }
            }
            .navigationTitle("Leaderboard")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadLeaderboard()
            }
        }
    }
    
    // MARK: - Filter Tabs
    private var filterTabs: some View {
        HStack(spacing: 0) {
            ForEach(TimeFilter.allCases, id: \.self) { filter in
                Button {
                    withAnimation {
                        selectedFilter = filter
                    }
                } label: {
                    VStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: filter.icon)
                                .font(.caption)
                            Text(filter.rawValue)
                                .font(AppFonts.callout)
                        }
                        
                        Rectangle()
                            .fill(selectedFilter == filter ? AppColors.primaryPurple : Color.clear)
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.small)
                    .foregroundColor(selectedFilter == filter ? AppColors.primaryPurple : AppColors.secondaryText)
                }
            }
        }
        .background(AppColors.secondaryBackground)
    }
    
    // MARK: - Leaderboard List
    private var leaderboardList: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Top 3 Podium
                if viewModel.leaderboard.count >= 3 {
                    podiumView
                }
                
                // Rest of the list
                LazyVStack(spacing: AppSpacing.small) {
                    ForEach(Array(viewModel.leaderboard.enumerated()), id: \.element.id) { index, entry in
                        if index >= 3 {
                            LeaderboardRow(entry: entry)
                                .padding(.horizontal, AppSpacing.large)
                        }
                    }
                }
                .padding(.top, AppSpacing.medium)
            }
            .padding(.bottom, 100)
        }
        .refreshable {
            await viewModel.loadLeaderboard()
        }
    }
    
    // MARK: - Podium View
    private var podiumView: some View {
        HStack(alignment: .bottom, spacing: AppSpacing.small) {
            // 2nd Place
            if viewModel.leaderboard.count > 1 {
                PodiumCard(entry: viewModel.leaderboard[1], rank: 2)
            }
            
            // 1st Place
            PodiumCard(entry: viewModel.leaderboard[0], rank: 1)
            
            // 3rd Place
            if viewModel.leaderboard.count > 2 {
                PodiumCard(entry: viewModel.leaderboard[2], rank: 3)
            }
        }
        .padding(.horizontal, AppSpacing.large)
        .padding(.vertical, AppSpacing.large)
    }
}

#Preview {
    StandaloneLeaderboardView()
}

