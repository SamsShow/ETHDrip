//
//  ETHDripApp.swift
//  ETHDrip
//
//  Created by Saksham Tyagi on 30/09/25.
//

import SwiftUI

@main
struct ETHDripApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch authViewModel.authState {
                case .authenticated:
                    ContentView()
                        .environmentObject(authViewModel)
                case .unauthenticated, .loading:
                    LoginView()
                        .environmentObject(authViewModel)
                }
            }
        }
    }
}
