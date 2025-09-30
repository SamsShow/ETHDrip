//
//  LeaderboardCard.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

// MARK: - Podium Card (Top 3)
struct PodiumCard: View {
    let entry: LeaderboardEntry
    let rank: Int
    
    private var podiumHeight: CGFloat {
        switch rank {
        case 1: return 140
        case 2: return 120
        case 3: return 100
        default: return 100
        }
    }
    
    private var medalColor: Color {
        switch rank {
        case 1: return Color(red: 1.0, green: 0.84, blue: 0.0) // Gold
        case 2: return Color(red: 0.75, green: 0.75, blue: 0.75) // Silver
        case 3: return Color(red: 0.80, green: 0.50, blue: 0.20) // Bronze
        default: return .gray
        }
    }
    
    private var medalIcon: String {
        switch rank {
        case 1: return "crown.fill"
        case 2: return "medal.fill"
        case 3: return "medal.fill"
        default: return "star.fill"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Medal/Crown
            ZStack {
                Circle()
                    .fill(medalColor)
                    .frame(width: 50, height: 50)
                    .shadow(color: medalColor.opacity(0.5), radius: 10, x: 0, y: 5)
                
                Image(systemName: medalIcon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            .offset(y: 25)
            .zIndex(1)
            
            // Card
            VStack(spacing: AppSpacing.small) {
                Spacer()
                    .frame(height: 30)
                
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
                        .frame(width: 50, height: 50)
                    
                    Text(entry.displayName?.prefix(1).uppercased() ?? "?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Name
                Text(entry.displayName ?? "Unknown")
                    .font(rank == 1 ? AppFonts.headline : AppFonts.callout)
                    .fontWeight(rank == 1 ? .bold : .semibold)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                // Stats
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "bell.badge.fill")
                            .font(.caption2)
                        Text("\(entry.notificationCount)")
                            .font(AppFonts.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(AppColors.primaryPurple)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.caption2)
                        Text("\(entry.upvotes)")
                            .font(AppFonts.caption)
                    }
                    .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
            }
            .frame(height: podiumHeight)
            .frame(maxWidth: .infinity)
            .background(AppColors.cardBackground)
            .cornerRadius(AppCornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .stroke(
                        rank == 1 ? medalColor.opacity(0.3) : Color.clear,
                        lineWidth: 2
                    )
            )
        }
    }
}

// MARK: - Regular Leaderboard Row
struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            // Rank Badge
            ZStack {
                Circle()
                    .fill(rankColor.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Text("#\(entry.rank)")
                    .font(AppFonts.callout)
                    .fontWeight(.bold)
                    .foregroundColor(rankColor)
            }
            
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primaryPurple.opacity(0.6), AppColors.accentPurple.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 45, height: 45)
                
                Text(entry.displayName?.prefix(1).uppercased() ?? "?")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.displayName ?? "Unknown User")
                    .font(AppFonts.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                Text(entry.displayAddress)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.tertiaryText)
            }
            
            Spacer()
            
            // Stats
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "bell.badge.fill")
                        .font(.caption2)
                    Text("\(entry.notificationCount)")
                        .font(AppFonts.callout)
                        .fontWeight(.semibold)
                }
                .foregroundColor(AppColors.primaryPurple)
                
                HStack(spacing: 4) {
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.caption2)
                    Text("\(entry.upvotes)")
                        .font(AppFonts.caption)
                }
                .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(AppSpacing.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.medium)
    }
    
    private var rankColor: Color {
        if entry.rank <= 5 {
            return AppColors.primaryPurple
        } else if entry.rank <= 10 {
            return .blue
        } else {
            return AppColors.secondaryText
        }
    }
}

// MARK: - Empty State
struct LeaderboardEmptyState: View {
    var body: some View {
        VStack(spacing: AppSpacing.medium) {
            ZStack {
                Circle()
                    .fill(AppColors.secondaryBackground)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "trophy")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.tertiaryText)
            }
            
            Text("No Rankings Yet")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            Text("Be the first to post swag notifications\nand climb the leaderboard!")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, AppSpacing.extraLarge * 2)
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 12) {
            PodiumCard(entry: LeaderboardEntry(
                id: "2",
                address: "0x234",
                displayName: "Bob.eth",
                notificationCount: 142,
                upvotes: 756,
                rank: 2
            ), rank: 2)
            
            PodiumCard(entry: LeaderboardEntry(
                id: "1",
                address: "0x123",
                displayName: "Alice.eth",
                notificationCount: 156,
                upvotes: 892,
                rank: 1
            ), rank: 1)
            
            PodiumCard(entry: LeaderboardEntry(
                id: "3",
                address: "0x345",
                displayName: "Charlie.eth",
                notificationCount: 128,
                upvotes: 698,
                rank: 3
            ), rank: 3)
        }
        
        LeaderboardRow(entry: LeaderboardEntry(
            id: "4",
            address: "0x4567890123456789012345678901234567890123",
            displayName: "Diana.eth",
            notificationCount: 98,
            upvotes: 512,
            rank: 4
        ))
    }
    .padding()
    .background(AppColors.background)
}
