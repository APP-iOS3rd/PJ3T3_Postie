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
    @State private var showAlert = false
    @State private var isDialogPresented = false
    @State private var showLoading = false
    @State private var dialogTitle = ""
    @State private var dialogMessage = ""
    @State private var loadingText = ""
    @FocusState private var focusField: String?
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        ZStack {
            postieColors.backGroundColor
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
                    
                    if nickname.isEmpty {
                        HStack {
                            Text("닉네임을 입력 해 주세요.")
                            
                            Spacer()
                            
                            Text("\(nickname.count) / 12")
                        }
                        .foregroundStyle(postieColors.tintColor)
                        .font(.system(size: 12))
                        .padding(.bottom, 20)
                    } else if nickname.count > 12 {
                        HStack {
                            Text("닉네임은 최대 12자까지 설정할 수 있습니다.")
                            
                            Spacer()
                            
                            Text("\(nickname.count) / 12")
                        }
                        .foregroundStyle(postieColors.tintColor)
                        .font(.system(size: 12))
                        .padding(.bottom, 20)
                    } else {
                        HStack {
                            Text("사용 가능한 닉네임입니다.")
                            
                            Spacer()
                            
                            Text("\(nickname.count) / 12")
                        }
                        .foregroundStyle(postieColors.tintColor)
                        .font(.system(size: 12))
                        .padding(.bottom, 20)
                    }
                }
                .onAppear {
                    focusField = "nickname"
                }
                
                Button {
                    isTappable = false
                    showAlert = true
                } label: {
                    HStack() {
                        Image(systemName: "envelope")
                            .padding(.horizontal, 10)
                        
                        Text("포스티 시작하기")
                            .font(.system(size: 18, weight: .semibold))
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
                    if !newValue.isEmpty && newValue.count < 13 {
                        isTappable = true
                    } else {
                        isTappable = false
                    }
                }
                .alert(isPresented: $showAlert) {
                    let title = Text("닉네임 설정")
                    let message = Text(#"한 번 설정한 닉네임은 변경할 수 없으니 신중하게 선택해주세요! \#n "\#(nickname)"으로 시작하시겠습니까?"#)
                    let cancelButton = Alert.Button.destructive(Text("취소")) {
                        isTappable = true
                    }
                    let confirmButton = Alert.Button.default(Text("좋아요")) {
                        Task {
                            guard let authDataResult = authManager.authDataResult else {
                                dialogTitle = "계정 정보를 가져오는데 실패했습니다."
                                dialogMessage = "재인증을 통해 로그인 정보를 삭제한 다음 다시 회원가입 해 주세요."
                                loadingText = "계정을 안전하게 삭제하는 중이에요"
                                isDialogPresented = true
                                nickname = ""
                                return
                            }
                            
                            loadingText = "포스티에 오신 것을 환영합니다!"
                            showLoading = true
                            try await authManager.createUser(authDataResult: authDataResult, nickname: nickname)
                        }
                    }
                    
                    return Alert(title: title, message: message, primaryButton: cancelButton, secondaryButton: confirmButton)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 100)
            
            VStack {
                Spacer()
                
                Button {
                    dialogTitle = "이미 존재하는 계정입니다."
                    dialogMessage = "계정 삭제를 위해서는 재인증을 통해 다시 로그인 해야 합니다."
                    loadingText = "계정을 안전하게 삭제하는 중이에요"
                    isDialogPresented = true
                } label: {
                    Text("Back to Login Selection")
                        .foregroundStyle(postieColors.tintColor)
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .confirmationDialog(dialogTitle, isPresented: $isDialogPresented, titleVisibility: .visible) {
            DeleteAccountButtonView(showLoading: $showLoading)
        } message: {
            Text(dialogMessage)
                .multilineTextAlignment(.center)
        }
        .fullScreenCover(isPresented: $showLoading) {
            LoadingView(text: loadingText)
                .background(ClearBackground())
        }
    }
}

#Preview {
    NicknameView()
}
