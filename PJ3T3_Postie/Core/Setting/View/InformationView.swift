//
//  InformationView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/11/24.
//

import SwiftUI

struct InformationView: View {
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @State private var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
    
    var body: some View {
        var appVersion: String {
            if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
               let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
                return "\(version)"
            }
            return "버전 정보 없음"
        }
        
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("앱 정보")
                        .foregroundStyle(postieColors.dividerColor)
                    
                    DividerView()
                        .padding(.bottom, 5)
                    
                    HStack {
                        Text("버전정보")
                            .foregroundStyle(postieColors.tabBarTintColor)
                        
                        Spacer()
                        
                        Text(appVersion)
                            .foregroundStyle(postieColors.dividerColor)
                    }
                    .padding(.bottom)
                    
                    Text("법률 조항")
                        .foregroundStyle(postieColors.dividerColor)
                    
                    DividerView()
                        .padding(.bottom, 5)
                    
                    NavigationLink(destination: TermOfUserView()) {
                        HStack {
                            Text("이용약관")
                                .foregroundStyle(postieColors.tabBarTintColor)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(postieColors.dividerColor)
                        }
                        .padding(.bottom)
                    }
                    
                    NavigationLink(destination: PrivacyView()) {
                        HStack {
                            Text("개인정보 처리방침")
                                .foregroundStyle(postieColors.tabBarTintColor)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(postieColors.dividerColor)
                        }
                        .padding(.bottom)
                    }
                    
                    Text("함께하신 분들")
                        .foregroundStyle(postieColors.dividerColor)
                    
                    DividerView()
                        .padding(.bottom, 5)
                    
                    LazyVGrid(columns: columns, spacing: 15){
                        ForEach(0..<PersonData.count, id: \.self) { person in
                            PersonGridView(person: PersonData[person])
                        }
                    }
                    .padding(.bottom)
                    
                    Text("도움주신 분들")
                        .foregroundStyle(postieColors.dividerColor)
                    
                    DividerView()
                        .padding(.bottom, 5)
                    
