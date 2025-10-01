//
//  HelpView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

struct HelpView: View {
    @State private var expandedSection: HelpSection? = nil
    
    enum HelpSection: String, CaseIterable {
        case gettingStarted = "Getting Started"
        case nfc = "NFC Verification"
        case notifications = "Notifications"
        case marketplace = "Marketplace"
        case wallet = "Wallet & Web3"
        case troubleshooting = "Troubleshooting"
        
        var icon: String {
            switch self {
            case .gettingStarted: return "play.circle.fill"
            case .nfc: return "wave.3.right.circle.fill"
            case .notifications: return "bell.badge.fill"
            case .marketplace: return "cart.fill"
            case .wallet: return "wallet.pass.fill"
            case .troubleshooting: return "wrench.and.screwdriver.fill"
            }
        }
        
        var questions: [HelpQuestion] {
            switch self {
            case .gettingStarted:
                return [
                    HelpQuestion(
                        question: "What is ETHDrip?",
                        answer: "ETHDrip is a decentralized platform for discovering and sharing real-time swag availability at ETH hackathons. It helps attendees find exclusive merchandise from sponsor booths."
                    ),
                    HelpQuestion(
                        question: "How do I get started?",
                        answer: "1. Create an account or sign in\n2. Connect your Web3 wallet\n3. Find an event and verify with NFC\n4. Start posting and discovering swag notifications!"
                    ),
                    HelpQuestion(
                        question: "Do I need a crypto wallet?",
                        answer: "Yes, you'll need a Web3 wallet like MetaMask, Rainbow, or Coinbase Wallet to post notifications and interact with the platform."
                    )
                ]
            case .nfc:
                return [
                    HelpQuestion(
                        question: "What is NFC verification?",
                        answer: "NFC verification confirms your physical attendance at an event by scanning your event wristband with your phone's NFC reader."
                    ),
                    HelpQuestion(
                        question: "My phone doesn't support NFC. What can I do?",
                        answer: "NFC is required for posting notifications. Make sure you have an iPhone 7 or newer with NFC capability enabled in settings."
                    ),
                    HelpQuestion(
                        question: "How do I scan my wristband?",
                        answer: "1. Go to the Scan tab\n2. Tap 'Start Scanning'\n3. Hold the top of your phone near the NFC wristband\n4. Wait for verification to complete"
                    )
                ]
            case .notifications:
                return [
                    HelpQuestion(
                        question: "How do I post a swag notification?",
                        answer: "1. Verify your attendance with NFC\n2. Navigate to a booth\n3. Tap 'Post Swag Notification'\n4. Fill in the details and submit"
                    ),
                    HelpQuestion(
                        question: "What makes a good notification?",
                        answer: "• Be specific about what's available\n• Mention any requirements\n• Add a photo if possible\n• Be honest - false notifications may result in restrictions"
                    ),
                    HelpQuestion(
                        question: "Can I delete my notifications?",
                        answer: "Notifications are stored on the blockchain and cannot be deleted, but you can update or clarify them by posting a new notification."
                    )
                ]
            case .marketplace:
                return [
                    HelpQuestion(
                        question: "What is the marketplace? (Coming Soon)",
                        answer: "The marketplace will allow you to trade swag items with other attendees in a peer-to-peer fashion, secured by smart contracts."
                    )
                ]
            case .wallet:
                return [
                    HelpQuestion(
                        question: "How do I connect my wallet?",
                        answer: "1. Go to Profile tab\n2. Tap 'Connect Wallet'\n3. Select your wallet app\n4. Approve the connection in your wallet"
                    ),
                    HelpQuestion(
                        question: "Which wallets are supported?",
                        answer: "We support all WalletConnect v2 compatible wallets including MetaMask, Rainbow, Coinbase Wallet, and more."
                    ),
                    HelpQuestion(
                        question: "What network should I use?",
                        answer: "For testing, use Base Sepolia testnet. For production, use Base Mainnet. You can switch networks in Settings."
                    )
                ]
            case .troubleshooting:
                return [
                    HelpQuestion(
                        question: "The app is not loading events",
                        answer: "• Check your internet connection\n• Try pulling down to refresh\n• Make sure you're connected to the correct network\n• Try restarting the app"
                    ),
                    HelpQuestion(
                        question: "NFC scanning isn't working",
                        answer: "• Make sure NFC is enabled on your phone\n• Remove any phone case that might interfere\n• Hold the phone steady near the wristband\n• Try scanning from different angles"
                    ),
                    HelpQuestion(
                        question: "Transaction failed",
                        answer: "• Check that you have enough ETH for gas fees\n• Make sure you're on the correct network\n• Try increasing gas limits in your wallet\n• Contact support if the issue persists"
                    )
                ]
            }
        }
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    // Header
                    headerSection
                    
