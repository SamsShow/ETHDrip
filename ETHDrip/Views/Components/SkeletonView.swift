//
//  SkeletonView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct SkeletonView: View {
    @State private var isAnimating = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: AppCornerRadius.small)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        AppColors.cardBackground,
                        AppColors.secondaryBackground,
                        AppColors.cardBackground
                    ]),
                    startPoint: isAnimating ? .leading : .trailing,
                    endPoint: isAnimating ? .trailing : .leading
                )
            )
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - Skeleton Event Card
struct SkeletonEventCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            // Image placeholder
            SkeletonView()
                .frame(height: 120)
            
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                // Title
                SkeletonView()
                    .frame(height: 20)
                    .frame(width: 200)
                
                // Location
                SkeletonView()
                    .frame(height: 14)
                    .frame(width: 150)
                
                // Date
                SkeletonView()
                    .frame(height: 14)
                    .frame(width: 180)
                
                HStack {
                    SkeletonView()
                        .frame(width: 60, height: 14)
                    
                    Spacer()
                    
                    SkeletonView()
                        .frame(width: 80, height: 14)
                }
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.large)
    }
}

// MARK: - Skeleton Booth Card
struct SkeletonBoothCard: View {
    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            // Logo
            SkeletonView()
                .frame(width: 60, height: 60)
                .cornerRadius(AppCornerRadius.small)
            
            VStack(alignment: .leading, spacing: 8) {
                SkeletonView()
                    .frame(height: 18)
                    .frame(width: 180)
                
                SkeletonView()
                    .frame(height: 14)
                    .frame(width: 120)
                
                SkeletonView()
                    .frame(height: 12)
                    .frame(width: 100)
            }
            
            Spacer()
        }
        .padding(AppSpacing.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.medium)
    }
}

// MARK: - Skeleton Notification Card
struct SkeletonNotificationCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    SkeletonView()
                        .frame(height: 18)
                        .frame(width: 200)
                    
                    SkeletonView()
                        .frame(height: 12)
                        .frame(width: 100)
                }
                
                Spacer()
                
                SkeletonView()
                    .frame(width: 60, height: 12)
            }
            
            SkeletonView()
                .frame(height: 16)
            
            SkeletonView()
                .frame(height: 16)
                .frame(width: 250)
            
            HStack {
                SkeletonView()
                    .frame(width: 100, height: 12)
                
                Spacer()
                
                SkeletonView()
                    .frame(width: 50, height: 12)
            }
        }
        .padding(AppSpacing.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.medium)
    }
}

// MARK: - Skeleton List
struct SkeletonListView<Content: View>: View {
    let count: Int
    let content: () -> Content
    
    var body: some View {
        LazyVStack(spacing: AppSpacing.medium) {
            ForEach(0..<count, id: \.self) { _ in
                content()
            }
        }
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        
        VStack(spacing: AppSpacing.large) {
            Text("Skeleton Loading States")
                .font(AppFonts.title2)
            
            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    SkeletonEventCard()
                    SkeletonBoothCard()
                    SkeletonNotificationCard()
                }
                .padding()
            }
        }
    }
}

