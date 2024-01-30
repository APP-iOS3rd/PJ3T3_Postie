//
//  ThemeView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 1/30/24.
//

import SwiftUI

struct ThemeView<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedThemeButton: Bool = true
    private let postieGroupTheme = ["PostieTheme_LetterGroup", "PostieTheme_LetterList"]
    private let postieColorTheme = ["PostieTheme_PostieOrange", "PostieTheme_PostieYellow", "PostieTheme_PostieGreen", "PostieTheme_PostieBlue"]
    @State private var currentColorIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    
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
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(postieColorTheme, id: \.self) { theme in
                                Image(theme)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 550)
                                    .padding()
                                    .shadow(color: .black.opacity(0.1), radius: 3)
                            }
                        }
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(postieGroupTheme, id: \.self) { theme in
                                Image(theme)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 550)
                                    .padding()
                                    .shadow(color: .black.opacity(0.1), radius: 3)
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .navigationTitle("테마 설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: (
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("완료")
                }
            ))
        .tint(Color(hex: 0x1E1E1E))
    }
}

//#Preview {
//    ThemeView()
//}
