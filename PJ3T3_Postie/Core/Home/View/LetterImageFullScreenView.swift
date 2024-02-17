//
//  LetterImageFullScreenView.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/17.
//

import SwiftUI

struct LetterImageFullScreenView: View {
    let images: [UIImage]?
    let urls: [String]?

    @Binding var pageIndex: Int
    @Environment(\.dismiss) var dismiss
    
    init(images: [UIImage]? = nil, urls: [String]? = nil, pageIndex: Binding<Int>) {
        self.images = images
        self.urls = urls
        self._pageIndex = pageIndex
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()

                TabView(selection: $pageIndex) {
                    if let images = images {
                        ForEach(0..<images.count, id: \.self) { index in
                            Image(uiImage: images[index])
                                .resizable()
                                .scaledToFit()
                        }
                    }

                    if let urls = urls {
                        ForEach(0..<urls.count, id: \.self) { index in
                            if let url = URL(string: urls[index]) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .tag(index)
                            }
                        }
                    }
                }
                .tabViewStyle(.page)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    LetterImageFullScreenView()
//}
