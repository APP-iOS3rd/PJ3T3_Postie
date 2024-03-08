//
//  Letter.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import Foundation
import UIKit

struct Letter: Codable, Hashable, Identifiable {
    var id: String
    var writer: String
    var recipient: String
    var summary: String
    var date: Date
    var text: String
    let isReceived: Bool
    var isFavorite: Bool
    var imageURLs: [String]?
    var imageFullPaths: [String]?

    static var preview: Letter {
        return Letter(
            id: UUID().uuidString,
            writer: "최웅",
            recipient: "국연수",
            summary: "너랑 헤어진 이후 내 머리속엔 항상 너로 가득했어.",
            date: Date(),
            text: "안녕? 잘지내? 한동안 따뜻 했다가 다시 추워졌네. 항상 감기 조심해... 이런 추운 겨울만 되면 항상 너가 생각나. 추운 겨울이 생각나지 않을 정도로 우리, 따뜻했잖아. 그런 겨울이 다시 올줄 알았는데 안타깝게도 그렇게 되진 못헀네. 너랑 헤어진 이후 내 머리속엔 항상 너로 가득했어. 돌이킬 수 없는 나의 실수에 자책을 너무 했어. 잊어보려 노력했지만, 시릴 정도로 추운 겨울이 너와 같이 찾아왔어. 처음이였어. 너도 처음이였고 이렇게 무언가에 빠진 나도 처음이야. 우리 다시 만나면 그 전 보다 더 잘될 수 있지 않을까...? 안녕? 잘지내? 한동안 따뜻 했다가 다시 추워졌네. 항상 감기 조심해... 이런 추운 겨울만 되면 항상 너가 생각나. 추운 겨울이 생각나지 않을 정도로 우리, 따뜻했잖아. 그런 겨울이 다시 올줄 알았는데 안타깝게도 그렇게 되진 못헀네. 너랑 헤어진 이후 내 머리속엔 항상 너로 가득했어. 돌이킬 수 없는 나의 실수에 자책을 너무 했어. 잊어보려 노력했지만, 시릴 정도로 추운 겨울이 너와 같이 찾아왔어. 처음이였어. 너도 처음이였고 이렇게 무언가에 빠진 나도 처음이야. 우리 다시 만나면 그 전 보다 더 잘될 수 있지 않을까...? 안녕? 잘지내? 한동안 따뜻 했다가 다시 추워졌네. 항상 감기 조심해... 이런 추운 겨울만 되면 항상 너가 생각나. 추운 겨울이 생각나지 않을 정도로 우리, 따뜻했잖아. 그런 겨울이 다시 올줄 알았는데 안타깝게도 그렇게 되진 못헀네. 너랑 헤어진 이후 내 머리속엔 항상 너로 가득했어. 돌이킬 수 없는 나의 실수에 자책을 너무 했어. 잊어보려 노력했지만, 시릴 정도로 추운 겨울이 너와 같이 찾아왔어. 처음이였어. 너도 처음이였고 이렇게 무언가에 빠진 나도 처음이야. 우리 다시 만나면 그 전 보다 더 잘될 수 있지 않을까...?",
            isReceived: true,
            isFavorite: false
        )
    }
}
