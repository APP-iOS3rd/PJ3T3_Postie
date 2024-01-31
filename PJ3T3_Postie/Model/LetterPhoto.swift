//
//  LetterPhoto.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/26/24.
//

import UIKit

struct LetterPhoto: Hashable, Identifiable {
    let id: String //파일명
    let fullPath: String
    let urlString: String
    let image: UIImage

    init(id: String, fullPath: String, urlString: String, image: UIImage) {
        self.id = id
        self.fullPath = fullPath
        self.urlString = urlString
        self.image = image
    }
}
