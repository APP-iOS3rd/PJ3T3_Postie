//
//  LetterPhoto.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/26/24.
//

import UIKit

struct LetterPhoto: Hashable, Identifiable {
    var id: String //파일명
    var urlString: String
    var image: UIImage

    init(id: String, urlString: String, image: UIImage) {
        self.id = id
        self.urlString = urlString
        self.image = image
    }
}
