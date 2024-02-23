//
//  InformationView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/11/24.
//

import SwiftUI

struct InformationView: View {
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @State private var columns = Array(repeating: GridItem(.flexible(), spacing: 9), count: 2)
    
    var body: some View {
        var appVersion: String {
            if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
               let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
                return "\(version) (\(build))"
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
                    
                    LazyVGrid(columns: columns, spacing: 9) {
                        ForEach(0..<PersonData.count, id: \.self) { person in
                            PersonGridView(person: PersonData[person])
                        }
                    }
                    .padding(.leading, 2)
                    .padding(.trailing, 2)
                    .padding(.bottom)
                    
                    Text("도움주신 분들")
                        .foregroundStyle(postieColors.dividerColor)
                    
                    DividerView()
                        .padding(.bottom, 5)
                    
                    LazyVGrid(columns: columns, spacing: 9) {
                        ForEach(0..<ContributeData.count, id: \.self) { person in
                            PersonGridView(person: ContributeData[person])
                        }
                    }
                    .padding(.leading, 2)
                    .padding(.trailing, 2)
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

struct PersonGridView: View {
    var person: Person
    
    var body: some View {
        Link(destination: URL(string: person.link)!) {
            VStack {
                ZStack {
                    Rectangle()
                        .frame(height: 190)
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
                    
                    Text("""
                        이 약관은 팀포스티 (이하 "회사"라 함)이 운영하는 포스티 및 관련 서비스(이하 "서비스"라 함)의 이용 조건 및 절차, 이용자와 회사의 권리, 의무, 책임사항, 서비스 이용에 대한 기본적인 사항을 규정함을 목적으로 합니다.\n
                        """)
                        .font(.subheadline)
                    
                    Text("제2조 (정의)\n")
                        .bold()
                    
                    Text("""
                         이 약관에서 사용하는 용어의 정의는 다음과 같습니다.
                         1. "서비스"라 함은 회사가 모바일 기기를 통해 이용자에게 제공하는 포스티 관련 제반 서비스를 의미합니다.
                         2. "이용자"라 함은 회사의 "서비스"에 접속하여 이 약관에 따라 회사가 제공하는 "서비스"를 이용하는 모든 회원 및 비회원을 말합니다.
                         3. "회원"이라 함은 "서비스"에 회원등록을 한 자로서, 계속적으로 "회사"가 제공하는 "서비스"를 이용할 수 있는 자를 말합니다.\n
                         """)
                        .font(.subheadline)
                    
                    Text("제3조 (이용계약의 성립)\n")
                        .bold()
                    
                    Text("""
                        이용계약은 이용자가 약관의 내용에 대해 동의하고, 회사가 정한 절차에 따라 이용신청을 하며, 회사가 이를 승낙함으로써 체결됩니다.\n
                        """)
                        .font(.subheadline)
                    
                    Text("제4조 (서비스의 제공 및 변경)\n")
                        .bold()
                    
                    Text("""
                         회사는 다음과 같은 서비스를 제공합니다.
                         서비스의 구체적인 내용은 회사가 운영하는 앱 또는 웹사이트 등을 통해 이용자에게 공지합니다.
                         회사는 필요한 경우 서비스의 내용을 변경할 수 있으며, 이러한 변경 사항은 앱 내 또는 회사의 웹사이트를 통해 공지됩니다.\n
                         """)
                        .font(.subheadline)
                    
                    Text("제5조 (이용료 및 결제)\n")
                        .bold()
                    
                    Text("""
                         서비스의 이용료와 결제 방법, 환불 정책 등에 대한 사항은 회사가 별도로 정하는 바에 따릅니다.
                         유료 서비스 이용 시 이용자는 회사가 정한 결제 수단을 통해 이용료를 납부해야 합니다.\n
                         """)
                        .font(.subheadline)
                    
                    Text("제6조 (회원가입)\n")
                        .bold()
                    
                    Text("""
                         이용자는 회사가 정한 가입 양식에 따라 회원정보를 기입하고, 이 약관에 동의한다는 의사표시를 함으로써 회원가입을 신청할 수 있습니다.
                         회사는 이용자의 신청에 대해 서비스 이용을 승낙할 수 있습니다.\n
                         """)
                        .font(.subheadline)
                    
                    Text("제7조 (회원의 의무)\n")
                        .bold()
                    
                    Text("""
                        회원은 개인정보 변경 시 즉시 이를 업데이트하고, 서비스 이용과 관련하여 발생하는 모든 책임을 집니다.
                        또한, 회원은 이 약관 및 관련 법령을 준수해야 합니다.\n
                        """)
                        .font(.subheadline)
                    
                    Text("제8조 (회사의 의무)\n")
                        .bold()
                    
                    Text("""
                         회사는 안정적인 서비스 제공을 위해 노력하며, 회원의 개인정보를 보호하기 위해 관련 법령에 따라 적절한 조치를 취합니다.\n
                         """)
                    .font(.subheadline)
                    
                    Text("제9조 (서비스 이용 제한)\n")
                        .bold()
                    
                    Text("""
                        회사는 회원이 이 약관의 규정을 위반하거나 서비스의 정상적인 운영을 방해하는 경우, 서비스 이용을 제한하거나 회원 자격을 상실시킬 수 있습니다.\n
                        """)
                    .font(.subheadline)
                    
                    Text("제10조 (저작권 및 지적재산권)\n")
                        .bold()
                    
                    Text("""
                        서비스와 관련된 저작물 및 콘텐츠에 대한 저작권은 회사 또는 해당 저작권자에게 있습니다.
                        이용자는 서비스를 이용함으로써 얻은 정보를 회사의 사전 승인 없이 복제, 배포, 방송 등의 방법으로 사용할 수 없습니다.\n
                        """)
                    .font(.subheadline)
                    
                    Text("제11조 (면책사항)\n")
                        .bold()
                    
                    Text("회사는 천재지변, 전쟁, 서비스 이용자의 고의 또는 과실로 인한 서비스 장애 등 불가항력적 사유로 인해 서비스를 제공할 수 없는 경우에는 책임이 면제됩니다.\n")
                        .font(.subheadline)
                    
                    Text("제12조 (분쟁 해결)\n")
                        .bold()
                    
                    Text("""
                        서비스 이용과 관련하여 분쟁이 발생한 경우, 회사와 이용자는 상호 협의 하에 분쟁을 해결하기 위해 노력합니다.
                        협의 하에 해결되지 않는 경우, 관련 법령에 따른 절차를 통해 해결합니다.\n
                        """)
                    .font(.subheadline)
                    
                    Text("제13조 (약관의 변경)\n")
                        .bold()
                    
                    Text("""
                        회사는 필요한 경우 약관을 변경할 수 있으며, 변경된 약관은 지정된 방법으로 이용자에게 공지됩니다.
                        변경된 약관은 공지 후 일정 기간이 경과한 뒤에 효력이 발생합니다.\n
                        """)
                    .font(.subheadline)
                    
                    Text("제14조 (기타)\n")
                        .bold()
                    
                    Text("""
                        본 약관에 명시되지 않은 사항에 대해서는 관련 법령 또는 상관례에 따릅니다.\n
                        """)
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
                    Text("<Postie> 이하 '포스티'는 「개인정보 보호법」 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.\n")
                        .font(.subheadline)
                    
                    Text("제 1조 (개인정보의 처리 목적)\n")
                        .bold()
                    
                    Text("""
                        '포스티'는 다음의 목적을 위하여 개인정보를 처리합니다.
                        처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.
                        1. 재화 또는 서비스 제공\n콘텐츠 제공을 목적으로 개인정보를 처리합니다.\n
                        """)
                        .font(.subheadline)
                    
                    Text("제 2조 (개인정보의 처리 및 보유 기간)\n")
                        .bold()
                    
                    Text("""
                         ① '포스티'는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.
                         ② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.
                         • <재화 또는 서비스 제공>
                         • <재화 또는 서비스 제공>와 관련한 개인정보는 수집.이용에 관한 동의일로부터<지체없이 파기>까지 위 이용목적을 위하여 보유.이용됩니다.
                         • 보유근거 : 없음
                         • 관련법령 : 없음\n
                         """)
                        .font(.subheadline)
                    
                    Text("제 3조 (처리하는 개인정보의 항목)\n")
                        .bold()
                    
                    Text("""
                        ① 포스티는 다음의 개인정보 항목을 처리하고 있습니다.
                        • < 재화 또는 서비스 제공 >
                        • 필수항목 : 접속 Device Token\n
                        """)
                        .font(.subheadline)
                    
                    Text("제 4조 (개인정보의 파기절차 및 파기방법)\n")
                        .bold()
                    
                    Text("""
                         ① 포스티는 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.
                         ② 정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다.
                         1. 법령 근거 :
                         2. 보존하는 개인정보 항목 : 계좌정보, 거래날짜
                         ③ 개인정보 파기의 절차 및 방법은 다음과 같습니다.
                         1. 파기절차 포스티는 파기 사유가 발생한 개인정보를 선정하고, 포스티의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.\n
                         """)
                        .font(.subheadline)
                    
                    Text("제 5조 (정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항)\n")
                        .bold()
                    
                    Text("""
                         ① 정보주체는 포스티에 대해 언제든지 개인정보 열람·정정·삭제·처리정지 요구 등의 권리를 행사할 수 있습니다.
                         ② 제1항에 따른 권리 행사는PohangFamily에 대해 「개인정보 보호법」 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 포스티는 이에 대해 지체 없이 조치하겠습니다.
                         ③ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다.이 경우 “개인정보 처리 방법에 관한 고시(제2020-7호)” 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.
                         ④ 개인정보 열람 및 처리정지 요구는 「개인정보 보호법」 제35조 제4항, 제37조 제2항에 의하여 정보주체의 권리가 제한 될 수 있습니다.
                         ⑤ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.
                         ⑥ 포스티는 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.\n
                         """)
                        .font(.subheadline)
                    
                    Text("제 6조 (개인정보의 안전성 확보조치에 관한 사항)\n")
                        .bold()
                    
                    Text("""
                         포스티는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.
                         1. 개인정보에 대한 접근 제한개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.\n
                         """)
                        .font(.subheadline)
                    
                    Text("제 7조 (개인정보를 자동으로 수집하는 장치의 설치·운영 및 그 거부에 관한 사항)\n")
                        .bold()
                    
                    Text("포스티는 정보주체의 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용하지 않습니다.\n")
                        .font(.subheadline)
                    
                    Text("제8조 (개인정보 보호책임자에 관한 사항)\n")
                        .bold()
                    
                    Text("""
                         ① 포스티는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.
                         • ▶ 개인정보 보호책임자
                         • 성명 : 정은수
                         • 직책 : 개발자
                         • 직급 : 공동대표
                         • 연락처 : 01049286958, team.postie@gmail.com ※ 개인정보 보호 담당부서로 연결됩니다.
                         ② 정보주체께서는 포스티 의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 포스티는 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.\n
                         """)
                    .font(.subheadline)
                    
                    Text("제 9조 (개인정보의 열람청구를 접수·처리하는 부서)\n")
                        .bold()
                    
                    Text("""
                        정보주체는 ｢개인정보 보호법｣ 제35조에 따른 개인정보의 열람 청구를 아래의 부서에 할 수 있습니다.
                        포스티는 정보주체의 개인정보 열람청구가 신속하게 처리되도록 노력하겠습니다.\n
                        """)
                    .font(.subheadline)
                    
                    Text("제 10조 (정보주체의 권익침해에 대한 구제방법)\n")
                        .bold()
                    
                    Text("""
                        정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다.
                        이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.
                        1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)
                        2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)
                        3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr)
                        4. 경찰청 : (국번없이) 182 (ecrm.cyber.go.kr)
                        「개인정보보호법」제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제),
                        제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대 하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.
                        ※ 행정심판에 대해 자세한 사항은 중앙행정심판위원회(www.simpan.go.kr) 홈페이지를 참고하시기 바랍니다.\n
                        """)
                    
                    Text("제 11조 (개인정보 처리방침 변경)")
                        .bold()
                    
                    Text("이 개인정보처리방침은 2022년 8월 12부터 적용됩니다.")
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
