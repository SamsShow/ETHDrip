//
//  ContentView.swift
//  ETHDrip
//
//  Created by Saksham Tyagi on 30/09/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    AppColors.primaryPurple.opacity(0.1),
                    AppColors.background
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: AppSpacing.large) {
                Spacer()
                
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
                        .frame(width: 120, height: 120)
                        .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: "tshirt.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                }
                
                Text("Welcome to ETHDrip!")
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.primaryText)
                
                Text("You're successfully logged in")
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.secondaryText)
                
                Spacer()
                
                // Sign Out Button
                Button {
                    authViewModel.signOut()
                } label: {
                    Text("Sign Out")
                }
                .secondaryButtonStyle()
                .padding(.horizontal, AppSpacing.large)
                .padding(.bottom, AppSpacing.extraLarge)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
