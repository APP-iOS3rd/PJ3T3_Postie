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
    @Published var showLetterEditSheet = false

    func updateIsFavorite(docId: String) async {
        await MainActor.run {
            isFavorite.toggle()
        }

        do {
            try await FirestoreManager.shared.updateIsFavorite(docId: docId, isFavorite: isFavorite)

            try await fetchAllLetters()
        } catch {
            
        }
    }

    private func fetchAllLetters() async throws {
        try await FirestoreManager.shared.fetchAllLettersAsync()
    }
}
