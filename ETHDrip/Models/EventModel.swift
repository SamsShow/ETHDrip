//
//  EventModel.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import Foundation

// MARK: - Event Model
struct Event: Identifiable, Codable {
    let id: String
    var name: String
    var description: String
    var location: String
    var startDate: Date
    var endDate: Date
    var imageURL: String?
    var organizerAddress: String
    var totalBooths: Int
    var totalNotifications: Int
    var isActive: Bool
    
    // Computed properties
    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
    
    var shortDateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
    
    var daysUntilStart: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: startDate).day ?? 0
    }
    
    var isUpcoming: Bool {
        startDate > Date()
    }
    
    var isOngoing: Bool {
        Date() >= startDate && Date() <= endDate
    }
    
    var hasEnded: Bool {
        endDate < Date()
    }
    
    var statusText: String {
        if isOngoing { return "Live Now" }
        if isUpcoming { return "Upcoming" }
        return "Ended"
    }
}

// MARK: - Booth Model
struct Booth: Identifiable, Codable {
    let id: String
    var eventId: String
    var name: String
    var description: String
    var sponsorAddress: String
    var logoURL: String?
    var notificationCount: Int
    var isActive: Bool
    var location: String?
    var category: BoothCategory
}

enum BoothCategory: String, Codable, CaseIterable {
    case sponsor = "Sponsor"
    case workshop = "Workshop"
    case mentorship = "Mentorship"
    case gaming = "Gaming"
    case food = "Food & Drinks"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .sponsor: return "star.fill"
        case .workshop: return "wrench.and.screwdriver.fill"
        case .mentorship: return "person.2.fill"
        case .gaming: return "gamecontroller.fill"
        case .food: return "fork.knife"
        case .other: return "tag.fill"
        }
    }
}

// MARK: - Notification Model
struct SwagNotification: Identifiable, Codable {
    let id: String
    var eventId: String
    var boothId: String
    var boothName: String
    var notifierAddress: String
    var notifierName: String?
    var title: String
    var description: String
    var metadataURI: String
    var timestamp: Date
    var upvotes: Int
    var imageURL: String?
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}

// MARK: - User Stats Model
struct UserStats: Codable {
    var totalNotifications: Int
    var totalUpvotes: Int
    var eventsAttended: Int
    var rank: Int?
    var isVerified: Bool
    
    init() {
        self.totalNotifications = 0
        self.totalUpvotes = 0
        self.eventsAttended = 0
        self.rank = nil
        self.isVerified = false
    }
}

// MARK: - Leaderboard Entry
struct LeaderboardEntry: Identifiable, Codable {
    let id: String
    var address: String
    var displayName: String?
    var notificationCount: Int
    var upvotes: Int
    var rank: Int
    
    var displayAddress: String {
        if let name = displayName, !name.isEmpty {
            return name
        }
        // Format address: 0x1234...5678
        guard address.count > 10 else { return address }
        return "\(address.prefix(6))...\(address.suffix(4))"
    }
}
