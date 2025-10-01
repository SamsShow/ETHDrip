//
//  BoothViewModel.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import Foundation
import Combine

@MainActor
class BoothViewModel: ObservableObject {
    @Published var booths: [Booth] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    // Mock data for development
    func loadBooths(for eventId: String) async {
        isLoading = true
        error = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock data
        booths = [
            Booth(
                id: "booth1",
                eventId: eventId,
                name: "Chainlink",
                description: "Get exclusive Chainlink swag and learn about decentralized oracles",
                sponsorAddress: "0x123",
                logoURL: nil,
                notificationCount: 12,
                isActive: true,
                location: "Booth #42",
                category: .sponsor
            ),
            Booth(
                id: "booth2",
                eventId: eventId,
                name: "Web3 Workshop",
                description: "Join our hands-on workshop and get a limited edition tote bag",
                sponsorAddress: "0x456",
                logoURL: nil,
                notificationCount: 8,
                isActive: true,
                location: "Room 101",
                category: .workshop
            ),
            Booth(
                id: "booth3",
                eventId: eventId,
                name: "Gaming Zone",
                description: "Play blockchain games and win exclusive NFT merchandise",
                sponsorAddress: "0x789",
                logoURL: nil,
                notificationCount: 15,
                isActive: true,
                location: "Area C",
                category: .gaming
            ),
            Booth(
                id: "booth4",
                eventId: eventId,
                name: "Food Court",
                description: "Free pizza and drinks for all attendees",
                sponsorAddress: "0xabc",
                logoURL: nil,
                notificationCount: 25,
                isActive: true,
                location: "Main Hall",
                category: .food
            ),
            Booth(
                id: "booth5",
                eventId: eventId,
                name: "Mentor Connect",
                description: "Get career advice and receive a mentor swag pack",
                sponsorAddress: "0xdef",
                logoURL: nil,
                notificationCount: 5,
                isActive: false,
                location: "Booth #15",
                category: .mentorship
            )
        ]
        
        isLoading = false
    }
}

