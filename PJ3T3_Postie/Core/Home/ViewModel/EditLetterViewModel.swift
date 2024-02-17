//
//  EditLetterViewModel.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/02/14.
//

import Foundation
import UIKit

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

    private(set) var imagePickerSourceType: UIImagePickerController.SourceType = .camera

    func removeImage(at index: Int) {
        newImages.remove(at: index)
    }

    func showUIImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePickerSourceType = sourceType
        showUIImagePicker = true
    }

    // MARK: - Images

    @Published var currentLetterPhoto: [LetterPhoto] = []
    var deleteCandidatesFromCurrentLetterPhoto: [LetterPhoto] = []

    @Published var newImages: [UIImage] = [] 

    var currentLetterPhotosAndNewImages: [UIImage] {
        currentLetterPhoto.map({ $0.image }) + newImages
    }

    @Published var fullPathsAndUrls: [FullPathAndUrl] = []
    var deleteCandidatesFromFullPathsANdUrls: [FullPathAndUrl] = []

    /// 이미 작성된 편지를 수정합니다.
    /// - Parameter letter: 작성된 편지
    ///
    /// 1. Firestore에 저장된 편지 데이터를 수정
    /// 2. FirestoreManager의 @Published letter 변수 업데이트 ( AddView, DetailView 연동을 위해서 )
    func editLetter(letter: Letter) async {
        FirestoreManager.shared.editLetter(
            documentId: letter.id,
            writer: sender,
            recipient: receiver,
            summary: summary,
            date: date,
            text: text,
            isReceived: letter.isReceived,
            isFavorite: letter.isFavorite
        )


        await MainActor.run {
            FirestoreManager.shared.letter = Letter(
                id: letter.id,
                writer: sender,
                recipient: receiver,
                summary: summary,
                date: date,
                text: text,
                isReceived: letter.isReceived,
                isFavorite: letter.isFavorite
            )
        }

        FirestoreManager.shared.fetchAllLetters()

    }

    func updateImages(letter: Letter) async {
        for deleteCandidate in deleteCandidatesFromCurrentLetterPhoto {
            if let index = StorageManager.shared.images.firstIndex(of: deleteCandidate) {
                StorageManager.shared.deleteItem(fullPath: deleteCandidate.fullPath)
            }
        }

        for newImage in newImages {
                do {
                    let imageFullPath = try await StorageManager.shared.uploadUIImage(
                        image: newImage,
                        docId: letter.id
                    )

                    let newLetterPhoto = try await StorageManager.shared.formatToLetterPhoto(
                        fullPath: imageFullPath,
                        uiImage: newImage
                    )

                    await MainActor.run {
                        StorageManager.shared.images.append(newLetterPhoto)
                    }
                } catch {
                    print("Failed To upload Image: \(error)")
                }
        }
    }

    func updateLetter(letter: Letter, docId: String, deleteFullPaths: [String], deleteUrls: [String]) async {
        var newImageFullPaths = [String]()
        var newImageUrls = [String]()

        // 이미지 삭제
        for deleteCandidate in deleteCandidatesFromFullPathsANdUrls {
            StorageManager.shared.deleteItem(fullPath: deleteCandidate.fullPath)
        }

        FirestoreManager.shared.removeFullPathsAndURLs(docId: docId, fullPaths: deleteCandidatesFromFullPathsANdUrls.map { $0.fullPath}, urls: deleteCandidatesFromFullPathsANdUrls.map { $0.url} )

        // 이미지 추가
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
        
        FirestoreManager.shared.updateLetter(
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

        do {
            let updatedLetter = try await FirestoreManager.shared.getLetter(docId: docId)

            await MainActor.run {
                FirestoreManager.shared.letter = updatedLetter
            }
        } catch {
            print("Failed To update letter")
        }

        FirestoreManager.shared.fetchAllLetters()
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

struct FullPathAndUrl {
    let fullPath: String
    let url: String
}
