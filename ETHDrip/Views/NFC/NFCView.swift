//
//  NFCView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct NFCView: View {
    @State private var isScanning = false
    
    var body: some View {
        NavigationView {
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
                
                VStack(spacing: AppSpacing.extraLarge) {
                    Spacer()
                    
                    // NFC Icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [AppColors.primaryPurple.opacity(0.2), AppColors.accentPurple.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 180, height: 180)
                        
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [AppColors.primaryPurple, AppColors.accentPurple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 140, height: 140)
                            .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        Image(systemName: "wave.3.right")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: AppSpacing.small) {
                        Text("NFC Verification")
                            .font(AppFonts.title)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Scan your event wristband to verify your attendance and start posting swag notifications")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AppSpacing.extraLarge)
                    }
                    
                    Spacer()
                    
                    // Scan Button
                    Button {
                        isScanning = true
                        // TODO: Implement NFC scanning
                    } label: {
                        HStack {
                            Image(systemName: "wave.3.right.circle.fill")
                            Text("Start Scanning")
                        }
                    }
                    .primaryButtonStyle()
                    .padding(.horizontal, AppSpacing.large)
                    .padding(.bottom, AppSpacing.extraLarge)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("NFC Scan")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
}

#Preview {
    NFCView()
}
