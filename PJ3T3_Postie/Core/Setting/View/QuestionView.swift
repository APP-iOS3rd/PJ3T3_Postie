//
//  QuestionView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/11/24.
//

import SwiftUI

struct QuestionView: View {
    @Environment(\.openURL) var openURL
    
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @State private var isExpanded = false
    
    var body: some View {
        let questions = [
            Question(title: "이 앱은 뭔가요?", content: "'포스티'라는 앱은, 그동안 주고 받았던 편지를 간편하게 휴대폰으로 저장해서 언제 어디서나 확인할수 있는 앱이에요!\n편지를 오래 주고 받다보면, 받은 편지들을 관리하기 힘들어지고 가끔 잃어버리는경우도 있죠. 그리고 보냈던 편지를 보관할 방법도 딱히 없고요.\n\n이럴 때 '포스티'를 사용해보세요!\n보낸 편지든, 받았던 편지든, 하나의 앱에 저장 해서 언제 어디서나 확인 할 수 있답니다!\n지금 당장 홈 화면에서 주고 받았던 편지를 저장해보세요!"),
            Question(title: "편지 저장이 안돼요.", content: "'포스티' 앱은 모든 편지를 외부 클라우드에 저장하고, 불러오는 방식으로 편지들을 보여줘요.\n혹시나 스마트폰의 네트워크 상태가 좋은지 확인해보시고, 네트워크 상태가 좋은데도 저장이 안되면 현재 화면 하단의 '문의하기'를 통해 현재 상태를 포함해서 상세하게 문의 해주시면 빠른 시일내에 답변드릴게요!"),
            Question(title: "실수로 편지를 삭제했어요. 복구 가능 한가요?", content: "매우 안타깝지만, 아직까지는 삭제된 편지를 복구하는 기능은 없어요...ㅠㅠ\n또한, 회원 탈퇴시에도 저장된 편지가 전부 삭제되고 복구가 불가능하니 편지 삭제와 회원탈퇴 할때는 많은 고민 후에 결정하시길 바랍니다!"),
            Question(title: "나의 느린 우체통이 뭔가요?", content: "나의 느린 우체통이란 특정 시간을 설정해서 설정한 기간이 전부 지나기 전까지 열어보지 못하는, 일명 타임캡슐 기능이에요!\n\n한번쯤은 '미래의 나'가 무엇을 하고 있을지? 힘들어 하고 있진 않을지? 고민 하셨던적이 있나요?\n타임 캡슐처럼 '미래의 나'에게 편지를 보내고 싶었어도, 막상 편지지도 없고 연필로 적을 시간도 마땅히 남지 않아 번번히 실패 하셨던 경우도 있을거에요.\n\n이럴때 '나의 느린 우체통' 기능을 사용해보세요!\n나의 느린 우체통은 종이로 편지를 적지 않아도 앱 내에서 타이핑으로 글을 적어서 보관 할 수 있답니다!\n지금 바로 홈 화면의 플로팅 버튼으로 나의 느린 우체통을 경험해보세요!"),
            Question(title: "우체국, 우체통의 영업 시간이 궁금해요.", content: "우체국의 운영 및 이용시간은 공휴일을 제외한 평일 09:00 ~ 18:00으로 전국 어디서나 같아요.\n우체통은 365일 접수 가능하나, 우편물 수거는 공휴일을 제외한 평일에만 수거해요. 우체통의 우편물 수거 시간은 각 우체통 마다 달라, 우체통에 적힌 시간을 확인해야해요.\n\n더 자세한 사항은 인터넷 사이트 우정사업본부 > 사업분야 > 이용시간 에서 확인할 수 있답니다!")
        ]
        
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("자주묻는 질문")
                        .font(.footnote)
                        .foregroundStyle(postieColors.dividerColor)
                    
                    DividerView()
                        .padding(.bottom)
                    
                    ForEach(questions, id: \.id) { questions in
                        DisclosureGroup {
                            ZStack {
                                postieColors.receivedLetterColor
                                    .ignoresSafeArea()
                                
                                VStack(alignment: .leading) {
                                    Text("안녕하세요 포스티팀입니다.\n")
                                        .font(.callout)
                                    
                                    Text("\(questions.content)\n")
                                        .font(.callout)
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Text("From. ")
                                            .font(.custom("SourceSerifPro-Black", size: 16))
                                        + Text("포스티팀")
                                            .font(.callout)
                                    }
                                }
                                .padding()
                            }
                        } label: {
                            VStack(alignment: .leading) {
                                Text("Q ")
                                    .bold()
                                    .foregroundColor(postieColors.tintColor)
                                + Text(questions.title)
                            }
                        }
                        .padding(.bottom)
                        
                        DividerView()
                            .padding(.bottom)
                    }
                    
                    Text("도움말을 통해 문제를 해결하지 못했나요?")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    Button(action: {
                                let email = "postie@gmail.com"
                                let subject = "문의하기"
                                let body = ""
                                if let url = URL(string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
                                    openURL(url)
                                }
                    }) {
                        HStack {
                            Image(systemName: "square.and.pencil.circle")
                                .font(.title)
                            
                            VStack (alignment: .leading) {
                                HStack {
                                    Text("문의하기")
                                        .font(.callout)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.subheadline)
                                        .foregroundStyle(postieColors.dividerColor)
                                    
                                    Spacer()
                                }
                                
                                Text("다른 질문이나 건의사항등을 메일로 답변 받을 수 있어요.")
                                    .foregroundStyle(postieColors.dividerColor)
                                    .font(.caption)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundStyle(postieColors.receivedLetterColor)
                        )
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("문의하기")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
        }
        .toolbarBackground(postieColors.backGroundColor, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Question {
    var id = UUID()
    var title: String
    var content: String
}

//#Preview {
//    QuestionView()
//}
