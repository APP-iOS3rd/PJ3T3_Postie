//
//  ThemeView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 1/30/24.
//

import SwiftUI

struct ThemeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedThemeButton: Int = 1
    
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
                            .background(Color(red: 1, green: 0.98, blue: 0.95))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
                        
                        Button(action: {
                            selectedThemeButton = 1
                        }) {
                            Text("테마 설정")
                                .font(Font.custom("SF Pro Text", size: 12))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.12, green: 0.12, blue: 0.12))
                                .frame(width: 60, alignment: .top)
                        }
                    }
                    
                    ZStack(alignment: .center) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 72, height: 30)
                            .background(Color(red: 1, green: 0.98, blue: 0.95))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
                        
                        Button(action: {
                            selectedThemeButton = 2
                        }) {
                            Text("나열 변경")
                                .font(Font.custom("SF Pro Text", size: 12))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.12, green: 0.12, blue: 0.12))
                                .frame(width: 60, alignment: .top)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
                if selectedThemeButton == 1 {
                    Text("테마 설정")
                } else {
                    Text("나열 변경")
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

#Preview {
    ThemeView()
}