                    LazyVGrid(columns: columns, spacing: 15){
                        ForEach(0..<ContributeData.count, id: \.self) { person in
                            PersonGridView(person: ContributeData[person])
                        }
                    }
                    .padding(.bottom)
                }
            }
            .padding(.leading)
            .padding(.trailing)
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("앱 정보")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
        }
        .toolbarBackground(postieColors.backGroundColor, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Person: Identifiable {
    var id = UUID()
    var name: String
    var subtitle: String
    var image: String
    var color: Color
    var link: String
}

var PersonData: [Person] = [
    Person(name: "UnKi", subtitle: "iOS Developer", image: "postyWinkLineColor", color: .postieBlue, link: "https://github.com/qlrmr111"),
    Person(name: "JiWon", subtitle: "iOS Developer", image: "postyTrumpetLineColor", color: .postieOrange, link: "https://github.com/wonny1012"),
    Person(name: "HyeonJin", subtitle: "iOS Developer", image: "postySmileLineColor", color: .postieYellow, link: "https://github.com/hjsupernova"),
    Person(name: "JooWon", subtitle: "iOS Developer", image: "postySleepingLineColor", color: Color(hex: 0xED3025), link: "https://github.com/lm-loki"),
    Person(name: "EunSu", subtitle: "iOS Developer", image: "postyReceivingLineColor", color: .postieGreen, link: "https://github.com/Eunice0927")
]

var ContributeData: [Person] = [
    Person(name: "Ohtt", subtitle: "iOS Developer", image: "postyHeartLineColor", color: Color(hex: 0xFF8599), link: "https://github.com/ohtt-iOS")
]

struct PersonGridView: View {
    
    var person: Person
    
    var body: some View {
        Link(destination: URL(string: person.link)!) {
            VStack {
                ZStack {
                    Rectangle()
                        .frame(width: 170,height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .foregroundStyle(person.color)
                        .shadow(color: .black, radius: 0.8)
                    
                    VStack {
                        Text(person.name)
                            .bold()
                        
                        Text(person.subtitle)
                            .font(.footnote)
                        
                        Image(person.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        
                    }
                    .foregroundStyle(.postieWhite)
                }
            }
        }
    }
}

struct TermOfUserView: View {
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    var body: some View {
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("제1조 (목적)\n")
                        .bold()
                    
                    Text("본 약관은 포스티(이하 \"회사\"라 합니다)가 제공하는 모든 서비스(이하 \"서비스\"라 합니다)의 이용조건 및 절차, 이용자와 회사의 권리, 의무, 책임사항, 서비스 이용에 대한 기타 필요한 사항을 규정함을 목적으로 합니다.\n")
                        .font(.subheadline)
                    
                    Text("제2조 (정의)\n")
                        .bold()
                    
                    Text("본 약관에서 사용하는 용어의 정의는 다음과 같습니다.")
                    
                    Text("1. \"이용자\"란 본 약관에 따라 회사가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.\n2. \"회원\"이란 회사에 개인정보를 제공하여 회원등록을 한 자로서, 회사의 정보를 지속적으로 제공받으며, 회사가 제공하는 서비스를 계속적으로 이용할 수 있는 자를 말합니다.\n3. \"비회원\"이란 회원에 가입하지 않고 회사가 제공하는 서비스를 이용하는 자를 말합니다.\n")
                        .font(.subheadline)
                    
                    Text("제3조 (약관의 게시와 개정)\n")
                        .bold()
                    
                    Text("회사는 본 약관의 내용을 이용자가 쉽게 알 수 있도록 서비스 초기 화면에 게시합니다.\n회사는 약관의 규제에 관한 법률, 전자상거래 등에서의 소비자보호에 관한 법률, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 등 관련 법률을 위배하지 않는 범위에서 본 약관을 개정할 수 있습니다.\n회사가 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현재의 약관과 함께 그 적용일자 7일 전부터 적용일자 전일까지 공지합니다.\n")
                        .font(.subheadline)
                    
                    Text("제4조 (서비스의 제공 및 변경)")
                        .bold()
                    
                    Text("1. 회사는 다음과 같은 업무를 수행합니다.\n • 서비스에 대한 정보 제공 및 계약의 체결\n • 기타 회사가 정하는 업무\n2. 회사는 서비스의 내용, 이용방법, 이용시간을 사전에 공지하고 변경할 수 있습니다.\n")
                    
                    Text("제5조 (서비스의 중단)\n")
                        .bold()
                    
                    Text("회사는 컴퓨터 등 정보통신설비의 보수점검·교체 및 고장, 통신의 두절 등의 사유가 발생한 경우 서비스의 제공을 일시적으로 중단할 수 있습니다.\n회사는 제1항의 사유로 서비스 제공이 일시적으로 중단됨으로 인하여 이용자 또는 제3자가 입은 손해에 대하여 배상합니다. 단, 회사가 고의 또는 과실이 없음을 입증하는 경우에는 그러하지 아니합니다.\n")
                        .font(.subheadline)
                    
                    Text("제6조 (회원가입)\n")
                        .bold()
                    
                    Text("1. 회원은 회사에 언제든지 탈퇴를 요청할 수 있으며, 회사는 즉시 회원탈퇴를 처리합니다.\n2. 회원이 다음 각 호의 사유에 해당하는 경우, 회사는 회원자격을 제한 및 정지시킬 수 있습니다.\n • 가입 신청 시에 허위 내용을 등록한 경우\n • 회사를 이용하여 구입한 재화·용역 등의 대금, 기타 회사 이용에 관련하여 회원이 부담하는 채무를 기일에 지급하지 않는 경우\n • 다른 사람의 서비스 이용을 방해하거나 그 정보를 도용하는 등 전자상거래 질서를 위협하는 경우\n • 서비스를 이용하여 법령 및 본 약관이 금지하거나 공공질서와 미풍양속에 반하는 행위를 하는 경우\n")
                        .font(.subheadline)
                    
                    Text("제7조 (회원 탈퇴 및 자격 상실 등)\n")
                        .bold()
                    
                    Text("1. 회원은 회사에 언제든지 탈퇴를 요청할 수 있으며, 회사는 즉시 회원탈퇴를 처리합니다.\n2. 회원이 다음 각 호의 사유에 해당하는 경우, 회사는 회원자격을 제한 및 정지시킬 수 있습니다.\n • 가입 신청 시에 허위 내용을 등록한 경우\n • 회사를 이용하여 구입한 재화·용역 등의 대금, 기타 회사 이용에 관련하여 회원이 부담하는 채무를 기일에 지급하지 않는 경우\n • 다른 사람의 서비스 이용을 방해하거나 그 정보를 도용하는 등 전자상거래 질서를 위협하는 경우\n • 서비스를 이용하여 법령 및 본 약관이 금지하거나 공공질서와 미풍양속에 반하는 행위를 하는 경우")
                        .font(.subheadline)
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("이용약관")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
        }
        .toolbarBackground(postieColors.backGroundColor, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacyView: View {
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    var body: some View {
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("1. 개인정보의 처리 목적\n")
                        .bold()
                    
                    Text("포스티(이하 '회사')는 다음의 목적을 위해 개인정보를 처리합니다. 처리한 개인정보는 다음의 목적 이외의 용도로는 사용되지 않으며, 이용 목적이 변경될 시에는 사전 동의를 구할 예정입니다.")
                        .font(.subheadline)
                    
                    Text(" • 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산\n • 회원 관리, 개인 맞춤 서비스 제공 등\n")
                        .font(.subheadline)
                    
                    Text("2. 개인정보의 처리 및 보유 기간\n")
                        .bold()
                    
                    Text("① 회사는 법령에 따른 개인정보 보유·이용 기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용 기간 내에서 개인정보를 처리, 보유합니다.\n② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.\n • 계약 또는 청약철회 등에 관한 기록: 5년\n")
                        .font(.subheadline)
                    
                    Text("3. 개인정보의 제3자 제공에 관한 사항\n")
                        .bold()
                    
                    Text("회사는 정보주체의 개인정보를 원칙적으로 외부에 제공하지 않습니다. 다만, 아래의 경우에는 예외로 합니다.\n • 정보주체들의 사전 동의가 있는 경우\n • 법률의 특별한 규정이 있는 경우\n")
                        .font(.subheadline)
                    
                    Text("4. 개인정보처리 위탁에 관한 사항\n")
                        .bold()
                    
                    Text("회사는 서비스 향상을 위해서 아래와 같이 개인정보 처리업무를 위탁할 수 있습니다.\n • 위탁 받는 자 (수탁자) : [수탁자명]\n • 위탁하는 업무의 내용 : [업무 내용]\n")
                        .font(.subheadline)
                    
                    Text("5. 정보주체의 권리·의무 및 그 행사방법\n")
                        .bold()
                    
                    Text("이용자는 개인정보주체로서 다음과 같은 권리를 행사할 수 있습니다.\n • 개인정보 열람 요구\n • 오류 등이 있을 경우 정정 요구\n • 삭제 요구\n • 처리 정지 요구\n")
                        .font(.subheadline)
                    
                    Text("6. 개인정보의 안전성 확보 조치\n")
                        .bold()
                    
                    Text("회사는 개인정보보호법 제29조에 따라 다음과 같은 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다.\n • 개인정보의 암호화\n • 접근 권한의 관리\n • 보안 프로그램 설치 및 주기적 갱신, 점검\n")
                        .font(.subheadline)
                    
                    Text("7. 개인정보 보호책임자\n")
                        .bold()
                    
                    Text("회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.\n • 이름: 홍길동\n • 직책: 마케팅 팀장\n • 연락처: 010-1234-5678\n")
                        .font(.subheadline)
                    
                    Text("8. 변경사항 통지의 의무\n")
                        .bold()
                    
                    Text("본 개인정보 처리방침은 법률, 정책 또는 보안기술의 변경에 따라 내용의 추가, 삭제 및 수정이 있을 시에는 변경사항의 시행일의 최소 7일 전부터 회사의 웹사이트에 공지할 것입니다.")
                        .font(.subheadline)
                    
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("개인정보 처리방침")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
        }
        .toolbarBackground(postieColors.backGroundColor, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    InformationView()
//}
