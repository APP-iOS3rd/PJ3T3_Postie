//
//  NoticeView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/11/24.
//

import SwiftUI

struct NoticeView: View {
    @Binding var isThemeGroupButton: Int
    @State private var isExpanded = false
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        let posts = [
            Post(title: "언제나 변함없는 편지 앱, 포스티가 시작했습니다. 1.0 업데이트 안내", content: "언제나 변함없는 편지 앱, 포스티가 베타 테스트를 시작했습니다!", date: Date(), imageURL: nil),
            Post(title: "시작은 작은 한걸음 부터. 1.0.2 업데이트 안내", content: "편지 수정 기능을 강화했습니다.", date: Date(), imageURL: nil)
        ]
        
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(Array(posts.reversed()), id: \.id) { post in
                        DisclosureGroup {
                            ZStack {
                                postieColors.receivedLetterColor
                                    .ignoresSafeArea()
                                
                                VStack(alignment: .leading) {
                                    Text("안녕하세요 포스티팀입니다.\n")
                                    
//                                    if let imageURL = post.imageURL {
//                                        Image(systemName: "photo")
//                                            .resizable()
//                                            .scaledToFit()
//                                    }
                                    
                                    Text("\(post.content)\n")
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Text("From. ")
                                            .font(.custom("SourceSerifPro-Black", size: 15))
                                        + Text("포스티팀")
                                    }
                                }
                                .padding()
                            }
                        } label: {
                            VStack(alignment: .leading) {
                                Text(post.date.toString())
                                    .font(.caption)
                                    .foregroundColor(postieColors.dividerColor)
                                
                                Text(post.title)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                        DividerView(isThemeGroupButton: $isThemeGroupButton)
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("공지사항")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
        }
        .toolbarBackground(postieColors.backGroundColor, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Post {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
    var imageURL: String?
}

//#Preview {
//    NoticeView()
//}
