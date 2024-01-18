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
    
    /// Vision 프레임워크를 사용해 사용자가 가져온 이미지에서 텍스트를 인식합니다.
    /// 인식이 끝나면 VNRecognizeTextRquest의 completionHandler가 호출됩니다.
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
    
    /// 이미지에서 인식된 텍스트 값으로 TextRecognizer 인스턴스의 recognizedText 변수를 업데이트 합니다.
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

        recognizedText = observations.compactMap {
            $0.topCandidates(1).first?.string
        }.joined(separator: "\n")
    }
}
