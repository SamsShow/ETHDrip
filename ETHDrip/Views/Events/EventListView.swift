//
//  EventListView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel = EventViewModel()
    @State private var searchText = ""
    
    var filteredEvents: [Event] {
        if searchText.isEmpty {
            return viewModel.events
        }
        return viewModel.events.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.location.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.large) {
                        // Header Section
                        headerSection
                        
                        // Stats Cards
                        statsSection
                        
                        // Featured Events
                        if !viewModel.featuredEvents.isEmpty {
                            featuredSection
                        }
                        
                        // All Events
                        allEventsSection
                    }
                    .padding(.bottom, 100) // Space for tab bar
                }
                .refreshable {
                    await viewModel.refreshEvents()
                }
                
                // Loading State
                if viewModel.isLoading && viewModel.events.isEmpty {
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
                        Image(systemName: "tshirt.fill")
                            .foregroundColor(AppColors.primaryPurple)
                        Text("ETHDrip")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.primaryText)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search events")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Discover Events")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Text("Find hackathons and get real-time swag notifications")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppSpacing.large)
        .padding(.top, AppSpacing.medium)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: AppSpacing.medium) {
            StatsCard(
                icon: "calendar",
                title: "Active",
                value: "\(viewModel.ongoingEvents.count)",
                color: .green
            )
            
            StatsCard(
                icon: "clock.fill",
                title: "Upcoming",
                value: "\(viewModel.upcomingEvents.count)",
                color: AppColors.primaryPurple
            )
            
            StatsCard(
                icon: "bell.badge.fill",
                title: "Notifications",
                value: "\(viewModel.events.reduce(0) { $0 + $1.totalNotifications })",
                color: .orange
            )
        }
        .padding(.horizontal, AppSpacing.large)
    }
    
    // MARK: - Featured Section
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            HStack {
                Text("Featured Events")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, AppSpacing.large)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.medium) {
                    ForEach(viewModel.featuredEvents) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            FeaturedEventCard(event: event)
                                .frame(width: 300)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, AppSpacing.large)
            }
        }
    }
    
    // MARK: - All Events Section
    private var allEventsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            HStack {
                Text("All Events")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(filteredEvents.count)")
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, AppSpacing.large)
            
            if filteredEvents.isEmpty {
                VStack(spacing: AppSpacing.medium) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 50))
                        .foregroundColor(AppColors.tertiaryText)
                    
                    Text("No events found")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.secondaryText)
                    
                    if !searchText.isEmpty {
                        Text("Try adjusting your search")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.tertiaryText)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.extraLarge)
            } else {
                LazyVStack(spacing: AppSpacing.medium) {
                    ForEach(filteredEvents) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            EventCard(event: event)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, AppSpacing.large)
            }
        }
    }
}

#Preview {
    EventListView()
}
