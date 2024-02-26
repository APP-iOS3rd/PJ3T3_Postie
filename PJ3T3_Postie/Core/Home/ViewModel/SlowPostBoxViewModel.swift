//
//  SlowPostBoxViewModel.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/02/22.
//

import Foundation
import UIKit

class SlowPostBoxViewModel: ObservableObject {
    @Published var sender: String = ""
    @Published var receiver: String = ""
    @Published var date: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @Published var text: String = ""
    @Published var summary: String = ""
    @Published var images: [UIImage] = []
    @Published var selectedIndex: Int = 0
    @Published var showingUIImagePicker = false
    @Published var showingLetterImageFullScreenView: Bool = false
    @Published var showingTextRecognizerErrorAlert: Bool = false
    @Published var showingDismissAlert: Bool = false
    @Published var showingSummaryTextField: Bool = false
    @Published var showingSummaryAlert: Bool = false
    @Published var showingNotEnoughInfoAlert: Bool = false
    @Published var showingUploadErrorAlert: Bool = false
    @Published var showingSummaryErrorAlert: Bool = false
    @Published var showingImageConfirmationDialog: Bool = false
    @Published var showingSummaryConfirmationDialog: Bool = false
    @Published var shouldDismiss: Bool = false
    @Published var isLoading: Bool = false
    @Published var loadingText: String = "편지를 저장하고 있어요."

    private(set) var imagePickerSourceType: UIImagePickerController.SourceType = .camera
    var isReceived: Bool
    var isNotEnoughInfo: Bool {
        text.isEmpty
    }
    var currentUserName: String {
        AuthManager.shared.currentUser?.nickname ??
                        AuthManager.shared.currentUser?.fullName ??
                        AuthManager.shared.currentUser?.id ??
                        "유저"
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

    func showSummaryErrorAlert() {
        showingSummaryErrorAlert = true
    }

    func showUploadErrorAlert() {
        showingUploadErrorAlert = true
    }

    func showDismissAlert() {
        showingDismissAlert = true
    }

    func showConfirmationDialog() {
        showingImageConfirmationDialog = true
    }

    func showSummaryConfirmationDialog() {
        showingSummaryConfirmationDialog = true
    }

    func uploadLetter() async {
        if isNotEnoughInfo {
            await MainActor.run {
                showNotEnoughInfoAlert()
            }
        } else {
            await MainActor.run {
                isLoading = true
                loadingText = "편지를 저장하고 있어요."
            }

            do {
                let docId = UUID().uuidString

                let (newImageFullPaths, newImageUrls) = try await uploadImages(docId: docId)

                try await addLetter(docId: docId, newImageUrls: newImageUrls, newImageFullPaths: newImageFullPaths, isReceived: isReceived)

                setNotification(docId: docId, date: date)

                await MainActor.run {
                    dismissView()
                }
            } catch {
                await MainActor.run {
                    isLoading = false

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
        let writer = currentUserName
        let recipient = currentUserName

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

    func getSummary() async {
        do {
            let summaryResponse = try await APIClient.shared.postRequestToAPI(
                title: isReceived ? "\(sender)에게 받은 편지" : "\(receiver)에게 쓴 편지",
                content: text
            )

            await MainActor.run {
                summary = summaryResponse
                showSummaryTextField()
            }
        } catch {
            await MainActor.run {
                showSummaryErrorAlert()
            }
        }
    }

    func setNotification(docId: String, date: Date) {
        let manager = NotificationManager.shared
        //title이나 body 부분의 문구 여러가지로 배열 작성 해 두었다가 알람 뜰 때 랜덤으로 설정되면 좋을 것 같아요~
        manager.addNotification(id: docId, title: "포스티가 편지를 배달했어요", body: summary.count == 0 ? "포스티에서 내용을 확인 해 보세요" : summary)
        manager.setNotification(date: date)
    }
}
