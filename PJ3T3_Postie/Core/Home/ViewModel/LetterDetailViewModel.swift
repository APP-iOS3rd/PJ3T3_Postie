//
//  LetterDetailViewModel.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/22.
//

import Foundation
import OSLog

class LetterDetailViewModel: ObservableObject {
    @Published var showLetterImageFullScreenView = false
    @Published var showDeleteAlert = false
    @Published var selectedIndex = 0
    @Published var isFavorite = false
    @Published var showLetterEditSheet = false
    @Published var shouldDismiss: Bool = false
    @Published var showingDeleteErrorAlert: Bool = false
    @Published var isLoading: Bool = false

    private func dismissView() {
        shouldDismiss = true
    }

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

    func deleteLetter(docId: String) async {
        do {
            await MainActor.run {
                isLoading = true
            }

            try await FirestoreManager.shared.deleteLetterAsync(documentId: docId)

            try await StorageManager.shared.deleteFolderAsync(docId: docId)

            try await fetchAllLetters()

            await MainActor.run {
                dismissView()
            }
        } catch {
            await MainActor.run {
                isLoading = false
            }

            showingDeleteErrorAlert = true
            Logger.firebase.error("Failed to delete Letter: \(error)")
        }
    }

    private func fetchAllLetters() async throws {
        try await FirestoreManager.shared.fetchAllLettersAsync()
    }
}
