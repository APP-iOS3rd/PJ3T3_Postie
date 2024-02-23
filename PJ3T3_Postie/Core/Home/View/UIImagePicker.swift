//
//  UIImagePicker.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/17.
//

import SwiftUI

struct UIImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .camera

    @Binding var selectedImages: [UIImage]
    @Binding var text: String
    @Binding var isLoading: Bool
    @Binding var showingTextRecognizerErrorAlert: Bool
    @Binding var loadingText: String

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: UIImagePicker

        init(_ parent: UIImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            guard !picker.isBeingDismissed else {
                return
            }
            self.parent.loadingText = "글자를 인식하고 있어요."
            self.parent.isLoading = true

            picker.dismiss(animated: true) {
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.parent.selectedImages.append(image)

                    let recognizer = TextRecognizer(selectedImage: image)
                    recognizer.recognizeText { result in
                        switch result {
                        case .success(let recognizedText):
                            self.parent.text.append("\(recognizedText)")
                            self.parent.isLoading = false
                        case.failure(let error):
                            self.parent.showingTextRecognizerErrorAlert = true
                            self.parent.isLoading = false
                        }
                    }
                }
            }

        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
