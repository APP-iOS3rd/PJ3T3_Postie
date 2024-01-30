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
    @State private var currentColorPage: Int = 0
    @State private var currentGroupPage: Int = 0
    
    var body: some View {
        ZStack {
            Color(hex: 0xF5F1E8)
                .ignoresSafeArea()
            
            VStack {
                HStack(spacing: 10) {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 72, height: 30)
                            .background(selectedThemeButton ? Color(hex: 0xFF5733) : Color(hex: 0xFCFBF7))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
                        
                        Button(action: {
                            selectedThemeButton = true
                        }) {
                            Text("테마 설정")
                                .font(.caption)
                                .bold(selectedThemeButton)
                                .multilineTextAlignment(.center)
                                .foregroundColor(selectedThemeButton ? Color(hex: 0xFFFFFF) : Color(hex: 0x1E1E1E))
                                .frame(width: 60, alignment: .top)
                        }
                    }
                    
                    ZStack(alignment: .center) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 72, height: 30)
                            .background(selectedThemeButton ? Color(hex: 0xFCFBF7) : Color(hex: 0xFF5733))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
                        
                        Button(action: {
                            selectedThemeButton = false
                        }) {
                            Text("나열 변경")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .bold(!selectedThemeButton)
                                .foregroundColor(selectedThemeButton ? Color(hex: 0x1E1E1E) : Color(hex: 0xFFFFFF))
                                .frame(width: 60, alignment: .top)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
                if selectedThemeButton {
                    TabView(selection: $currentColorPage) {
                        VStack {
                            Text("포스티 오렌지 (기본)\n")
                            
                            Image("PostieTheme_PostieOrange")
                                .resizable()
                                .modifier(CustomImageModifier())
                            
                            Spacer()
                        }
                        .tag(0)
                        
                        VStack {
                            Text("포스티 옐로우\n")
                            Image("PostieTheme_PostieYellow")
                                .resizable()
                                .modifier(CustomImageModifier())
                            
                            Spacer()
                        }
                        .tag(1)
                        
                        VStack {
                            Text("포스티 그린 \n")
                            
                            Image("PostieTheme_PostieGreen")
                                .resizable()
                                .modifier(CustomImageModifier())
                            
                            Spacer()
                        }
                        .tag(2)
                        
                        VStack {
                            Text("포스티 블루\n")
                            
                            Image("PostieTheme_PostieBlue")
                                .resizable()
                                .modifier(CustomImageModifier())
                            
                            Spacer()
                        }
                        .tag(3)
                        
                        VStack {
                            Text("포스티 블랙\n")
                            
                            Image("PostieTheme_PostieBlack")
                                .resizable()
                                .modifier(CustomImageModifier())
                            
                            Spacer()
                        }
                        .tag(4)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                } else {
                    TabView(selection: $currentGroupPage) {
                        VStack {
                            Text("편지 그룹\n")
                            
                            Image("PostieTheme_LetterGroup")
                                .resizable()
                                .modifier(CustomImageModifier())
                            
                            Spacer()
                        }
                        .tag(0)
                        
                        VStack {
                            Text("편지 리스트\n")
                            
                            Image("PostieTheme_LetterList")
                                .resizable()
                                .modifier(CustomImageModifier())
                            
                            Spacer()
                        }
                        .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
                
                Spacer()
            }
        }
        .navigationTitle("테마 설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: (
            Button(action: {
                currentColorPage = currentColorPage
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("완료")
            }
        ))
        .tint(Color(hex: 0x1E1E1E))
    }
}

struct CustomImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .frame(height: 550)
            .shadow(color: Color.black.opacity(0.1), radius: 3)
    }
}

#Preview {
    ThemeView()
}
