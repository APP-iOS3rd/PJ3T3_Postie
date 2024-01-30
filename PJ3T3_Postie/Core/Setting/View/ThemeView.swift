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
                        Image("PostieTheme_PostieOrange")
                            .resizable()
                            .modifier(CustomImageModifier())
                            .tag(0)
                        
                        Image("PostieTheme_PostieYellow")
                            .resizable()
                            .modifier(CustomImageModifier())
                            .tag(1)
                        
                        Image("PostieTheme_PostieGreen")
                            .resizable()
                            .modifier(CustomImageModifier())
                            .tag(2)
                        
                        Image("PostieTheme_PostieBlue")
                            .resizable()
                            .modifier(CustomImageModifier())
                            .tag(3)
                        
                        Image("PostieTheme_PostieBlack")
                            .resizable()
                            .modifier(CustomImageModifier())
                            .tag(4)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                } else {
                    TabView(selection: $currentGroupPage) {
                        Image("PostieTheme_LetterGroup")
                            .resizable()
                            .modifier(CustomImageModifier())
                            .tag(0)
                        
                        Image("PostieTheme_LetterList")
                            .resizable()
                            .modifier(CustomImageModifier())
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
            .padding()
            .shadow(color: Color.black.opacity(0.1), radius: 3)
    }
}

#Preview {
    ThemeView()
}
