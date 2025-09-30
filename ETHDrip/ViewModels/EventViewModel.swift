//
//  EventViewModel.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import Foundation

@MainActor
class EventViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var events: [Event] = []
    @Published var featuredEvents: [Event] = []
    @Published var upcomingEvents: [Event] = []
    @Published var ongoingEvents: [Event] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Initialization
    init() {
        loadEvents()
    }
    
    // MARK: - Methods
    func loadEvents() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            // TODO: Replace with actual contract/API call
            self.events = self.getMockEvents()
            self.categorizeEvents()
            self.isLoading = false
        }
    }
    
    func refreshEvents() async {
        isLoading = true
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // TODO: Replace with actual contract/API call
        events = getMockEvents()
        categorizeEvents()
        isLoading = false
    }
    
    private func categorizeEvents() {
        featuredEvents = events.filter { $0.isOngoing || $0.isUpcoming }
            .sorted { $0.startDate < $1.startDate }
            .prefix(3)
            .map { $0 }
        
        upcomingEvents = events.filter { $0.isUpcoming }
            .sorted { $0.startDate < $1.startDate }
        
        ongoingEvents = events.filter { $0.isOngoing }
            .sorted { $0.startDate < $1.startDate }
    }
    
    func getEvent(by id: String) -> Event? {
        events.first { $0.id == id }
    }
    
    // MARK: - Mock Data
    private func getMockEvents() -> [Event] {
        let calendar = Calendar.current
        let now = Date()
        
        return [
            Event(
                id: "1",
                name: "ETHGlobal San Francisco",
                description: "The largest Ethereum hackathon in the Bay Area. Join developers from around the world to build the future of Web3.",
                location: "San Francisco, CA",
                startDate: calendar.date(byAdding: .day, value: -1, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 2, to: now)!,
                imageURL: "event1",
                organizerAddress: "0x1234567890123456789012345678901234567890",
                totalBooths: 24,
                totalNotifications: 156,
                isActive: true
            ),
            Event(
                id: "2",
                name: "ETHDenver 2025",
                description: "The world's largest Web3 #BUIDLathon & conference. Experience the future of blockchain technology.",
                location: "Denver, CO",
                startDate: calendar.date(byAdding: .day, value: 15, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 18, to: now)!,
                imageURL: "event2",
                organizerAddress: "0x2345678901234567890123456789012345678901",
                totalBooths: 48,
                totalNotifications: 0,
                isActive: true
            ),
            Event(
                id: "3",
                name: "ETHOnline Hackathon",
                description: "A virtual hackathon bringing together the global Ethereum community. Build from anywhere!",
                location: "Virtual",
                startDate: calendar.date(byAdding: .day, value: 5, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 8, to: now)!,
                imageURL: "event3",
                organizerAddress: "0x3456789012345678901234567890123456789012",
                totalBooths: 18,
                totalNotifications: 0,
                isActive: true
            ),
            Event(
                id: "4",
                name: "ETHIndia Bangalore",
                description: "India's premier Ethereum hackathon. Connect with the vibrant Indian Web3 ecosystem.",
                location: "Bangalore, India",
                startDate: calendar.date(byAdding: .day, value: 30, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 33, to: now)!,
                imageURL: "event4",
                organizerAddress: "0x4567890123456789012345678901234567890123",
                totalBooths: 32,
                totalNotifications: 0,
                isActive: true
            ),
            Event(
                id: "5",
                name: "ETHParis 2025",
                description: "The French capital's biggest Ethereum event. Discover the European Web3 scene.",
                location: "Paris, France",
                startDate: calendar.date(byAdding: .day, value: -10, to: now)!,
                endDate: calendar.date(byAdding: .day, value: -7, to: now)!,
                imageURL: "event5",
                organizerAddress: "0x5678901234567890123456789012345678901234",
                totalBooths: 28,
                totalNotifications: 245,
                isActive: false
            )
        ]
    }
}
