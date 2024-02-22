//
//  ContentView.swift
//  Swiftui1
//
//  Created by 양주원 on 1/23/24.
//

import SwiftUI
import SafariServices

struct ShopView: View {
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 9, alignment: .center),
        GridItem(.flexible(), spacing: 9, alignment: .center)
    ]
    let postDivision: [String] = ["캐릭터", "심플", "일러스트", "풍경", "맞춤제작"]
    
    @Binding var isThemeGroupButton: Int
    @State private var safariURL: String?
    @State private var selectedButtonIndex: Int = 0
    @State private var showDetails = false
    @ObservedObject private var shopViewModel = ShopViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("ShopView")
                        .font(.custom("SourceSerifPro-Black", size: 40))
                        .foregroundStyle(Color.postieOrange)
                    
                    Spacer()
                }
                // 카테고리 버튼
                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack(spacing: 10) {
                        ForEach(0...4, id: \.self) { index in
                            Button(action: {
                                selectedButtonIndex = index
                            }) {
                                ZStack {
                                    if selectedButtonIndex == index {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 70, height: 30)
                                            .background(Color(red: 1, green: 0.98, blue: 0.95))
                                            .cornerRadius(16)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .inset(by: 0.5)
                                                    .stroke(Color(red: 0.45, green: 0.45, blue: 0.45), lineWidth: 1)
                                            )} else {
                                                Rectangle()
                                                    .foregroundColor(.clear)
                                                    .frame(width: 72, height: 30)
                                                    .background(Color(red: 1, green: 0.98, blue: 0.95))
                                                    .cornerRadius(20)
                                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
                                            }
                                    
                                    Text(postDivision[index])
                                        .font(Font.custom("SF Pro Text", size: 12))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.12, green: 0.12, blue: 0.12))
                                        .frame(width: 60, alignment: .center)
                                }
                            }
                        }
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20)) // 스크롤에 대한 간격 넓히기
                })
                .padding()
                Spacer()
                
                ScrollView {
                    LazyVGrid(columns: columns, content: {
                        ForEach(dummyData[selectedButtonIndex], id:\.self) { character in
                            Button(action: {
                                safariURL = urls[character]!
                            }) {
                                Image(character)
                                    .resizable()
                                    .scaledToFit() //이미지 비율 조정
                                    .frame(width: 157, height: randomHeight)
                                    .padding(.bottom)
                                    .padding(.top)
                                    .background(.red)
                            }
                            .sheet(item: $safariURL) { url in
                                if let url = URL(string: url) {
                                    SafariView(url: url)
                                        .ignoresSafeArea() //외부링크가 화면에 맞게 조절
                                }
                            }
                        }
                    })
                }
            }
            .navigationTitle("ShopView")
        }
    }
}
//sheet(item:onDismiss:content:)호출시 해당 타입은 Identifiable 프로토콜 채택
extension String: Identifiable {
    public var id: Self { self }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
}

#Preview {
    ShopView()
}
