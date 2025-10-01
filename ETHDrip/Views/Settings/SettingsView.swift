//
//  SettingsView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @State private var selectedNetwork: NetworkEnvironment = .baseSepolia
    @State private var showLogoutAlert = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    // Account Section
                    accountSection
                    
                    // Network Section
                    networkSection
                    
                    // Preferences Section
                    preferencesSection
                    
                    // About Section
                    aboutSection
                    
                    // Danger Zone
                    dangerZoneSection
                }
                .padding(AppSpacing.large)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .alert("Sign Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                authViewModel.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
    
    // MARK: - Account Section
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            SectionHeader(title: "Account")
            
            VStack(spacing: AppSpacing.small) {
                SettingsItem(
                    icon: "person.circle.fill",
                    title: "Profile",
                    subtitle: "Manage your profile information"
                ) {
                    // Navigate to profile edit
                }
                
                SettingsItem(
                    icon: "wallet.pass.fill",
                    title: "Wallet Settings",
                    subtitle: "Manage connected wallets"
                ) {
                    // Navigate to wallet settings
                }
                
                SettingsItem(
                    icon: "shield.fill",
                    title: "Privacy & Security",
                    subtitle: "Control your data and security"
                ) {
                    // Navigate to privacy settings
                }
            }
        }
    }
    
    // MARK: - Network Section
    private var networkSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            SectionHeader(title: "Network")
            
            VStack(spacing: 0) {
                NetworkRow(
                    network: .baseSepolia,
                    isSelected: selectedNetwork == .baseSepolia
                ) {
                    selectedNetwork = .baseSepolia
                }
                
                Divider()
                    .padding(.leading, 50)
                
                NetworkRow(
                    network: .baseMainnet,
                    isSelected: selectedNetwork == .baseMainnet
                ) {
                    selectedNetwork = .baseMainnet
                }
            }
            .background(AppColors.cardBackground)
            .cornerRadius(AppCornerRadius.medium)
            
            Text("⚠️ Always use Base Sepolia for testing")
                .font(AppFonts.caption)
                .foregroundColor(AppColors.warning)
                .padding(.horizontal, AppSpacing.small)
        }
    }
    
    // MARK: - Preferences Section
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            SectionHeader(title: "Preferences")
            
            VStack(spacing: AppSpacing.small) {
                ToggleSettingsItem(
                    icon: "bell.badge.fill",
                    title: "Push Notifications",
                    subtitle: "Get notified about new swag",
                    isOn: $notificationsEnabled
                )
                
                ToggleSettingsItem(
                    icon: "moon.fill",
                    title: "Dark Mode",
                    subtitle: "Use dark color scheme",
                    isOn: $isDarkMode
                )
            }
        }
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            SectionHeader(title: "About")
            
            VStack(spacing: AppSpacing.small) {
                SettingsItem(
                    icon: "info.circle.fill",
                    title: "About ETHDrip",
                    subtitle: "Version 1.0.0 (Beta)"
                ) {
                    // Show about screen
                }
                
                SettingsItem(
                    icon: "doc.text.fill",
                    title: "Terms of Service",
                    subtitle: "Read our terms"
                ) {
                    // Open terms
                }
                
                SettingsItem(
                    icon: "hand.raised.fill",
                    title: "Privacy Policy",
                    subtitle: "Read our privacy policy"
                ) {
                    // Open privacy policy
                }
                
                SettingsItem(
                    icon: "questionmark.circle.fill",
                    title: "Help & Support",
                    subtitle: "Get help and contact support"
                ) {
                    // Open help
                }
            }
        }
    }
    
    // MARK: - Danger Zone
    private var dangerZoneSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            SectionHeader(title: "Danger Zone")
            
            Button {
                showLogoutAlert = true
            } label: {
                HStack {
                    Image(systemName: "arrow.right.square.fill")
                        .font(.title3)
                        .foregroundColor(AppColors.error)
                        .frame(width: 30)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Sign Out")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.error)
                        
                        Text("Sign out from your account")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                }
                .padding(AppSpacing.medium)
                .background(AppColors.cardBackground)
                .cornerRadius(AppCornerRadius.medium)
            }
        }
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(AppFonts.headline)
            .foregroundColor(AppColors.primaryText)
    }
}

// MARK: - Settings Item
struct SettingsItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(AppColors.primaryPurple)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(subtitle)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                
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
}

// MARK: - Toggle Settings Item
struct ToggleSettingsItem: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(AppColors.primaryPurple)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryText)
                
                Text(subtitle)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(AppSpacing.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.medium)
    }
}

// MARK: - Network Row
struct NetworkRow: View {
    let network: NetworkEnvironment
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "network")
                    .font(.title3)
                    .foregroundColor(AppColors.primaryPurple)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(network == .baseSepolia ? "Base Sepolia" : "Base Mainnet")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Chain ID: \(network.chainId)")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppColors.success)
                }
            }
            .padding(AppSpacing.medium)
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
            .environmentObject(AuthViewModel())
    }
}

