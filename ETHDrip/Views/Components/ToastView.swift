//
//  ToastView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

enum ToastType {
    case success
    case error
    case warning
    case info
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .success: return AppColors.success
        case .error: return AppColors.error
        case .warning: return AppColors.warning
        case .info: return AppColors.info
        }
    }
}

struct ToastView: View {
    let message: String
    let type: ToastType
    
    var body: some View {
        HStack(spacing: AppSpacing.small) {
            Image(systemName: type.icon)
                .foregroundColor(type.color)
            
            Text(message)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(AppSpacing.medium)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.medium)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal, AppSpacing.large)
    }
}

// MARK: - Toast Modifier
struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let type: ToastType
    let duration: TimeInterval
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            if isPresented {
                VStack {
                    ToastView(message: message, type: type)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation {
                                    isPresented = false
                                }
                            }
                        }
                    
                    Spacer()
                }
                .padding(.top, AppSpacing.medium)
                .zIndex(999)
            }
        }
        .animation(.spring(), value: isPresented)
    }
}

extension View {
    func toast(
        isPresented: Binding<Bool>,
        message: String,
        type: ToastType = .info,
        duration: TimeInterval = 3.0
    ) -> some View {
        modifier(ToastModifier(
            isPresented: isPresented,
            message: message,
            type: type,
            duration: duration
        ))
    }
}

#Preview {
    VStack {
        Text("Content")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColors.background)
    .overlay(
        VStack {
            ToastView(message: "Operation successful!", type: .success)
            Spacer()
        }
        .padding(.top, 50)
    )
}

