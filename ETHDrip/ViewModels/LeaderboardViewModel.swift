//
//  LeaderboardViewModel.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import Foundation

@MainActor
class LeaderboardViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var leaderboard: [LeaderboardEntry] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var selectedFilter: LeaderboardFilter = .global
    @Published var selectedEventId: String?
    
    // MARK: - Computed Properties
    var topThree: [LeaderboardEntry] {
        Array(leaderboard.prefix(3))
    }
    
    var remaining: [LeaderboardEntry] {
        Array(leaderboard.dropFirst(3))
    }
    
    // MARK: - Initialization
    init() {
        loadLeaderboard()
    }
    
    // MARK: - Methods
    func loadLeaderboard(eventId: String? = nil) {
        isLoading = true
        selectedEventId = eventId
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            // TODO: Replace with actual contract call
            // Example: contractService.getLeaderboard(eventId: eventId)
            self.leaderboard = self.getMockLeaderboard(eventId: eventId)
            self.isLoading = false
        }
    }
    
    func refreshLeaderboard() async {
        isLoading = true
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // TODO: Replace with actual contract/API call
        leaderboard = getMockLeaderboard(eventId: selectedEventId)
        isLoading = false
    }
    
    func filterChanged(_ filter: LeaderboardFilter) {
        selectedFilter = filter
        
        switch filter {
        case .global:
            loadLeaderboard()
        case .event:
            // Load event-specific leaderboard
            if let eventId = selectedEventId {
                loadLeaderboard(eventId: eventId)
            }
        }
    }
    
    // MARK: - Mock Data
    private func getMockLeaderboard(eventId: String? = nil) -> [LeaderboardEntry] {
        // Generate mock leaderboard data
        let mockUsers = [
            ("Alice.eth", "0x1234567890123456789012345678901234567890", 156, 892),
            ("Bob.eth", "0x2345678901234567890123456789012345678901", 142, 756),
            ("Charlie.eth", "0x3456789012345678901234567890123456789012", 128, 698),
            ("Diana.eth", "0x4567890123456789012345678901234567890123", 98, 512),
            ("Evan.eth", "0x5678901234567890123456789012345678901234", 87, 445),
            ("Fiona.eth", "0x6789012345678901234567890123456789012345", 76, 398),
            ("George.eth", "0x7890123456789012345678901234567890123456", 65, 342),
            ("Hannah.eth", "0x8901234567890123456789012345678901234567", 54, 289),
            ("Ian.eth", "0x9012345678901234567890123456789012345678", 43, 234),
            ("Julia.eth", "0x0123456789012345678901234567890123456789", 38, 198),
            ("Kevin.eth", "0x1234567890123456789012345678901234567891", 32, 176),
            ("Luna.eth", "0x2345678901234567890123456789012345678902", 28, 154),
            ("Mike.eth", "0x3456789012345678901234567890123456789013", 24, 132),
            ("Nina.eth", "0x4567890123456789012345678901234567890124", 20, 110),
            ("Oscar.eth", "0x5678901234567890123456789012345678901235", 16, 88)
        ]
        
        return mockUsers.enumerated().map { index, user in
            LeaderboardEntry(
                id: user.1,
                address: user.1,
                displayName: user.0,
                notificationCount: eventId != nil ? user.2 / 2 : user.2, // Half for event-specific
                upvotes: eventId != nil ? user.3 / 2 : user.3,
                rank: index + 1
            )
        }
    }
}

// MARK: - Leaderboard Filter
enum LeaderboardFilter: String, CaseIterable {
    case global = "Global"
    case event = "This Event"
}
