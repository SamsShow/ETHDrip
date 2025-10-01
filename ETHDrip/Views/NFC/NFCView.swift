//
//  NFCView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

enum NFCState {
    case idle
    case scanning
    case success(String) // Tag UID
    case error(String)   // Error message
}

struct NFCView: View {
    @State private var nfcState: NFCState = .idle
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastType: ToastType = .info
    
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
                    
                    // NFC Icon with State
                    nfcIcon
                    
                    // State Message
                    stateMessage
                    
                    Spacer()
                    
                    // Action Button
                    actionButton
                    
                    // Instructions
                    instructionsSection
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("NFC Verification")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                }
            }
            .toast(
                isPresented: $showToast,
                message: toastMessage,
                type: toastType
            )
        }
    }
    
    // MARK: - NFC Icon
    @ViewBuilder
    private var nfcIcon: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [stateColor.opacity(0.2), stateColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 180, height: 180)
            
            Circle()
                .fill(
                    LinearGradient(
                        colors: [stateColor, stateColor.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 140, height: 140)
                .shadow(color: stateColor.opacity(0.3), radius: 20, x: 0, y: 10)
            
            if case .scanning = nfcState {
                // Animated scanning rings
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 140, height: 140)
                        .scaleEffect(scanningScale(for: index))
                        .opacity(scanningOpacity(for: index))
                }
            }
            
            Image(systemName: stateIcon)
                .font(.system(size: 60))
                .foregroundColor(.white)
        }
    }
    
    // MARK: - State Message
    private var stateMessage: some View {
        VStack(spacing: AppSpacing.small) {
            Text(stateTitle)
                .font(AppFonts.title)
                .foregroundColor(AppColors.primaryText)
            
            Text(stateDescription)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.extraLarge)
        }
    }
    
    // MARK: - Action Button
    @ViewBuilder
    private var actionButton: some View {
        switch nfcState {
        case .idle:
            Button {
                startScanning()
            } label: {
                HStack {
                    Image(systemName: "wave.3.right.circle.fill")
                    Text("Start Scanning")
                }
            }
            .primaryButtonStyle()
            .padding(.horizontal, AppSpacing.large)
            
        case .scanning:
            Button {
                cancelScanning()
            } label: {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                    Text("Cancel")
                }
            }
            .secondaryButtonStyle()
            .padding(.horizontal, AppSpacing.large)
            
        case .success:
            Button {
                resetScanning()
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Scan Another")
                }
            }
            .secondaryButtonStyle()
            .padding(.horizontal, AppSpacing.large)
            
        case .error:
            Button {
                resetScanning()
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
            }
            .primaryButtonStyle()
            .padding(.horizontal, AppSpacing.large)
        }
    }
    
    // MARK: - Instructions
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(AppColors.info)
                Text("How it works")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                InstructionItem(number: "1", text: "Tap 'Start Scanning'")
                InstructionItem(number: "2", text: "Hold your phone near the NFC wristband")
                InstructionItem(number: "3", text: "Wait for verification to complete")
                InstructionItem(number: "4", text: "Start posting swag notifications!")
            }
        }
        .padding(AppSpacing.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.medium)
        .padding(.horizontal, AppSpacing.large)
        .padding(.bottom, AppSpacing.extraLarge)
    }
    
    // MARK: - State Properties
    private var stateColor: Color {
        switch nfcState {
        case .idle: return AppColors.primaryPurple
        case .scanning: return .blue
        case .success: return .green
        case .error: return .red
        }
    }
    
    private var stateIcon: String {
        switch nfcState {
        case .idle: return "wave.3.right"
        case .scanning: return "wave.3.right"
        case .success: return "checkmark"
        case .error: return "xmark"
        }
    }
    
    private var stateTitle: String {
        switch nfcState {
        case .idle: return "Ready to Scan"
        case .scanning: return "Scanning..."
        case .success: return "Verified!"
        case .error: return "Scan Failed"
        }
    }
    
    private var stateDescription: String {
        switch nfcState {
        case .idle:
            return "Scan your event wristband to verify your attendance and start posting swag notifications"
        case .scanning:
            return "Hold your phone near the NFC wristband"
        case .success(let uid):
            return "Successfully verified! Tag UID: \(uid.prefix(12))..."
        case .error(let message):
            return message
        }
    }
    
    // MARK: - Actions
    private func startScanning() {
        withAnimation {
            nfcState = .scanning
        }
        
        // TODO: Implement actual NFC scanning with CoreNFC
        // Simulate scanning for now
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // Simulate success
            let mockUID = "04:A3:2F:B2:C1:D4:80"
            withAnimation {
                nfcState = .success(mockUID)
            }
            toastMessage = "NFC verification successful!"
            toastType = .success
            showToast = true
        }
    }
    
    private func cancelScanning() {
        withAnimation {
            nfcState = .idle
        }
    }
    
    private func resetScanning() {
        withAnimation {
            nfcState = .idle
        }
    }
    
    // MARK: - Animation Helpers
    @State private var animationAmount = 0.0
    
    private func scanningScale(for index: Int) -> CGFloat {
        let delay = Double(index) * 0.3
        return 1.0 + (animationAmount - delay).truncatingRemainder(dividingBy: 1.0)
    }
    
    private func scanningOpacity(for index: Int) -> Double {
        let delay = Double(index) * 0.3
        let progress = (animationAmount - delay).truncatingRemainder(dividingBy: 1.0)
        return 1.0 - progress
    }
}

// MARK: - Instruction Item
struct InstructionItem: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(spacing: AppSpacing.small) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryPurple.opacity(0.2))
                    .frame(width: 24, height: 24)
                
                Text(number)
                    .font(AppFonts.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primaryPurple)
            }
            
            Text(text)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
        }
    }
}

#Preview {
    NFCView()
}
