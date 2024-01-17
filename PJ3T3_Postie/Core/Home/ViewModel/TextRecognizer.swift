//
//  TextRecognizer.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/17.
//

import Foundation
import UIKit
import Vision

class TextRecognizer {
    let selectedImage: UIImage
    var recognizedText = ""

    init(selectedImage: UIImage) {
        self.selectedImage = selectedImage
    }

    func recognizeText() {
        guard let cgImage = selectedImage.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        request.recognitionLanguages = ["ko-KR"]
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        do {
            try requestHandler.perform([request])
        } catch {

        }
    }

    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

        recognizedText = observations.compactMap {
            $0.topCandidates(1).first?.string
        }.joined(separator: "\n")
    }
}
