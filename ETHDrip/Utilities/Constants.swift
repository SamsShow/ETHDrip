//
//  Constants.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

// MARK: - Theme Colors
struct AppColors {
    // Primary Colors
    static let primaryPurple = Color(red: 0.75, green: 0.65, blue: 0.95) // Light purple
    static let primaryPurpleDark = Color(red: 0.65, green: 0.55, blue: 0.85)
    static let accentPurple = Color(red: 0.85, green: 0.75, blue: 1.0)
    
    // Background Colors
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let cardBackground = Color(.tertiarySystemBackground)
    
    // Text Colors
    static let primaryText = Color(.label)
    static let secondaryText = Color(.secondaryLabel)
    static let tertiaryText = Color(.tertiaryLabel)
    
    // Status Colors
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.orange
    static let info = Color.blue
}

// MARK: - Typography
struct AppFonts {
    static let largeTitle = Font.system(size: 34, weight: .bold)
    static let title = Font.system(size: 28, weight: .bold)
    static let title2 = Font.system(size: 22, weight: .semibold)
    static let title3 = Font.system(size: 20, weight: .semibold)
    static let headline = Font.system(size: 17, weight: .semibold)
    static let body = Font.system(size: 17, weight: .regular)
    static let callout = Font.system(size: 16, weight: .regular)
    static let subheadline = Font.system(size: 15, weight: .regular)
    static let footnote = Font.system(size: 13, weight: .regular)
    static let caption = Font.system(size: 12, weight: .regular)
}

// MARK: - Spacing
struct AppSpacing {
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let extraLarge: CGFloat = 32
}

// MARK: - Corner Radius
struct AppCornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 24
}

// MARK: - Animation
struct AppAnimation {
    static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let easeInOut = Animation.easeInOut(duration: 0.3)
}

// MARK: - API Keys (Move to environment variables in production)
struct APIKeys {
    static let pinataJWT = "" // Add your Pinata JWT
    static let walletConnectProjectID = "" // Add your WalletConnect Project ID
}

// MARK: - Network Configuration
enum NetworkEnvironment {
    case baseSepolia  // Testnet
    case baseMainnet  // Production
    
    var rpcURL: String {
        switch self {
        case .baseSepolia:
            return "https://sepolia.base.org"
        case .baseMainnet:
            return "https://mainnet.base.org"
        }
    }
    
    var chainId: Int {
        switch self {
        case .baseSepolia:
            return 84532
        case .baseMainnet:
            return 8453
        }
    }
    
    var explorerURL: String {
        switch self {
        case .baseSepolia:
            return "https://sepolia.basescan.org"
        case .baseMainnet:
            return "https://basescan.org"
        }
    }
}

// Current environment
let currentNetwork: NetworkEnvironment = .baseSepolia
