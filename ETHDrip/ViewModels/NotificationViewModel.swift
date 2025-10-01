//
//  NotificationViewModel.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import Foundation
import Combine

@MainActor
class NotificationViewModel: ObservableObject {
    @Published var notifications: [SwagNotification] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    // Load notifications for a specific booth or event
    func loadNotifications(for id: String) async {
        isLoading = true
        error = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock data
        notifications = [
            SwagNotification(
                id: "notif1",
                eventId: "event1",
                boothId: id,
                boothName: "Chainlink",
                notifierAddress: "0x1234567890abcdef",
                notifierName: "Alice",
                title: "Free T-shirts Available!",
                description: "Exclusive Chainlink t-shirts are now available at our booth. Come grab yours before they run out! Limited to one per person.",
                metadataURI: "ipfs://QmExample1",
                timestamp: Date().addingTimeInterval(-300),
                upvotes: 42,
                imageURL: nil
            ),
            SwagNotification(
                id: "notif2",
                eventId: "event1",
                boothId: id,
                boothName: "Chainlink",
                notifierAddress: "0xabcdef1234567890",
                notifierName: "Bob",
                title: "Sticker Pack Giveaway",
                description: "New batch of holographic stickers just arrived! Follow us on Twitter to claim your pack.",
                metadataURI: "ipfs://QmExample2",
                timestamp: Date().addingTimeInterval(-1800),
                upvotes: 28,
                imageURL: nil
            ),
            SwagNotification(
                id: "notif3",
                eventId: "event1",
                boothId: id,
                boothName: "Chainlink",
                notifierAddress: "0x9876543210fedcba",
                notifierName: nil,
                title: "Water Bottles Available",
                description: "Stay hydrated! Branded water bottles available now at the booth. No requirements, just come by!",
                metadataURI: "ipfs://QmExample3",
                timestamp: Date().addingTimeInterval(-3600),
                upvotes: 65,
                imageURL: nil
            )
        ]
        
        isLoading = false
    }
    
    // Create a new notification
    func createNotification(
        eventId: String,
        boothId: String,
        boothName: String,
        title: String,
        description: String,
        imageData: Data?
    ) async throws {
        // TODO: Implement actual creation logic
        // 1. Upload image to IPFS if provided
        // 2. Create metadata JSON
        // 3. Upload metadata to IPFS
        // 4. Call smart contract with metadata URI
        
        isLoading = true
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        isLoading = false
    }
}

