//
//  BoothListView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct BoothListView: View {
    let event: Event
    @StateObject private var viewModel = BoothViewModel()
    @State private var searchText = ""
    @State private var selectedCategory: BoothCategory? = nil
    
    var filteredBooths: [Booth] {
        var booths = viewModel.booths
        
        // Filter by category
        if let category = selectedCategory {
            booths = booths.filter { $0.category == category }
        }
        
        // Filter by search
        if !searchText.isEmpty {
            booths = booths.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return booths
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Category Filter
                categoryFilter
                
                if viewModel.isLoading && viewModel.booths.isEmpty {
                    LoadingView(message: "Loading booths...")
                } else if viewModel.error != nil {
                    ErrorStateView(
                        title: "Failed to load booths",
                        message: viewModel.error?.localizedDescription ?? "Unknown error",
                        retryAction: {
                            Task {
                                await viewModel.loadBooths(for: event.id)
                            }
                        }
                    )
                } else if filteredBooths.isEmpty {
                    EmptyStateView(
                        icon: "building.2",
                        title: "No booths found",
                        message: searchText.isEmpty ? "Check back later for booth updates" : "Try adjusting your search or filters"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppSpacing.medium) {
                            ForEach(filteredBooths) { booth in
                                NavigationLink(destination: BoothDetailView(booth: booth, eventId: event.id)) {
                                    BoothCard(booth: booth)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(AppSpacing.large)
                    }
                    .refreshable {
                        await viewModel.loadBooths(for: event.id)
                    }
                }
            }
        }
        .navigationTitle("Booths")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search booths")
        .task {
            await viewModel.loadBooths(for: event.id)
        }
    }
    
    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.small) {
                CategoryChip(
                    title: "All",
                    icon: "square.grid.2x2",
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                ForEach(BoothCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, AppSpacing.large)
            .padding(.vertical, AppSpacing.small)
        }
        .background(AppColors.secondaryBackground)
    }
}

// MARK: - Booth Card
struct BoothCard: View {
    let booth: Booth
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            HStack(alignment: .top) {
                // Logo placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: AppCornerRadius.small)
                        .fill(AppColors.primaryPurple.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: booth.category.icon)
                        .font(.title2)
                        .foregroundColor(AppColors.primaryPurple)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(booth.name)
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        if booth.isActive {
                            StatusBadge(text: "Active", isLive: true)
                        }
                    }
                    
                    Text(booth.category.rawValue)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                    
                    if let location = booth.location {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.caption)
                            Text(location)
                                .font(AppFonts.caption)
                        }
                        .foregroundColor(AppColors.tertiaryText)
                    }
                }
            }
            
            Text(booth.description)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(2)
            
            HStack {
                Label("\(booth.notificationCount)", systemImage: "bell.badge.fill")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.primaryPurple)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.tertiaryText)
            }
        }
        .padding(AppSpacing.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.medium)
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(AppFonts.callout)
            }
            .padding(.horizontal, AppSpacing.medium)
            .padding(.vertical, AppSpacing.small)
            .background(chipBackground)
            .foregroundColor(isSelected ? .white : AppColors.primaryText)
            .cornerRadius(AppCornerRadius.large)
        }
    }
    
    @ViewBuilder
    private var chipBackground: some View {
        if isSelected {
            LinearGradient(
                colors: [AppColors.primaryPurple, AppColors.accentPurple],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            AppColors.cardBackground
        }
    }
}

#Preview {
    NavigationView {
        BoothListView(event: Event(
            id: "1",
            name: "ETHGlobal SF",
            description: "Test event",
            location: "San Francisco",
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400),
            organizerAddress: "0x123",
            totalBooths: 10,
            totalNotifications: 50,
            isActive: true
        ))
    }
}

