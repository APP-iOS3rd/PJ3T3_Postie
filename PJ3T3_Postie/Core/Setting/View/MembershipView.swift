//
//  MembershipView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/7/24.
//

import SwiftUI

// 멤버십 뷰, 실제 배포시에는 사라질 수도 있음
struct MembershipView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isMembershipPage = 1
    @State private var isMembershipForYear = true
    @Binding var isThemeGroupButton: Int
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        ZStack(alignment: .bottom) {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView {
                HStack {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(postieColors.tabBarTintColor)
                            .font(.title2)
                    }
                    .padding()
                }
                
                VStack {
                    Text("Postie")
                        .font(.custom("SourceSerifPro-Black", size: 30))
                        .foregroundColor(postieColors.tintColor)
                    + Text("의 Premium회원이 되어")
                        .font(.custom("SourceSerifPro-Black", size: 23))
                        .foregroundColor(postieColors.tabBarTintColor)
                    
                    Text("아래의 혜택을 만나보세요!")
                        .font(.custom("SourceSerifPro-Black", size: 23))
                        .foregroundStyle(postieColors.tabBarTintColor)
                    
                    TabView(selection: $isMembershipPage) {
                        MembershipItems(text: "광고제거", tag: 1, isThemeGroupButton: $isThemeGroupButton)
                        
                        MembershipItems(text: "사진 저장 가능 갯수 확장", tag: 2, isThemeGroupButton: $isThemeGroupButton)
                        
                        MembershipItems(text: "닉네임 변경 무료 (월 1회)", tag: 3, isThemeGroupButton: $isThemeGroupButton)
                        
                        MembershipItems(text: "포스티 프리미엄 혜택은 \n점점 더 늘어갈거에요!", tag: 4, isThemeGroupButton: $isThemeGroupButton)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
                    .frame(height: 250)
                    
                    Button(action: {
                        isMembershipForYear = true
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(height: 70)
                                .cornerRadius(20)
                                .foregroundStyle(postieColors.receivedLetterColor)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(isMembershipForYear ? postieColors.tintColor : postieColors.tintColor.opacity(0), lineWidth: 1)
                                    )
                            
                            HStack {
                                Text("연간 회원권")
                                
                                Spacer()
                                
                                VStack {
                                    Text("₩ 18,000")
                                    
                                    Text("월 ₩ 1,500")
                                }
                            }
                            .foregroundStyle(postieColors.tabBarTintColor)
                            .padding()
                        }
                        .padding(.horizontal)
                    }
                    
                    Button(action: {
                        isMembershipForYear = false
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(height: 70)
                                .cornerRadius(20)
                                .foregroundStyle(postieColors.receivedLetterColor)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(isMembershipForYear ? postieColors.tintColor.opacity(0) : postieColors.tintColor, lineWidth: 1)
                                    )
                            
                            HStack {
                                Text("월간 회원권")
                                
                                Spacer()
                                
                                Text("₩ 2,000")
                            }
                            .foregroundStyle(postieColors.tabBarTintColor)
                            .padding()
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("언제든 Appstore에서 구독 해지 가능합니다.")
                        .foregroundStyle(postieColors.tabBarTintColor)
                        .padding()
                    
                    Rectangle()
                        .frame(height: 100)
                        .foregroundStyle(Color.black.opacity(0))
                }
            }
            
            Button(action: {
            }) {
                ZStack {
                    Rectangle()
                        .frame(height: 65)
                        .cornerRadius(10)
                        .foregroundStyle(postieColors.tintColor)
                    
                    VStack {
                        Text(isMembershipForYear ? "연간 회원권 시작하기" : "월간 회원권 시작하기")
                            .bold()
                        
                        Text("무료 체험 1개월 제공")
                    }
                    .foregroundStyle(isThemeGroupButton == 4 ? .postieBlack : .postieWhite)
                    .padding()
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}

struct MembershipItems: View {
    var text: String
    var tag: Int
    
    @Binding var isThemeGroupButton: Int

    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        Text(text)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 180)
                    .frame(width: 300)
                    .foregroundStyle(postieColors.receivedLetterColor)
            )
            .tag(tag)
    }
}

//#Preview {
//    MembershipView()
//}
