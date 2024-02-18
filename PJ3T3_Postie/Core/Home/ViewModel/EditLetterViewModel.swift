//
//  EditLetterViewModel.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/02/14.
//

import Foundation
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
    @Published var showUIImagePicker = false
    @Published var showLetterImageFullScreenView: Bool = false
    @Published var showTextRecognizerErrorAlert: Bool = false
    @Published var showSummaryTextField: Bool = false
    @Published var showSummaryAlert: Bool = false
    @Published var selectedIndex: Int = 0
    @Published var shouldDismiss: Bool = false

    private(set) var imagePickerSourceType: UIImagePickerController.SourceType = .camera

    func removeImage(at index: Int) {
        newImages.remove(at: index)
    }

    func showUIImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePickerSourceType = sourceType
        showUIImagePicker = true
    }

    private func dismissView() {
        shouldDismiss = true
    }

    // MARK: - Images

    @Published var newImages: [UIImage] = []

    @Published var fullPathsAndUrls: [FullPathAndUrl] = []
    var deleteCandidatesFromFullPathsANdUrls: [FullPathAndUrl] = []

    //TODO: 내부 함수들 Async로 변경 필요
    private func removeImages(docId: String, deleteCandidates: [FullPathAndUrl]) async {
        for deleteCandidate in deleteCandidatesFromFullPathsANdUrls {
            do {
                try await StorageManager.shared.deleteItemAsync(fullPath: deleteCandidate.fullPath)
            } catch {
                print("Failed to delte Image")
            }
        }
        
        do {
            try await FirestoreManager.shared.removeFullPathsAndUrlsAsync(
                docId: docId,
                fullPaths: deleteCandidates.map { $0.fullPath },
                urls: deleteCandidates.map { $0.url }
            )
        } catch {
            print("Failed to remove Full paths and urls")
        }
    }

    private func addImages(docId: String, newImages: [UIImage]) async -> ([String], [String]) {
        var newImageFullPaths = [String]()
        var newImageUrls = [String]()

        for image in newImages {
            do {
                let fullPath = try await StorageManager.shared.uploadUIImage(image: image, docId: docId)
                let url = try await StorageManager.shared.requestImageURL(fullPath: fullPath)

                newImageFullPaths.append(fullPath)
                newImageUrls.append(url)
            } catch {
                print("Failed to upload image: \(error)")
            }
        }

        return (newImageFullPaths, newImageUrls)
    }

    private func updateLetterInfo(docId: String, newImageUrls: [String], newImageFullPaths: [String], letter: Letter) async {
        do {
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
        } catch {
            print("Failed to update Letter")
        }
    }

    private func fetchLetter(docId: String) async {
        do {
            let updatedLetter = try await FirestoreManager.shared.getLetter(docId: docId)

            await MainActor.run {
                FirestoreManager.shared.letter = updatedLetter
            }
        } catch {
            print("Failed To update letter")
        }
    }

    private func fetchAllLetters() async {
        do {
            try await FirestoreManager.shared.fetchAllLettersAsync()
        } catch {
            print("Failed to fetch all Letters")
        }
    }

    func updateLetter(letter: Letter) async {
        await removeImages(docId: letter.id, deleteCandidates: deleteCandidatesFromFullPathsANdUrls)

        let (newImageFullPaths, newImageUrls) = await addImages(docId: letter.id, newImages: newImages)

        await updateLetterInfo(docId: letter.id, newImageUrls: newImageUrls, newImageFullPaths: newImageFullPaths, letter: letter)

        await fetchLetter(docId: letter.id)

        await fetchAllLetters()

        await MainActor.run {
            dismissView()
        }
    }

    func syncViewModelProperties(letter: Letter) {
        sender = letter.writer
        receiver = letter.recipient
        date = letter.date
        text = letter.text
        summary = letter.summary

        // 요약 텍스트 필드 확인
        showSummaryTextField = !letter.summary.isEmpty

        guard let urls = letter.imageURLs, let fullPaths = letter.imageFullPaths else { return }
        fullPathsAndUrls = zip(urls, fullPaths).map { FullPathAndUrl(fullPath: $0.1, url: $0.0) }
        print(fullPathsAndUrls)
    }
}
