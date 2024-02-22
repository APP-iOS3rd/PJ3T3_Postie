//
//  TextRecognizer.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/17.
//

import Foundation
import SwiftUI
import UIKit
import Vision

class TextRecognizer {
    let selectedImage: UIImage

    init(selectedImage: UIImage) {
        self.selectedImage = selectedImage
    }

    func recognizeText(completionHandler: @escaping (Result<String, Error>) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let cgImage = self.selectedImage.cgImage else { return }

            let requestHandler = VNImageRequestHandler(cgImage: cgImage)

            let request = VNRecognizeTextRequest()
            request.recognitionLanguages = ["ko-KR"]
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            do {
                try requestHandler.perform([request])

                guard let observations = request.results else { return }

                let recognizedText = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string

                }.joined(separator: "\n")

                DispatchQueue.main.async {
                    completionHandler(.success(recognizedText))
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }
    }
}
