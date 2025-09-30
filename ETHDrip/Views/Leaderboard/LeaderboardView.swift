//
//  LeaderboardView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    @State private var selectedFilter: LeaderboardFilter = .global
    let eventId: String?
    
    init(eventId: String? = nil) {
        self.eventId = eventId
    }
    
    var body: some View {
        ZStack {
            // Background
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    // Header
                    headerSection
                    
                    // Filter Tabs
                    if eventId != nil {
                        filterSection
                    }
                    
                    // Top 3 Podium
                    if !viewModel.topThree.isEmpty {
                        podiumSection
                    }
                    
                    // Remaining Rankings
                    if !viewModel.remaining.isEmpty {
                        rankingsSection
                    }
                    
                    // Empty State
                    if viewModel.leaderboard.isEmpty && !viewModel.isLoading {
                        LeaderboardEmptyState()
                    }
                }
                .padding(.bottom, eventId == nil ? 100 : 20) // Extra padding if in tab view
            }
            .refreshable {
                await viewModel.refreshLeaderboard()
            }
            
            // Loading State
            if viewModel.isLoading && viewModel.leaderboard.isEmpty {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.background.opacity(0.8))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                    Text("Leaderboard")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .onAppear {
            if let eventId = eventId {
                viewModel.loadLeaderboard(eventId: eventId)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Top Contributors")
                .font(AppFonts.title)
                .foregroundColor(AppColors.primaryText)
            
            Text("Users who posted the most swag notifications")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppSpacing.large)
        .padding(.top, AppSpacing.medium)
    }
    
    // MARK: - Filter Section
    private var filterSection: some View {
        HStack(spacing: AppSpacing.small) {
            ForEach(LeaderboardFilter.allCases, id: \.self) { filter in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedFilter = filter
                        viewModel.filterChanged(filter)
                    }
                } label: {
                    Text(filter.rawValue)
                        .font(AppFonts.callout)
                        .fontWeight(selectedFilter == filter ? .semibold : .regular)
                        .foregroundColor(selectedFilter == filter ? .white : AppColors.primaryText)
                        .padding(.horizontal, AppSpacing.large)
                        .padding(.vertical, AppSpacing.small)
                        .background(
                            Capsule()
                                .fill(selectedFilter == filter ? AppColors.primaryPurple : AppColors.secondaryBackground)
                        )
                }
            }
        }
        .padding(.horizontal, AppSpacing.large)
    }
    
    // MARK: - Podium Section (Top 3)
    private var podiumSection: some View {
        VStack(spacing: AppSpacing.medium) {
            // Section Title
            HStack {
                Text("🏆 Top 3")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                Spacer()
            }
            .padding(.horizontal, AppSpacing.large)
            
            // Podium - 2nd, 1st, 3rd arrangement
            HStack(alignment: .bottom, spacing: 12) {
                // 2nd Place
                if viewModel.topThree.count > 1 {
                    PodiumCard(entry: viewModel.topThree[1], rank: 2)
                }
                
                // 1st Place (centered and taller)
                if viewModel.topThree.count > 0 {
                    PodiumCard(entry: viewModel.topThree[0], rank: 1)
                }
                
                // 3rd Place
                if viewModel.topThree.count > 2 {
                    PodiumCard(entry: viewModel.topThree[2], rank: 3)
                }
            }
            .padding(.horizontal, AppSpacing.large)
        }
    }
    
    // MARK: - Rankings Section
    private var rankingsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            HStack {
                Text("All Rankings")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(viewModel.leaderboard.count) users")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, AppSpacing.large)
            
            LazyVStack(spacing: AppSpacing.small) {
                ForEach(viewModel.remaining) { entry in
                    LeaderboardRow(entry: entry)
                }
            }
            .padding(.horizontal, AppSpacing.large)
        }
    }
}

// MARK: - Standalone Leaderboard (For Tab View)
struct StandaloneLeaderboardView: View {
    var body: some View {
        NavigationView {
            LeaderboardView(eventId: nil)
        }
    }
}

#Preview {
    NavigationView {
        LeaderboardView(eventId: nil)
    }
}

