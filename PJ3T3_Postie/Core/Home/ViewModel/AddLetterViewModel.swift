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


    private(set) var imagePickerSourceType: UIImagePickerController.SourceType = .camera

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

    /// 편지를 서버에 저장합니다.
    /// - Parameter isReceived: 받은 편지 혹은 보낸 편지 여부
    func addLetter(isReceived: Bool) async {
        await FirestoreManager.shared.addLetter(
            writer: isReceived ? sender : AuthManager.shared.currentUser?.nickname ?? "유저",
            recipient: isReceived ? AuthManager.shared.currentUser?.nickname ?? "유저" : receiver,
            summary: summary,
            date: date,
            text: text,
            isReceived: isReceived,
            isFavorite: false
        )

        FirestoreManager.shared.fetchAllLetters()
    }

    func uploadLetter(isReceived: Bool) async {
        var newImageFullPaths = [String]()
        var newImageUrls = [String]()
        let docId = UUID().uuidString

        for image in images {
            do {
                let fullPath = try await StorageManager.shared.uploadUIImage(image: image, docId: docId)

                let url = try await StorageManager.shared.requestImageURL(fullPath: fullPath)
                
                newImageFullPaths.append(fullPath)
                newImageUrls.append(url)
            } catch {
                print("Failed to upload image: \(error)")
            }
        }

        do {
            let letter = Letter(
                id: docId,
                writer: isReceived ? sender : AuthManager.shared.currentUser?.nickname ?? "유저",
                recipient: isReceived ? AuthManager.shared.currentUser?.nickname ?? "유저" : receiver,
                summary: summary,
                date: date,
                text: text,
                isReceived: isReceived,
                isFavorite: false,
                imageURLs: newImageUrls,
                imageFullPaths: newImageFullPaths
            )

            try await FirestoreManager.shared.addLetter(docId: docId, letter: letter)

            await MainActor.run {
                FirestoreManager.shared.letters.append(letter)
            }
        } catch {
            print("Failed to upload letter: \(error)")
        }
    }
}
