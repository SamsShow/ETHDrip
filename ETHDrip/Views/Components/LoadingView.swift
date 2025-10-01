//
//  LoadingView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct LoadingView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primaryPurple))
            
            Text(message)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

#Preview {
    LoadingView(message: "Loading events...")
}

