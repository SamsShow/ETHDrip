//
//  TransactionStatusView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI

enum TransactionStatus {
    case idle
    case signing
    case pending(txHash: String)
    case confirmed(txHash: String)
    case failed(error: String)
}

struct TransactionStatusView: View {
    let status: TransactionStatus
    let onDismiss: () -> Void
    let onViewTransaction: ((String) -> Void)?
    
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            // Icon
            statusIcon
            
            // Title & Message
            VStack(spacing: AppSpacing.small) {
                Text(statusTitle)
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Text(statusMessage)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.large)
            }
            
            // Progress indicator for pending
            if case .signing = status {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primaryPurple))
                    .scaleEffect(1.5)
            }
            
            if case .pending = status {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primaryPurple))
                    .scaleEffect(1.5)
            }
            
            // Action buttons
            actionButtons
        }
        .padding(AppSpacing.extraLarge)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.large)
        .shadow(color: Color.black.opacity(0.2), radius: 20)
        .padding(AppSpacing.large)
    }
    
    // MARK: - Status Icon
    @ViewBuilder
    private var statusIcon: some View {
        ZStack {
            Circle()
                .fill(statusColor.opacity(0.2))
                .frame(width: 100, height: 100)
            
            Image(systemName: statusIconName)
                .font(.system(size: 50))
                .foregroundColor(statusColor)
        }
    }
    
    // MARK: - Action Buttons
    @ViewBuilder
    private var actionButtons: some View {
        VStack(spacing: AppSpacing.small) {
            switch status {
            case .confirmed(let txHash):
                if let onViewTransaction = onViewTransaction {
                    Button {
                        onViewTransaction(txHash)
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.right.square")
                            Text("View on Explorer")
                        }
                    }
                    .secondaryButtonStyle()
                }
                
                Button {
                    onDismiss()
                } label: {
                    Text("Done")
                }
                .primaryButtonStyle()
                
            case .failed:
                Button {
                    onDismiss()
                } label: {
                    Text("Close")
                }
                .primaryButtonStyle()
                
            default:
                EmptyView()
            }
        }
    }
    
    // MARK: - Status Properties
    private var statusColor: Color {
        switch status {
        case .idle: return AppColors.primaryPurple
        case .signing: return .blue
        case .pending: return .orange
        case .confirmed: return .green
        case .failed: return .red
        }
    }
    
    private var statusIconName: String {
        switch status {
        case .idle: return "clock"
        case .signing: return "signature"
        case .pending: return "clock.arrow.circlepath"
        case .confirmed: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        }
    }
    
    private var statusTitle: String {
        switch status {
        case .idle: return "Ready"
        case .signing: return "Sign Transaction"
        case .pending: return "Processing..."
        case .confirmed: return "Success!"
        case .failed: return "Transaction Failed"
        }
    }
    
    private var statusMessage: String {
        switch status {
        case .idle:
            return "Ready to submit transaction"
        case .signing:
            return "Please sign the transaction in your wallet"
        case .pending(let txHash):
            return "Your transaction is being processed\n\(txHash.prefix(10))..."
        case .confirmed:
            return "Your transaction has been confirmed on the blockchain"
        case .failed(let error):
            return error
        }
    }
}

// MARK: - Transaction Status Modifier
struct TransactionStatusModifier: ViewModifier {
    @Binding var status: TransactionStatus?
    let onViewTransaction: ((String) -> Void)?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let status = status {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        // Prevent dismissal during signing/pending
                        if case .confirmed = status {
                            self.status = nil
                        } else if case .failed = status {
                            self.status = nil
                        }
                    }
                
                TransactionStatusView(
                    status: status,
                    onDismiss: {
                        self.status = nil
                    },
                    onViewTransaction: onViewTransaction
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

extension View {
    func transactionStatus(
        _ status: Binding<TransactionStatus?>,
        onViewTransaction: ((String) -> Void)? = nil
    ) -> some View {
        modifier(TransactionStatusModifier(
            status: status,
            onViewTransaction: onViewTransaction
        ))
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Transaction Status Examples")
            .font(AppFonts.title)
        
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColors.background)
    .overlay(
        TransactionStatusView(
            status: .confirmed(txHash: "0x1234567890abcdef"),
            onDismiss: {},
            onViewTransaction: { _ in }
        )
    )
}

