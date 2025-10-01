//
//  CreateNotificationView.swift
//  ETHDrip
//
//  Created on 09/30/2025
//

import SwiftUI
import PhotosUI

struct CreateNotificationView: View {
    let boothId: String
    let boothName: String
    let eventId: String
    
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var isSubmitting = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false
    
    var isFormValid: Bool {
        !title.isEmpty && !description.isEmpty && description.count >= 10
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        // Header
                        headerSection
                        
                        // Form Fields
                        formSection
                        
                        // Image Picker
                        imageSection
                        
                        // Guidelines
                        guidelinesSection
                        
                        // Submit Button
                        submitButton
                    }
                    .padding(AppSpacing.large)
                }
            }
            .navigationTitle("Post Notification")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Success!", isPresented: $showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your swag notification has been posted successfully!")
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            HStack(spacing: AppSpacing.small) {
                Image(systemName: "building.2.fill")
                    .foregroundColor(AppColors.primaryPurple)
                Text(boothName)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
            }
            
            Text("Let attendees know about available swag at this booth")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
        }
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            // Title
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text("Title")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                TextField("e.g., Free T-shirts available!", text: $title)
                    .textFieldStyle(CustomTextFieldStyle())
                    .autocapitalization(.sentences)
            }
            
            // Description
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                HStack {
                    Text("Description")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Text("\(description.count) / 500")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.tertiaryText)
                }
                
                TextEditor(text: $description)
                    .frame(height: 120)
                    .padding(AppSpacing.small)
                    .background(AppColors.cardBackground)
                    .cornerRadius(AppCornerRadius.small)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.small)
                            .stroke(AppColors.tertiaryText.opacity(0.2), lineWidth: 1)
                    )
                    .onChange(of: description) { newValue in
                        if newValue.count > 500 {
                            description = String(newValue.prefix(500))
                        }
                    }
                
                if !description.isEmpty && description.count < 10 {
                    Text("Please provide at least 10 characters")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.warning)
                }
            }
        }
    }
    
    // MARK: - Image Section
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Image (Optional)")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            if let imageData = selectedImageData,
               let uiImage = UIImage(data: imageData) {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(AppCornerRadius.medium)
                    
                    Button {
                        selectedImage = nil
                        selectedImageData = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.6)))
                    }
                    .padding(AppSpacing.small)
                }
            } else {
                PhotosPicker(selection: $selectedImage, matching: .images) {
                    HStack {
                        Image(systemName: "photo.badge.plus")
                        Text("Add Photo")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(AppColors.cardBackground)
                    .foregroundColor(AppColors.primaryPurple)
                    .cornerRadius(AppCornerRadius.medium)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .stroke(AppColors.primaryPurple.opacity(0.3), lineWidth: 1)
                    )
                }
                .onChange(of: selectedImage) { newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Guidelines Section
    private var guidelinesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(AppColors.info)
                Text("Posting Guidelines")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                GuidelineItem(text: "Only post about actual, available swag")
                GuidelineItem(text: "Be specific about what's being given away")
                GuidelineItem(text: "Include any requirements (e.g., \"Follow on Twitter\")")
                GuidelineItem(text: "False notifications may result in account restrictions")
            }
            .padding(AppSpacing.medium)
            .background(AppColors.info.opacity(0.1))
            .cornerRadius(AppCornerRadius.medium)
        }
    }
    
    // MARK: - Submit Button
    private var submitButton: some View {
        VStack(spacing: AppSpacing.small) {
            Button {
                submitNotification()
            } label: {
                if isSubmitting {
                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        Text("Posting...")
                    }
                } else {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("Post Notification")
                    }
                }
            }
            .primaryButtonStyle()
            .disabled(!isFormValid || isSubmitting)
            .opacity(isFormValid && !isSubmitting ? 1.0 : 0.6)
            
            if !isFormValid {
                Text("Please fill in all required fields")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.warning)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Submit Action
    private func submitNotification() {
        isSubmitting = true
        
        // TODO: Implement actual submission logic
        // 1. Upload image to IPFS if available
        // 2. Create metadata and upload to IPFS
        // 3. Call smart contract with metadata URI
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSubmitting = false
            
            // Simulate success
            let success = true
            
            if success {
                showSuccess = true
            } else {
                errorMessage = "Failed to post notification. Please try again."
                showError = true
            }
        }
    }
}

// MARK: - Guideline Item
struct GuidelineItem: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.caption)
                .foregroundColor(AppColors.success)
            Text(text)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.secondaryText)
        }
    }
}

// MARK: - Custom Text Field Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(AppSpacing.medium)
            .background(AppColors.cardBackground)
            .cornerRadius(AppCornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.small)
                    .stroke(AppColors.tertiaryText.opacity(0.2), lineWidth: 1)
            )
    }
}

#Preview {
    CreateNotificationView(
        boothId: "booth1",
        boothName: "Chainlink",
        eventId: "event1"
    )
}

