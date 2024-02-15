//
//  NicknameView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/2/24.
//

import SwiftUI

struct NicknameView: View {
    @ObservedObject var authManager = AuthManager.shared
    @State var nickname: String = ""
    @State var isTappable: Bool = false
    @State var isTapped: Bool = false
    @FocusState private var focusField: String?
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        ZStack {
            Color(.postieBeige)
                .ignoresSafeArea()
            
            VStack {
                Image("postyReceivingLine")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 100)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Nickname")
                        .foregroundStyle(postieColors.tintColor)
                        .fontWeight(.semibold)
                        .font(.footnote)
                    
                    TextField("앱에서 사용할 닉네임을 입력 해 주세요", text: $nickname)
                        .focused($focusField, equals: "nickname")
                        .autocorrectionDisabled()
                    
                    Divider()
                }
                .onAppear {
                    focusField = "nickname"
                }
                
                Button {
                    isTappable = false
                    isTapped = true
                    Task {
                        if let authDataResult = authManager.authDataResult {
                            try await authManager.createUser(authDataResult: authDataResult, nickname: nickname)
                        }
                    }
                } label: {
                    HStack() {
                        if isTapped {
                            LoadingView(text: "포스티 만나러 가는 중")
                        } else {
                            Image(systemName: "envelope")
                                .padding(.horizontal, 10)
                            
                            Text("포스티 시작하기")
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                    .foregroundColor(postieColors.writenLetterColor)
                    .frame(height: 54)
                    .frame(maxWidth: .infinity)
                }
                .background(isTappable ? postieColors.tintColor : postieColors.profileColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 3, x: 3, y: 3)
                .padding(.bottom, 10)
                .disabled(!isTappable)
                .onChange(of: nickname) { newValue in
                    if !newValue.isEmpty {
                        isTappable = true
                    } else {
                        isTappable = false
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 100)
            
            VStack {
                Spacer()
                
                Button {
                    authManager.signOut()
                } label: {
                    Text("Back to Login Selection")
                }
            }
        }
    }
}

#Preview {
    NicknameView()
}
