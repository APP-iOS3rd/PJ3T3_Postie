//
//  MembershipView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/7/24.
//

import SwiftUI

struct MembershipView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isMembershipPage = 1
    @State private var isMembershipForYear = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.postieBeige
                .ignoresSafeArea()
            
            ScrollView {
                HStack {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                    }
                    .padding()
                }
                
                VStack {
                    Text("Postie")
                        .font(.custom("SourceSerifPro-Black", size: 30))
                        .foregroundStyle(Color.postieOrange)
                    + Text("의 Premium회원이 되어")
                        .font(.custom("SourceSerifPro-Black", size: 23))
                    
                    Text("아래의 혜택을 만나보세요!")
                        .font(.custom("SourceSerifPro-Black", size: 23))
                    
                    TabView(selection: $isMembershipPage) {
                        Text("광고 제거")
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 180)
                                    .frame(width: 300)
                                    .foregroundStyle(Color.postieWhite)
                            )
                            .tag(1)
                        
                        Text("사진 저장 가능 갯수 확장")
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 180)
                                    .frame(width: 300)
                                    .foregroundStyle(Color.postieWhite)
                            )
                            .tag(2)
                        
                        Text("닉네임 변경 무료 (월 1회)")
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 180)
                                    .frame(width: 300)
                                    .foregroundStyle(Color.postieWhite)
                            )
                            .tag(3)
                        
                        Text("포스티 프리미엄 혜택은 \n점점 더 늘어갈거에요!")
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 180)
                                    .frame(width: 300)
                                    .foregroundStyle(Color.postieWhite)
                            )
                            .tag(4)
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
                                .foregroundStyle(Color.postieWhite)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(isMembershipForYear ? Color.postieOrange : Color.postieOrange.opacity(0), lineWidth: 1)
                                    )
                            
                            HStack {
                                Text("연간 회원권")
                                
                                Spacer()
                                
                                VStack {
                                    Text("₩ 18,000")
                                    
                                    Text("월 ₩ 1,500")
                                }
                            }
                            .foregroundStyle(Color.black)
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
                                .foregroundStyle(Color.postieWhite)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(isMembershipForYear ? Color.postieOrange.opacity(0) : Color.postieOrange, lineWidth: 1)
                                    )
                            
                            HStack {
                                Text("월간 회원권")
                                
                                Spacer()
                                
                                Text("₩ 2,000")
                            }
                            .foregroundStyle(Color.black)
                            .padding()
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("언제든 Appstore에서 구독 해지 가능합니다.")
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
                        .foregroundStyle(Color.postieOrange)
                    
                    VStack {
                        Text(isMembershipForYear ? "연간 회원권 시작하기" : "월간 회원권 시작하기")
                            .bold()
                        
                        Text("무료 체험 1개월 제공")
                    }
                    .foregroundStyle(Color.white)
                    .padding()
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Text("완료")
                }
            }
        }
    }
}

#Preview {
    MembershipView()
}
