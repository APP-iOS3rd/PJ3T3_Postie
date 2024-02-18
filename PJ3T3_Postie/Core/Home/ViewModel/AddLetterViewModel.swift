//
//  AddLetterViewModel.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/17.
//

import Foundation
import UIKit

class AddLetterViewModel: ObservableObject {
    @Published var sender: String = ""
    @Published var receiver: String = ""
    @Published var date: Date = .now
    @Published var text: String = ""
    @Published var summary: String = ""
    @Published var images: [UIImage] = []
    @Published var selectedIndex: Int = 0
    @Published var showingUIImagePicker = false
    @Published var showingLetterImageFullScreenView: Bool = false
    @Published var showingTextRecognizerErrorAlert: Bool = false
    @Published var showingSummaryTextField: Bool = false
    @Published var showingSummaryAlert: Bool = false
    @Published var showingNotEnoughInfoAlert: Bool = false
    @Published var showingUploadErrorAlert: Bool = false
    @Published var shouldDismiss: Bool = false

    private(set) var imagePickerSourceType: UIImagePickerController.SourceType = .camera
    var isReceived: Bool
    var isNotEnoughInfo: Bool {
        (isReceived && (sender.isEmpty || text.isEmpty))
            || (!isReceived && (receiver.isEmpty || text.isEmpty))
    }

    init(isReceived: Bool) {
        self.isReceived = isReceived
    }

    private func dismissView() {
        shouldDismiss = true
    }

    func removeImage(at index: Int) {
        images.remove(at: index)
    }

    func showUIImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePickerSourceType = sourceType
        showingUIImagePicker = true 
    }
    
    func showNotEnoughInfoAlert() {
        showingNotEnoughInfoAlert = true
    }

    func showLetterImageFullScreenView(index: Int) {
        selectedIndex = index
        showingLetterImageFullScreenView = true
    }

    func showSummaryTextField() {
        showingSummaryTextField = true
    }

    func showSummaryAlert() {
        showingSummaryAlert = true
    }

    func showUploadErrorAlert() {
        showingUploadErrorAlert = true
    }

    func uploadLetter() async {
        if isNotEnoughInfo {
            await MainActor.run {
                showNotEnoughInfoAlert()
            }
        } else {
            do {
                let docId = UUID().uuidString

                let (newImageFullPaths, newImageUrls) = try await uploadImages(docId: docId)
                try await addLetter(docId: docId, newImageUrls: newImageUrls, newImageFullPaths: newImageFullPaths, isReceived: isReceived)

                await MainActor.run {
                    dismissView()
                }
            } catch {
                await MainActor.run {
                    showUploadErrorAlert()
                }
            }
        }
    }

    func uploadImages(docId: String) async throws -> ([String], [String]) {
        var newImageFullPaths = [String]()
        var newImageUrls = [String]()

        // 이미지 추가
        for image in images {
            let fullPath = try await StorageManager.shared.uploadUIImage(image: image, docId: docId)
            let url = try await StorageManager.shared.requestImageURL(fullPath: fullPath)
            newImageFullPaths.append(fullPath)
            newImageUrls.append(url)
        }

        return (newImageFullPaths, newImageUrls)
    }

    func addLetter(docId: String, newImageUrls: [String], newImageFullPaths: [String], isReceived: Bool) async throws {
        let writer = isReceived ? sender : AuthManager.shared.currentUser?.nickname ?? "유저"
        let recipient = isReceived ? AuthManager.shared.currentUser?.nickname ?? "유저" : receiver

        let newLetter = Letter(
            id: docId,
            writer: writer,
            recipient: recipient,
            summary: summary,
            date: date,
            text: text,
            isReceived: isReceived,
            isFavorite: false,
            imageURLs: newImageUrls,
            imageFullPaths: newImageFullPaths
        )

        try await FirestoreManager.shared.addLetter(docId: docId, letter: newLetter)

        await MainActor.run {
            FirestoreManager.shared.letters.append(newLetter)
        }
    }
}
