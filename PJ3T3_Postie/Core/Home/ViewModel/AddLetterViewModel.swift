//
//  AddLetterViewModel.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/17.
//

import Foundation
import SwiftUI
import UIKit

final class AddLetterViewModel: ObservableObject {
    @Published var sender: String = ""
    @Published var receiver: String = ""
    @Published var date: Date = .now
    @Published var text: String = ""
    @Published var summary: String = ""
    @Published var images: [UIImage] = []
    @Published var showUIImagePicker = false
    @Published var showingLetterImageFullScreenView: Bool = false
    @Published var showTextRecognizerErrorAlert: Bool = false
    @Published var showingSummaryTextField: Bool = false
    @Published var showingSummaryAlert: Bool = false
    @Published var selectedIndex: Int = 0

    private(set) var imagePickerSourceType: UIImagePickerController.SourceType = .camera
    let isReceived: Bool
    var letter: Letter?
    var letterPhotos: [LetterPhoto]?

    init(isReceived: Bool, letter: Letter?, letterPhotos: [LetterPhoto]?) {
        self.isReceived = isReceived
        self.letter = letter
        self.letterPhotos = letterPhotos
    }

    func removeImage(at index: Int) {
        images.remove(at: index)
        FirestoreManager.shared.deleteLetter(documentId: "df")
    }

    func showUIImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePickerSourceType = sourceType
        showUIImagePicker = true 
    }

    /// 이미 작성된 편지를 수정합니다.
    ///
    /// 1. Firestore에 저장된 편지 데이터를 수정
    /// 2. Firestorage에 저장된 편지 이미지를 수정 후 불러와 데이터 상태 업데이트
    /// 3. FirestoreManager의 @Published letter 변수 업데이트 ( AddView, DetailView 연동을 위해서 )
    /// 4. `firestoreManager.fetchAllLetters()`을 홈뷰, 디테일뷰 데이터 상태 업데이트
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

        if var savedLetterPhotos = letterPhotos {
            var uiImagesAndFullPaths = savedLetterPhotos.map { (image: $0.image , fullPath: $0.fullPath)}

            for uiImageAndFullPath in uiImagesAndFullPaths {
                if !images.contains(uiImageAndFullPath.image) {
                    if let index = uiImagesAndFullPaths.firstIndex(where: { $0 == uiImageAndFullPath }) {
                        uiImagesAndFullPaths.remove(at: index)
                        StorageManager.shared.deleteItem(fullPath: uiImageAndFullPath.fullPath)
                    }
                }
            }

            for image in images {
                if !uiImagesAndFullPaths.map( { $0.image } ).contains(image) {
                    do {
                        try await StorageManager.shared.saveUIImage(images: [image], docId: letter.id)
                    } catch {
                        // TODO: ERROR 처리 필요
                        print("DEBUG: 이미지 저장 실패")
                    }
                }
            }

            StorageManager.shared.images.removeAll()

            StorageManager.shared.listAllFile(docId: letter.id)
        }

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

        FirestoreManager.shared.fetchAllLetters()
    }
    
    /// 편지를 추가합니다
    ///
    /// 1. Firestore에 편지 추가
    /// 2. 편지 이미지 값이 존재하면 Firestorage에 이미지 추가
    /// 3. 모든 편지 불러와서 상태 업데이트
    func addLetter() async {
        await FirestoreManager.shared.addLetter(
            writer: isReceived ? sender : AuthManager.shared.currentUser?.fullName ?? "유저",
            recipient: isReceived ? AuthManager.shared.currentUser?.fullName ?? "유저" : receiver,
            summary: summary,
            date: date,
            text: text,
            isReceived: isReceived,
            isFavorite: false
        )

        if !images.isEmpty {
            do {
                try await StorageManager.shared.saveUIImage(
                    images: images,
                    docId: FirestoreManager.shared.docId
                )
            } catch {
                // TODO: Error 처리 필요
                print("DEBUG: Failed to save UIImages to Firestore: \(error)")
            }
        }

        FirestoreManager.shared.fetchAllLetters()
    }
    
    func updateLetterInfoFromLetter() {
        guard let letter = letter else { return }

        if isReceived {
            sender = letter.writer
        } else {
            receiver = letter.recipient
        }

        date = letter.date
        text = letter.text
        summary = letter.summary
        images = letterPhotos?.map { $0.image } ?? []
    }

    func saveLetterChanges() async {
        if let letter = letter {
            await editLetter(letter: letter)
        } else {
            await addLetter()
        }
    }

    func showSummaryTextField() {
        showingSummaryTextField = true
    }

    func showLetterImageFullScreenView(at index: Int) {
        selectedIndex = index
        showingLetterImageFullScreenView = true
    }

    func showSummaryAlert() {
        showingSummaryAlert = true
    }
}
