//
//  NetworkStatusBanner.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected = true
    @Published var connectionType: NWInterface.InterfaceType?
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.connectionType = path.availableInterfaces.first?.type
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}

struct NetworkStatusBanner: View {
    @ObservedObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        Group {
            if !networkMonitor.isConnected {
                HStack(spacing: AppSpacing.small) {
                    Image(systemName: "wifi.slash")
                        .font(.callout)
                    
                    Text("No Internet Connection")
                        .font(AppFonts.callout)
                    
                    Spacer()
                    
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.callout)
                }
                .foregroundColor(.white)
                .padding(AppSpacing.small)
                .background(AppColors.error)
                .transition(.move(edge: .top))
            }
        }
        .animation(.easeInOut, value: networkMonitor.isConnected)
    }
}

// MARK: - Network Status Modifier
struct NetworkStatusModifier: ViewModifier {
    @StateObject private var networkMonitor = NetworkMonitor()
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            NetworkStatusBanner(networkMonitor: networkMonitor)
            content
        }
        .environmentObject(networkMonitor)
    }
}

extension View {
    func networkStatus() -> some View {
        modifier(NetworkStatusModifier())
    }
}

#Preview {
    VStack {
        Text("App Content")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .networkStatus()
}

