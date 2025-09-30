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
            
            // NFC Scan Tab
            NFCView()
                .tabItem {
                    Label("Scan", systemImage: selectedTab == 1 ? "wave.3.right.circle.fill" : "wave.3.right.circle")
                }
                .tag(1)
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: selectedTab == 2 ? "person.circle.fill" : "person.circle")
                }
                .tag(2)
        }
        .accentColor(AppColors.primaryPurple)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
