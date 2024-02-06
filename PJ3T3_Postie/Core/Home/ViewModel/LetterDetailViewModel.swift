//
//  LetterDetailViewModel.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/22.
//

import Foundation

class LetterDetailViewModel: ObservableObject {
    @Published var showLetterImageFullScreenView = false
    @Published var showDeleteAlert = false
    @Published var selectedIndex = 0
    @Published var isFavorite = false
}
