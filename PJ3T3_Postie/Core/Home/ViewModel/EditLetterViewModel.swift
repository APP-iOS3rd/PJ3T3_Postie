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
}

