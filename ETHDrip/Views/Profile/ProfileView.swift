//
//  ProfileView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var userStats = UserStats()
    @State private var walletConnected = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.large) {
                        // Profile Header
                        profileHeader
                        
                        // Wallet Section
                        walletSection
                        
                        // Stats Section
                        statsSection
                        
                        // Actions
                        actionsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, AppSpacing.large)
                    .padding(.top, AppSpacing.medium)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: AppSpacing.medium) {
            // Avatar
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
                
                if let user = getCurrentUser() {
                    Text(user.displayName?.prefix(1).uppercased() ?? "U")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
            }
            
            // User Info
            if let user = getCurrentUser() {
                VStack(spacing: 4) {
                    Text(user.displayName ?? "User")
                        .font(AppFonts.title3)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(user.email)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(.vertical, AppSpacing.medium)
    }
    
    // MARK: - Wallet Section
    private var walletSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Wallet")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            if walletConnected {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Connected")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.success)
                        Text("0x1234...5678")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    Spacer()
                    
                    Button {
                        walletConnected = false
                    } label: {
                        Text("Disconnect")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.error)
                    }
                }
                .padding(AppSpacing.medium)
                .background(AppColors.cardBackground)
                .cornerRadius(AppCornerRadius.medium)
            } else {
                Button {
                    // TODO: Connect wallet
                    walletConnected = true
                } label: {
                    HStack {
                        Image(systemName: "wallet.pass.fill")
                        Text("Connect Wallet")
                    }
                }
                .primaryButtonStyle()
            }
        }
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Your Stats")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: AppSpacing.medium) {
                StatRow(icon: "bell.badge.fill", label: "Notifications Posted", value: "\(userStats.totalNotifications)", color: AppColors.primaryPurple)
                StatRow(icon: "hand.thumbsup.fill", label: "Upvotes Received", value: "\(userStats.totalUpvotes)", color: .orange)
                StatRow(icon: "calendar.badge.checkmark", label: "Events Attended", value: "\(userStats.eventsAttended)", color: .green)
                
                if let rank = userStats.rank {
                    StatRow(icon: "trophy.fill", label: "Global Rank", value: "#\(rank)", color: .yellow)
                }
            }
            .padding(AppSpacing.medium)
            .background(AppColors.cardBackground)
            .cornerRadius(AppCornerRadius.medium)
        }
    }
    
    // MARK: - Actions Section
    private var actionsSection: some View {
        VStack(spacing: AppSpacing.medium) {
            NavigationLink(destination: Text("Settings")) {
                SettingsRow(icon: "gearshape.fill", title: "Settings", color: AppColors.primaryPurple)
            }
            
            NavigationLink(destination: Text("Help & Support")) {
                SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", color: .blue)
            }
            
            Button {
                authViewModel.signOut()
            } label: {
                SettingsRow(icon: "arrow.right.square.fill", title: "Sign Out", color: AppColors.error)
            }
        }
    }
    
    // MARK: - Helpers
    private func getCurrentUser() -> User? {
        if case .authenticated(let user) = authViewModel.authState {
            return user
        }
        return nil
    }
}

// MARK: - Stat Row
struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(label)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text(value)
                .font(AppFonts.callout)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.primaryText)
        }
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(title)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
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
    ProfileView()
        .environmentObject(AuthViewModel())
}
