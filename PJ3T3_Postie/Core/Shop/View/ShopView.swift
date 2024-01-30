//
//  ContentView.swift
//  Swiftui1
//
//  Created by 양주원 on 1/23/24.
//

import SwiftUI
import SafariServices

struct ShopView: View {
    
    @State private var selectedButtonIndex: Int = 0
    @State private var showDetails = false
    @State private var safariURL: String?
    
    let urls: [String: String] = [
        "poketmon" : "https://gloomy.co.kr/product/%ED%8F%AC%EC%BC%93%EB%AA%AC%EC%8A%A4%ED%84%B0-%EC%BA%90%EB%A6%AD%ED%84%B0-%ED%8E%B8%EC%A7%80%EC%A7%80-4p%EC%84%B8%ED%8A%B8%EB%9E%9C%EB%8D%A4%EB%B0%9C%EC%86%A1-129693/101233/",
        "poketmon2" :
            "https://www.pokemonstore.co.kr/pages/product/view.html?productNo=114168879",
        
        "sanrio" :  "https://usagimall.com/product/%EC%82%B0%EB%A6%AC%EC%98%A4-%EC%BA%90%EB%A6%AD%ED%84%B0-%EB%AA%A8%EC%96%91-%ED%8E%B8%EC%A7%80%EC%A7%80-10%EC%84%B8%ED%8A%B8/8154/",
        
        "digimon" : "https://www.cheonyu.com/product/view.html?qIDX=62957",
        
        "kuma" : "https://akaikaze00.cafe24.com/product/%EC%9D%BC%EB%B3%B8-%EB%A6%AC%EB%9D%BD%EC%BF%A0%EB%A7%88-%ED%8E%B8%EC%A7%80%EC%A7%80-%ED%8E%B8%EC%A7%80%EB%B4%89%ED%88%AC%EC%84%B8%ED%8A%B8%EA%B3%BC%EC%9D%BC/17384/",
        "crayon" : "https://akaikaze00.cafe24.com/product/%EC%A7%B1%EA%B5%AC%EB%8A%94%EB%AA%BB%EB%A7%90%EB%A0%A4-%ED%8E%B8%EC%84%A0%EC%A7%80-%ED%8E%B8%EC%A7%80%EC%A7%80%EC%84%B8%ED%8A%B8%EC%8B%9C%EC%A6%8C6-4color/18003/"
    ]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    let postDivision: [String] = ["캐릭터", "심플", "일러스트", "풍경", "컬러풀"]
    let postImage0: [String] = ["poketmon", "poketmon2", "sanrio", "digimon", "kuma", "crayon"]
    let postImage1: [String] = ["poketmon2", "sanrio", "digimon", "kuma", "crayon", "poketmon"]
    let dummyData = [["poketmon2", "sanrio", "digimon"],["kuma", "crayon", "poketmon"], [], [], []]
    
    var body: some View {
        NavigationStack {
            VStack {
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
                                            .frame(width: 70, height: 30)
                                            .foregroundColor(.clear)
                                            .font(.system(size: 13))
                                            .background(Color(red: 1, green: 0.98, blue: 0.95))
                                            .cornerRadius(20)
                                            .shadow(color: .black.opacity(0.88), radius: 3, x: 2, y: 2)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .inset(by: 0.5)
                                                    .stroke(Color(red: 0.45, green: 0.45, blue: 0.45), lineWidth: 2)
                                            )
                                    } else {
                                        Rectangle()
                                            .frame(width: 70, height: 30)
                                            .foregroundColor(.clear)
                                            .font(.system(size: 13))
                                            .background(Color(red: 1, green: 0.98, blue: 0.95))
                                            .cornerRadius(20)
                                            .shadow(color: .black.opacity(0.1), radius: 4, x: 3, y: 3)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .inset(by: 0.5)
                                                    .stroke(Color(red: 0.45, green: 0.45, blue: 0.45), lineWidth: 1)
                                            )
                                    }
                                    
                                    Text(postDivision[index])
                                        .font(Font.custom("SF Pro Text", size: 12))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red:  0.12, green: 0.12, blue: 0.12))
                                        .frame(width: 70)
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
                                    .scaledToFit()//이미지 비율 조정
                                    .frame(width: 157, height: 180)
                                    .padding()
                            }
                            .sheet(item: $safariURL) { url in
                                if let url = URL(string: url) {
                                    SafariView(url: url)
                                        .ignoresSafeArea()//외부링크가 화면에 맞게 조절
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
