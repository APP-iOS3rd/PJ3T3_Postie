//
//  UIImagePicker.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/17.
//

import SwiftUI

struct UIImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .camera

    @Environment(\.dismiss) var dismiss
    @Binding var selectedImages: [UIImage]
    @Binding var text: String

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: UIImagePicker

        init(_ parent: UIImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

                let recognizer = TextRecognizer(selectedImage: image)
                recognizer.recognizeText()

                self.parent.selectedImages.append(image)
                if self.parent.text == "사진을 등록하면 자동으로 편지 내용이 입력됩니다." {
                    self.parent.text = recognizer.recognizedText
                } else {
                    self.parent.text.append(" \(recognizer.recognizedText)")
                }
            }
            parent.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
