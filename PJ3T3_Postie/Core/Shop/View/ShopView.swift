//
//  ContentView.swift
//  Swiftui1
//
//  Created by 양주원 on 1/23/24.
//

import SwiftUI
import SafariServices
import Kingfisher

struct ShopView: View {
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 9, alignment: .center),
        GridItem(.flexible(), spacing: 9, alignment: .center)
    ]
    let postDivision: [String] = ["심플", "일러스트", "캐릭터", "커스텀", "풍경"]
    var filteredLetters: [Shop] {
        switch selectedButtonIndex {
        case 0:
            return shopViewModel.shops.filter { $0.category == "simple" }
        case 1:
            return shopViewModel.shops.filter { $0.category == "illustration" }
        case 2:
            return shopViewModel.shops.filter { $0.category == "character" }
        case 3:
            return shopViewModel.shops.filter { $0.category == "custom" }
        case 4:
            return shopViewModel.shops.filter { $0.category == "sight" }
            // 추가적인 카테고리에 대한 필터링 추가
        default:
            return []
        }
    }
    
    @State private var safariURL: String?
    @State private var selectedButtonIndex: Int = 0
    @State private var showDetails = false
    @ObservedObject private var shopViewModel = FirestoreShopManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                postieColors.backGroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Letter Shop")
                            .font(.custom("SourceSerifPro-Black", size: 40))
                            .foregroundStyle(postieColors.tintColor)
                        
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
                                                .background(postieColors.tintColor)
                                                .cornerRadius(16)
                                                } else {
                                                    Rectangle()
                                                        .foregroundColor(.clear)
                                                        .frame(width: 72, height: 30)
                                                        .background(postieColors.receivedLetterColor)
                                                        .cornerRadius(20)
                                                        .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
                                                }
                                        
                                        Text(postDivision[index])
                                            .font(Font.custom("SF Pro Text", size: 12))
                                            .bold()
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(selectedButtonIndex == index ? postieColors.receivedLetterColor : postieColors.tabBarTintColor)
                                            .frame(width: 60, alignment: .center)
                                    }
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))  //스크롤에 대한 간격 넓히기
                    })
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 9, content: {
                            ForEach(filteredLetters, id:\.self) { shop in
                                ShopButton(shop: shop, safariURL: $safariURL)
                            }
                        })
                    }
                }
                .padding()
            }
        }
        .onAppear() {
            shopViewModel.fetchAllShops()
            
        }
    }
}
//sheet(item:onDismiss:content:)호출시 해당 타입은 Identifiable 프로토콜 채택
extension String: Identifiable {
    public var id: Self { self }
}

struct ShopButton: View {
    let shop: Shop
    
    @Binding var safariURL: String?
    
    var body: some View {
        Button(action: {
            safariURL = shop.shopUrl
        }) {
            ZStack {
                KFImage(URL(string: shop.thumbUrl))
                    .resizable()
                    .placeholder({
                        ProgressView()
                    })
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.2), Color.clear]), startPoint: .bottom, endPoint: .top))
                            .frame(height: 30)
                            .cornerRadius(10)
                        
                        HStack {
                            Text(shop.title)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .font(.custom("SourceSerifPro-Light", size: 12))
                                .lineLimit(1)
                                .padding(.leading, 8)
                            
                            Spacer()
                        }
                    }
                }
                
            }
            
            
        }
        .sheet(item: $safariURL) { url in
            if let url = URL(string: url) {
                SafariView(url: url)
                    .ignoresSafeArea() //외부링크가 화면에 맞게 조절
            }
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
}

