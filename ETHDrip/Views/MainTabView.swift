//
//  MainTabView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home / Events Tab
            EventListView()
                .tabItem {
                    Label("Events", systemImage: selectedTab == 0 ? "calendar.circle.fill" : "calendar.circle")
                }
                .tag(0)
            
            // Leaderboard Tab
            StandaloneLeaderboardView()
                .tabItem {
                    Label("Leaderboard", systemImage: selectedTab == 1 ? "trophy.fill" : "trophy")
                }
                .tag(1)
            
            // NFC Scan Tab
            NFCView()
                .tabItem {
                    Label("Scan", systemImage: selectedTab == 2 ? "wave.3.right.circle.fill" : "wave.3.right.circle")
                }
                .tag(2)
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: selectedTab == 3 ? "person.circle.fill" : "person.circle")
                }
                .tag(3)
        }
        .accentColor(AppColors.primaryPurple)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
