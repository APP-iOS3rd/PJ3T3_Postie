//
//  LetterImageFullScreenView.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/17.
//

import SwiftUI

import Kingfisher

struct LetterImageFullScreenView: View {
    let images: [UIImage]?
    let urls: [String]?

    var urlsCount: Int {
        guard let urls = urls else { return 0 }
        return urls.count
    }
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
                    if let urls = urls {
                        ForEach(0..<urls.count, id: \.self) { index in
                            if let url = URL(string: urls[index]) {
                                KFImage(url)
                                    .placeholder {
                                        ProgressView()
                                    }
                                    .resizable()
                                    .scaledToFit()
                                    .tag(index)
                            }
                        }
                    }

                    if let images = images {
                        ForEach(0..<images.count, id: \.self) { index in
                            Image(uiImage: images[index])
                                .resizable()
                                .scaledToFit()
                                .tag(urlsCount + index)
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
                                .foregroundStyle(.postieWhite)
                        }
                    }
                }
                .modifier(SwipeToDismissModifier(onDismiss: {
                    dismiss()
                }))
            }
        }
    }
}

struct SwipeToDismissModifier: ViewModifier {
    var onDismiss: () -> Void
    @State private var offset: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .offset(y: offset.height)
            .animation(.interactiveSpring(), value: offset)
            .simultaneousGesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width < 50 {
                            offset = gesture.translation
                        }
                    }
                    .onEnded { _ in
                        if abs(offset.height) > 100 {
                            onDismiss()
                        } else {
                            offset = .zero
                        }
                    }
            )
    }
}


#Preview {
    LetterImageFullScreenView(images: [UIImage(systemName: "heart")!], urls: nil, pageIndex: .constant(0))
}
