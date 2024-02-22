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
    @State private var isTappable: Bool = false
    @State private var showSuccessAlert = false
    @State private var showFailureAlert = false
    @State private var isReAuthing = false
    @State private var isDialogPresented = false
    @State private var showLoading = false
    @State private var loadingText = ""
    @State private var failureAlertMessage = ""
    @FocusState private var focusField: String?
    
    var body: some View {
        
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
                    
                    TextField("사용할 닉네임을 입력 해 주세요", text: $nickname)
                        .focused($focusField, equals: "nickname")
                        .autocorrectionDisabled()
                        .foregroundStyle(postieColors.dividerColor)
                        .disabled(isReAuthing)
                        .overlay(
                            HStack {
                                Spacer()
                                if !nickname.isEmpty {
                                    Button{
                                        nickname = ""
                                    } label: {
                                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.postieGray)
                                    }
                                    .padding(.trailing, 5)
                                }
                            }
                        )
                    
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
                    guard authManager.authDataResult != nil else {
                        hideKeyboard()
                        isReAuthing = true
                        isDialogPresented = true
                        return
                    }
                    
                    showSuccessAlert = true
                } label: {
                    if isReAuthing {
                        ProgressView()
                            .foregroundColor(postieColors.writenLetterColor)
                            .frame(height: 54)
                            .frame(maxWidth: .infinity)
                    } else {
                        HStack {
                            Image(systemName: "envelope")
                                .padding(.horizontal, 10)
                            
                            Text("포스티 시작하기")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(postieColors.writenLetterColor)
                        .frame(height: 54)
                        .frame(maxWidth: .infinity)
                    }
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
                .alert("닉네임 설정", isPresented: $showSuccessAlert) {
                    Button("취소", role: .cancel) {
                        isReAuthing = false
                        isTappable = true
                    }
                    
                    Button("좋아요") {
                        Task {
                            guard let authDataResult = authManager.authDataResult else {
                                isDialogPresented = true
                                isReAuthing = true
                                return
                            }
                            
                            loadingText = "포스티에 오신 것을 환영합니다!"
                            showLoading = true
                            try await authManager.createUser(authDataResult: authDataResult, nickname: nickname)
                        }
                    }
                } message: {
                    Text(#"한 번 설정한 닉네임은 변경할 수 없으니 신중하게 선택해주세요! \#n "\#(nickname)"으로 시작하시겠습니까?"#)
                }
                .alert("인증 실패", isPresented: $showFailureAlert) {
                    Button(role: .cancel) {
                        isReAuthing = false
                        isTappable = true
                    } label: {
                        Text("확인")
                    }
                } message: {
                    Text(failureAlertMessage)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 100)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .confirmationDialog("계정 정보를 가져오는데 실패했습니다.", isPresented: $isDialogPresented, titleVisibility: .visible) {
            ReAuthButtonView(showFailureAlert: $showFailureAlert, showSuccessAlert: $showSuccessAlert, alertBody: $failureAlertMessage)
        } message: {
            Text("계정 생성을 위해 재인증이 필요합니다. 재인증이 완료 되면 버튼을 다시 한 번 눌러주세요.")
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
