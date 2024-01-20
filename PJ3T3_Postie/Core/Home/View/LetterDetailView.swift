//
//  LetterDetailView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct LetterDetailView: View {
    var controllers: [UIHostingController<Page>]

    // TODO: 인풋 값, 편지 구조체로 변경 필요
    init(text: String) {
        controllers = text.chunks(size: 300).map { chunk in
            UIHostingController(rootView: Page(text: chunk))
        }
    }

    var body: some View {
        ZStack {
            Color(hex: 0xF5F1E8)
                .ignoresSafeArea()
            
            VStack {
                PageViewController(controllers: controllers)
                    .frame(height: 600)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
            }
            .padding()
        }
        .navigationTitle("편지 정보")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    // show delete alert
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LetterDetailView(text: Constants.textSample)
    }
}

// 샘플 데이터입니다.
struct Constants {
    static let textSample = "안녕? 잘지내? 한동안 따뜻 했다가 다시 추워졌네. 항상 감기 조심해... 이런 추운 겨울만 되면 항상 너가 생각나. 추운 겨울이 생각나지 않을 정도로 우리, 따뜻했잖아. 그런 겨울이 다시 올줄 알았는데 안타깝게도 그렇게 되진 못헀네. 너랑 헤어진 이후 내 머리속엔 항상 너로 가득했어. 돌이킬 수 없는 나의 실수에 자책을 너무 했어. 잊어보려 노력했지만, 시릴 정도로 추운 겨울이 너와 같이 찾아왔어. 처음이였어. 너도 처음이였고 이렇게 무언가에 빠진 나도 처음이야. 우리 다시 만나면 그 전 보다 더 잘될 수 있지 않을까...? 안녕? 잘지내? 한동안 따뜻 했다가 다시 추워졌네. 항상 감기 조심해... 이런 추운 겨울만 되면 항상 너가 생각나. 추운 겨울이 생각나지 않을 정도로 우리, 따뜻했잖아. 그런 겨울이 다시 올줄 알았는데 안타깝게도 그렇게 되진 못헀네. 너랑 헤어진 이후 내 머리속엔 항상 너로 가득했어. 돌이킬 수 없는 나의 실수에 자책을 너무 했어. 잊어보려 노력했지만, 시릴 정도로 추운 겨울이 너와 같이 찾아왔어. 처음이였어. 너도 처음이였고 이렇게 무언가에 빠진 나도 처음이야. 우리 다시 만나면 그 전 보다 더 잘될 수 있지 않을까...? 안녕? 잘지내? 한동안 따뜻 했다가 다시 추워졌네. 항상 감기 조심해... 이런 추운 겨울만 되면 항상 너가 생각나. 추운 겨울이 생각나지 않을 정도로 우리, 따뜻했잖아. 그런 겨울이 다시 올줄 알았는데 안타깝게도 그렇게 되진 못헀네. 너랑 헤어진 이후 내 머리속엔 항상 너로 가득했어. 돌이킬 수 없는 나의 실수에 자책을 너무 했어. 잊어보려 노력했지만, 시릴 정도로 추운 겨울이 너와 같이 찾아왔어. 처음이였어. 너도 처음이였고 이렇게 무언가에 빠진 나도 처음이야. 우리 다시 만나면 그 전 보다 더 잘될 수 있지 않을까...? "
}
