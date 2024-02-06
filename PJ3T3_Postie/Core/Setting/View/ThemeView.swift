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
    @State private var isThemeGroupButton: Int = 0
    @State private var currentColorPage: Int = 0
    @Binding var isTabGroupButton: Bool
    @Binding var currentGroupPage: Int
    
    var body: some View {
        ZStack {
            Color.postieBeige
                .ignoresSafeArea()
            
            VStack {
                HStack(spacing: 10) {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 72, height: 30)
                            .background(selectedThemeButton ? Color.postieOrange : Color.postieWhite)
                            .cornerRadius(20)
                            .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 2, y: 2)
                        
                        Button(action: {
                            selectedThemeButton = true
                        }) {
                            Text("테마 설정")
                                .font(.caption)
                                .bold(selectedThemeButton)
                                .multilineTextAlignment(.center)
                                .foregroundColor(selectedThemeButton ? Color.postieWhite : Color.postieBlack)
                                .frame(width: 60, alignment: .top)
                        }
                    }
                    
                    ZStack(alignment: .center) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 72, height: 30)
                            .background(selectedThemeButton ? Color.postieWhite : Color.postieOrange)
                            .cornerRadius(20)
                            .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 2, y: 2)
                        
                        Button(action: {
                            selectedThemeButton = false
                        }) {
                            Text("나열 변경")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .bold(!selectedThemeButton)
                                .foregroundColor(selectedThemeButton ? Color.postieBlack : Color.postieWhite)
                                .frame(width: 60, alignment: .top)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
                if selectedThemeButton {
                    TabView(selection: $currentColorPage) {
                        Button(action: {
                            currentColorPage = 0
                            isThemeGroupButton = 0
                        }) {
                            VStack {
                                Text("포스티 오렌지 (기본)\n")
                                
                                Image("PostieTheme_PostieOrange")
                                    .resizable()
                                    .modifier(CustomImageModifier())
                                    .border(isThemeGroupButton == 0 ? Color.postieOrange : Color.postieOrange.opacity(0))
                                
                                Spacer()
                            }
                        }
                        .tag(0)
                        
                        Button(action: {
                            currentColorPage = 1
                            isThemeGroupButton = 1
                        }) {
                            VStack {
                                Text("포스티 옐로우\n")
                                
                                Image("PostieTheme_PostieYellow")
                                    .resizable()
                                    .modifier(CustomImageModifier())
                                    .border(isThemeGroupButton == 1 ? Color.postieOrange : Color.postieOrange.opacity(0))
                                
                                Spacer()
                            }
                        }
                        .tag(1)
                        
                        Button(action: {
                            currentColorPage = 2
                            isThemeGroupButton = 2
                        }) {
                            VStack {
                                Text("포스티 그린 \n")
                                
                                Image("PostieTheme_PostieGreen")
                                    .resizable()
                                    .modifier(CustomImageModifier())
                                    .border(isThemeGroupButton == 2 ? Color.postieOrange : Color.postieOrange.opacity(0))
                                
                                Spacer()
                            }
                        }
                        .tag(2)
                        
                        Button(action: {
                            currentColorPage = 3
                            isThemeGroupButton = 3
                        }) {
                            VStack {
                                Text("포스티 블루\n")
                                
                                Image("PostieTheme_PostieBlue")
                                    .resizable()
                                    .modifier(CustomImageModifier())
                                    .border(isThemeGroupButton == 3 ? Color.postieOrange : Color.postieOrange.opacity(0))
                                
                                Spacer()
                            }
                        }
                        .tag(3)
                        
                        Button(action: {
                            currentColorPage = 4
                            isThemeGroupButton = 4
                        }) {
                            VStack {
                                Text("포스티 블랙\n")
                                
                                Image("PostieTheme_PostieBlack")
                                    .resizable()
                                    .modifier(CustomImageModifier())
                                    .border(isThemeGroupButton == 4 ? Color.postieOrange : Color.postieOrange.opacity(0))
                                
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
                                    .border(isTabGroupButton ? Color.postieOrange : Color.postieOrange.opacity(0))
                                
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
                                    .border(isTabGroupButton ? Color.postieOrange.opacity(0) : Color.postieOrange)
                                
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
                    .foregroundStyle(Color.postieOrange)
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
        .tint(Color.postieBlack)
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
