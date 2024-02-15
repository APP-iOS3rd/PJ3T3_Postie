//
//  NoticeView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/11/24.
//

import SwiftUI

struct NoticeView: View {
    @ObservedObject var firestoreNoticeManager = FirestoreNoticeManager.shared
    @State private var isExpanded = false
    
    var body: some View {
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ForEach(firestoreNoticeManager.notices.sorted(by: { $0.date > $1.date }), id:\.self) { notice in
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
                                    
                                    Text("\(notice.content.replacingOccurrences(of: "\\n", with: "\n"))\n")
                                    
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

//#Preview {
//    NoticeView()
//}
