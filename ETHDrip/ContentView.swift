//
//  ContentView.swift
//  ETHDrip
//
//  Created by Saksham Tyagi on 30/09/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        MainTabView()
            .environmentObject(authViewModel)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
