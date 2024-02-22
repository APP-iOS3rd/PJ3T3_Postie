//
//  NoticeView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/11/24.
//

import SwiftUI

struct NoticeView: View {
    @ObservedObject var firestoreNoticeManager = FirestoreNoticeManager.shared
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @State private var isExpanded = false
    
    var body: some View {
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    if firestoreNoticeManager.notices.isEmpty {
                        VStack {
                            Image(isThemeGroupButton == 4 ? "postyThinkingSketchWhite" : "postyThinkingSketch")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                            
                            Text("공지가 로딩중입니다.")
                                .foregroundStyle(postieColors.tabBarTintColor)
                        }
                    }
                    
                    ForEach(firestoreNoticeManager.notices.sorted(by: { $0.date > $1.date }), id:\.self) { notice in
                        DisclosureGroup {
                            ZStack {
                                postieColors.receivedLetterColor
                                    .ignoresSafeArea()
                                
                                VStack(alignment: .leading) {
                                    Text("안녕하세요 포스티팀입니다.\n")
                                        .font(.callout)
                                    
//                                    if let imageURL = post.imageURL {
//                                        Image(systemName: "photo")
//                                            .resizable()
//                                            .scaledToFit()
//                                    }
                                    
                                    Text("\(parseText(notice.content.replacingOccurrences(of: "\\n", with: "\n")))\n")
                                        .font(.callout)
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Text("From. ")
                                            .font(.custom("SourceSerifPro-Black", size: 16))
                                        + Text("포스티팀")
                                            .font(.callout)
                                    }
                                }
                                .padding()
                            }
                            .padding(.top, 10)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(notice.date.toString())
                                    .font(.caption)
                                    .foregroundColor(postieColors.dividerColor)
                                
                                Text(notice.title)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                        DividerView()
                    }
                }
                .onAppear {
                    if firestoreNoticeManager.notices.isEmpty {
                        firestoreNoticeManager.fetchAllNotices()
                    }
                }
            }
            .padding(.leading)
            .padding(.trailing)
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

func parseText(_ text: String) -> Text {
    var resultText = Text("")
    var tempText = text
    
    while let range = tempText.range(of: "bold(") {
        let textBeforeBold = tempText[..<range.lowerBound]
        tempText.removeSubrange(..<range.upperBound)
        
        if let endRange = tempText.range(of: ")") {
            let boldText = tempText[..<endRange.lowerBound]
            tempText.removeSubrange(..<endRange.upperBound)
            
            resultText = resultText + Text(textBeforeBold) + Text(boldText).bold()
        }
    }
    
    resultText = resultText + Text(tempText) // 나머지 텍스트 추가
    
    return resultText
}

//#Preview {
//    NoticeView()
//}
