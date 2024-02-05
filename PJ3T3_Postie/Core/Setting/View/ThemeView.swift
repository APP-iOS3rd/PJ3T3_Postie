//
//  ThemeView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 1/30/24.
//

import SwiftUI

struct ThemeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var selectedThemeButton: Bool = true
    @Binding var isThemeGroupButton: Int
    @Binding var currentColorPage: Int
    @Binding var isTabGroupButton: Bool
    @Binding var currentGroupPage: Int
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            VStack {
                HStack(spacing: 10) {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 72, height: 30)
                            .background(selectedThemeButton ? postieColors.tintColor : postieColors.receivedLetterColor)
                            .cornerRadius(20)
                            .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 2, y: 2)
                        
                        Button(action: {
                            selectedThemeButton = true
                        }) {
                            if isThemeGroupButton == 4 {
                                Text("테마 설정")
                                    .font(.caption)
                                    .bold(selectedThemeButton)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(selectedThemeButton ? Color.postieBlack : Color.postieWhite)
                                    .frame(width: 60, alignment: .top)
                            } else {
                                Text("테마 설정")
                                    .font(.caption)
                                    .bold(selectedThemeButton)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(selectedThemeButton ? Color.postieWhite : Color.postieBlack)
                                    .frame(width: 60, alignment: .top)
                            }
                        }
                    }
                    
                    ZStack(alignment: .center) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 72, height: 30)
                            .background(selectedThemeButton ? postieColors.receivedLetterColor : postieColors.tintColor)
                            .cornerRadius(20)
                            .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 2, y: 2)
                        
                        Button(action: {
                            selectedThemeButton = false
                        }) {
                            if isThemeGroupButton == 4 {
                                Text("나열 변경")
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .bold(!selectedThemeButton)
                                    .foregroundColor(selectedThemeButton ? Color.postieWhite : Color.postieBlack)
                                    .frame(width: 60, alignment: .top)
                            } else {
                                Text("나열 변경")
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .bold(!selectedThemeButton)
                                    .foregroundColor(selectedThemeButton ? Color.postieBlack : Color.postieWhite)
                                    .frame(width: 60, alignment: .top)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
                if selectedThemeButton {
                    TabView(selection: $currentColorPage) {
                        Button(action: {
                            isThemeGroupButton = 0
                            currentColorPage = isThemeGroupButton
                        }) {
                            VStack {
                                Text("포스티 오렌지 (기본)\n")
                                
                                Image("PostieTheme_PostieOrange")
                                    .resizable()
                                    .modifier(CustomImageModifier())
                                    .border(isThemeGroupButton == 0 ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                
                                Spacer()
                            }
                        }
                        .tag(0)
                        
                        Button(action: {
                            isThemeGroupButton = 1
                            currentColorPage = isThemeGroupButton
                        }) {
                            VStack {
                                Text("포스티 옐로우\n")
                                
                                Image("PostieTheme_PostieYellow")
                                    .resizable()
                                    .modifier(CustomImageModifier())
                                    .border(isThemeGroupButton == 1 ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                
                                Spacer()
                            }
                        }
                        .tag(1)
                        
                        Button(action: {
                            isThemeGroupButton = 2
                            currentColorPage = isThemeGroupButton
                        }) {
                            VStack {
                                Text("포스티 그린 \n")
                                
                                Image("PostieTheme_PostieGreen")
                                    .resizable()
                                    .modifier(CustomImageModifier())
                                    .border(isThemeGroupButton == 2 ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                
                                Spacer()
                            }
                        }
                        .tag(2)
                        
                        Button(action: {
                            isThemeGroupButton = 3
                            currentColorPage = isThemeGroupButton
                        }) {
                            VStack {
                                Text("포스티 블루\n")
                                
                                Image("PostieTheme_PostieBlue")
                                    .resizable()
                                    .modifier(CustomImageModifier())
                                    .border(isThemeGroupButton == 3 ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                
                                Spacer()
                            }
                        }
                        .tag(3)
                        
                        Button(action: {
                            isThemeGroupButton = 4
                            currentColorPage = isThemeGroupButton
                        }) {
                            VStack {
                                Text("포스티 블랙\n")
                                
                                Image("PostieTheme_PostieBlack")
                                    .resizable()
                                    .modifier(CustomImageModifier())
                                    .border(isThemeGroupButton == 4 ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                
                                Spacer()
                            }
                        }
                        .tag(4)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                } else {
                    TabView(selection: $currentGroupPage) {
                        Button(action: {
                            currentGroupPage = 0
                            isTabGroupButton = true
                        }) {
                            VStack {
                                Text("편지 그룹\n")
                                
                                Image("PostieTheme_LetterGroup")
                                    .resizable()
                                    .modifier(CustomImageModifier())
                                    .border(isTabGroupButton ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                
                                Spacer()
                            }
                        }
                        .tag(0)
                        
                        Button(action: {
                            currentGroupPage = 1
                            isTabGroupButton = false
                        }) {
                            VStack {
                                Text("편지 리스트\n")
                                
                                Image("PostieTheme_LetterList")
                                    .resizable()
                                    .modifier(CustomImageModifier())
                                    .border(isTabGroupButton ? postieColors.tintColor.opacity(0) : postieColors.tintColor)
                                
                                Spacer()
                            }
                        }
                        .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
                
                Spacer()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("테마 설정")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    currentColorPage = currentColorPage
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("완료")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .tint(postieColors.tabBarTintColor)
    }
}

struct CustomImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .frame(height: 550)
            .shadow(color: Color.postieBlack.opacity(0.1), radius: 3)
    }
}

//#Preview {
//    ThemeView()
//}