                    // Help Sections
                    ForEach(HelpSection.allCases, id: \.self) { section in
                        HelpSectionView(
                            section: section,
                            isExpanded: expandedSection == section
                        ) {
                            withAnimation {
                                expandedSection = expandedSection == section ? nil : section
                            }
                        }
                    }
                    
                    // Contact Support
                    contactSection
                }
                .padding(AppSpacing.large)
            }
        }
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: AppSpacing.small) {
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(AppColors.primaryPurple)
            
            Text("How can we help?")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            Text("Find answers to common questions")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.large)
    }
    
    // MARK: - Contact Section
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Still need help?")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: AppSpacing.small) {
                ContactCard(
                    icon: "envelope.fill",
                    title: "Email Support",
                    subtitle: "support@ethdrip.xyz",
                    color: AppColors.primaryPurple
                )
                
                ContactCard(
                    icon: "message.fill",
                    title: "Discord Community",
                    subtitle: "Join our community",
                    color: Color.blue
                )
                
                ContactCard(
                    icon: "book.fill",
                    title: "Documentation",
                    subtitle: "Read the full docs",
                    color: Color.orange
                )
            }
        }
        .padding(.top, AppSpacing.large)
    }
}

// MARK: - Help Section View
struct HelpSectionView: View {
    let section: HelpView.HelpSection
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Section Header
            Button(action: onTap) {
                HStack {
                    Image(systemName: section.icon)
                        .font(.title3)
                        .foregroundColor(AppColors.primaryPurple)
                        .frame(width: 30)
                    
                    Text(section.rawValue)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(AppColors.tertiaryText)
                }
                .padding(AppSpacing.medium)
                .background(AppColors.cardBackground)
            }
            
            // Questions
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(Array(section.questions.enumerated()), id: \.offset) { index, question in
                        if index > 0 {
                            Divider()
                                .padding(.leading, 50)
                        }
                        HelpQuestionView(question: question)
                    }
                }
                .background(AppColors.cardBackground)
            }
        }
        .cornerRadius(AppCornerRadius.medium)
    }
}

// MARK: - Help Question View
struct HelpQuestionView: View {
    let question: HelpQuestion
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(question.question)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "minus.circle.fill" : "plus.circle.fill")
                        .foregroundColor(AppColors.primaryPurple)
                }
                .padding(AppSpacing.medium)
            }
            
            if isExpanded {
                Text(question.answer)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.secondaryText)
                    .padding(AppSpacing.medium)
                    .padding(.top, 0)
                    .background(AppColors.secondaryBackground.opacity(0.5))
            }
        }
    }
}

// MARK: - Help Question Model
struct HelpQuestion {
    let question: String
    let answer: String
}

// MARK: - Contact Card
struct ContactCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        Button {
            // Handle contact action
        } label: {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(subtitle)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(AppColors.tertiaryText)
            }
            .padding(AppSpacing.medium)
            .background(AppColors.cardBackground)
            .cornerRadius(AppCornerRadius.medium)
        }
    }
}

#Preview {
    NavigationView {
        HelpView()
    }
}

