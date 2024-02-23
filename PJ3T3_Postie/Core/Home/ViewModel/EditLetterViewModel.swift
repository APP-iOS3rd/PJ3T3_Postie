//
//  EditLetterViewModel.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/02/14.
//

import Foundation
import OSLog
import UIKit

struct FullPathAndUrl {
    let fullPath: String
    let url: String
}

class EditLetterViewModel: ObservableObject {
    @Published var sender: String = ""
    @Published var receiver: String = ""
    @Published var date: Date = .now
    @Published var text: String = ""
    @Published var summary: String = ""
    @Published var showingUIImagePicker = false
    @Published var showingLetterImageFullScreenView: Bool = false
    @Published var showingTextRecognizerErrorAlert: Bool = false
    @Published var showingSummaryTextField: Bool = false
    @Published var showingSummaryAlert: Bool = false
    @Published var showingEditErrorAlert: Bool = false
    @Published var showingImageConfirmationDialog: Bool = false
    @Published var showingSummaryConfirmationDialog: Bool = false
    @Published var showingSummaryErrorAlert: Bool = false
    @Published var selectedIndex: Int = 0
    @Published var shouldDismiss: Bool = false
    @Published var isLoading: Bool = false
    @Published var loadingText: String = ""

    private(set) var imagePickerSourceType: UIImagePickerController.SourceType = .camera

    func removeImage(at index: Int) {
        newImages.remove(at: index)
    }

    func showUIImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePickerSourceType = sourceType
        showingUIImagePicker = true
    }

    func showEditErrorAlert() {
        showingEditErrorAlert = true
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

    private func dismissView() {
        shouldDismiss = true
    }

    func showConfirmationDialog() {
        showingImageConfirmationDialog = true
    }

    func showSummaryConfirmationDialog() {
        showingSummaryConfirmationDialog = true
    }

    // MARK: - Images

    @Published var newImages: [UIImage] = []

    @Published var fullPathsAndUrls: [FullPathAndUrl] = []
    var deleteCandidatesFromFullPathsANdUrls: [FullPathAndUrl] = []

    private func removeImages(docId: String, deleteCandidates: [FullPathAndUrl]) async throws {
        for deleteCandidate in deleteCandidatesFromFullPathsANdUrls {
            try await StorageManager.shared.deleteItemAsync(fullPath: deleteCandidate.fullPath)
        }

        try await FirestoreManager.shared.removeFullPathsAndUrlsAsync(
            docId: docId,
            fullPaths: deleteCandidates.map { $0.fullPath },
            urls: deleteCandidates.map { $0.url }
            )
    }

    private func addImages(docId: String, newImages: [UIImage]) async throws -> ([String], [String]) {
        var newImageFullPaths = [String]()
        var newImageUrls = [String]()

        for image in newImages {
            let fullPath = try await StorageManager.shared.uploadUIImage(image: image, docId: docId)
            let url = try await StorageManager.shared.requestImageURL(fullPath: fullPath)

            newImageFullPaths.append(fullPath)
            newImageUrls.append(url)
        }

        return (newImageFullPaths, newImageUrls)
    }

    private func updateLetterInfo(docId: String, newImageUrls: [String], newImageFullPaths: [String], letter: Letter) async throws {
        try await FirestoreManager.shared.updateLetterAsync(
            docId: docId,
            writer: sender,
            recipient: receiver,
            summary: summary,
            date: date,
            text: text,
            isReceived: letter.isReceived,
            isFavorite: letter.isFavorite,
            imageURLs: newImageUrls,
            imageFullPaths: newImageFullPaths
        )
    }

    private func fetchLetter(docId: String) async throws {
        let updatedLetter = try await FirestoreManager.shared.getLetter(docId: docId)

        await MainActor.run {
            FirestoreManager.shared.letter = updatedLetter
        }
    }

    private func fetchAllLetters() async throws {
        try await FirestoreManager.shared.fetchAllLettersAsync()
    }

    func updateLetter(letter: Letter) async {
        do {
            await MainActor.run {
                isLoading = true
                loadingText = "편지를 수정하고 있어요."
            }

            try await removeImages(docId: letter.id, deleteCandidates: deleteCandidatesFromFullPathsANdUrls)

            let (newImageFullPaths, newImageUrls) = try await addImages(docId: letter.id, newImages: newImages)

            try await updateLetterInfo(docId: letter.id, newImageUrls: newImageUrls, newImageFullPaths: newImageFullPaths, letter: letter)

            try await fetchLetter(docId: letter.id)

            try await fetchAllLetters()

            await MainActor.run {
                dismissView()
            }
        } catch {
            await MainActor.run {
                isLoading = false

                showEditErrorAlert()
            }
            Logger.firebase.error("Failed to edit letter: \(error)")
        }
    }

    func syncViewModelProperties(letter: Letter) {
        sender = letter.writer
        receiver = letter.recipient
        date = letter.date
        text = letter.text
        summary = letter.summary

        // 요약 텍스트 필드 확인
        showingSummaryTextField = !letter.summary.isEmpty

        guard let urls = letter.imageURLs, let fullPaths = letter.imageFullPaths else { return }
        fullPathsAndUrls = zip(urls, fullPaths).map { FullPathAndUrl(fullPath: $0.1, url: $0.0) }
    }

    func getSummary(isReceived: Bool) async {
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
}
