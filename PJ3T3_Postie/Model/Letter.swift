//
//  Letter.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import Foundation
import UIKit

import FirebaseFirestore

struct Letter: Codable, Hashable, Identifiable {
    var id: String
    var writer: String
    var recipient: String
    var summary: String
    var date: Date
    var text: String
    let isReceived: Bool
    var isFavorite: Bool
    var images: [UIImage]?

    init(id: String,
         writer: String,
         recipient: String,
         summary: String,
         date: Date,
         text: String,
         isReceived: Bool,
         isFavorite: Bool,
         images: [UIImage]? = nil)
    {
        self.id = id
        self.writer = writer
        self.recipient = recipient
        self.summary = summary
        self.date = date
        self.text = text
        self.isReceived = isReceived
        self.isFavorite = isFavorite
        self.images = images
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case writer = "writer"
        case recipient = "recipient"
        case summary = "summary"
        case date = "date"
        case text = "text"
        case isReceived = "isReceived"
        case isFavorite = "isFavorite"
        case images = "images"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.writer = try container.decode(String.self, forKey: .writer)
        self.recipient = try container.decode(String.self, forKey: .recipient)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.date = try container.decode(Date.self, forKey: .date)
        self.text = try container.decode(String.self, forKey: .text)
        self.isReceived = try container.decode(Bool.self, forKey: .isReceived)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        let imageDataArray = try container.decode([Data].self, forKey: .images)
        self.images = imageDataArray.compactMap({ data in
            UIImage(data: data)
        })
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.writer, forKey: .writer)
        try container.encode(self.recipient, forKey: .recipient)
        try container.encode(self.summary, forKey: .summary)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.text, forKey: .text)
        try container.encode(self.isReceived, forKey: .isReceived)
        try container.encode(self.isFavorite, forKey: .isFavorite)
        if let jpegDataArray = self.images?.compactMap({ image in
            image.jpegData(compressionQuality: 1)
        }) {
            try container.encode(jpegDataArray, forKey: .images)
        }
    }

    static var preview: Letter {
        return Letter(
            id: UUID().uuidString,
            writer: "최웅",
            recipient: "국연수",
            summary: "너랑 헤어진 이후 내 머리속엔 항상 너로 가득했어.",
            date: Date(),
            text: "안녕? 잘지내? 한동안 따뜻 했다가 다시 추워졌네. 항상 감기 조심해... 이런 추운 겨울만 되면 항상 너가 생각나. 추운 겨울이 생각나지 않을 정도로 우리, 따뜻했잖아. 그런 겨울이 다시 올줄 알았는데 안타깝게도 그렇게 되진 못헀네. 너랑 헤어진 이후 내 머리속엔 항상 너로 가득했어. 돌이킬 수 없는 나의 실수에 자책을 너무 했어. 잊어보려 노력했지만, 시릴 정도로 추운 겨울이 너와 같이 찾아왔어. 처음이였어. 너도 처음이였고 이렇게 무언가에 빠진 나도 처음이야. 우리 다시 만나면 그 전 보다 더 잘될 수 있지 않을까...? 안녕? 잘지내? 한동안 따뜻 했다가 다시 추워졌네. 항상 감기 조심해... 이런 추운 겨울만 되면 항상 너가 생각나. 추운 겨울이 생각나지 않을 정도로 우리, 따뜻했잖아. 그런 겨울이 다시 올줄 알았는데 안타깝게도 그렇게 되진 못헀네. 너랑 헤어진 이후 내 머리속엔 항상 너로 가득했어. 돌이킬 수 없는 나의 실수에 자책을 너무 했어. 잊어보려 노력했지만, 시릴 정도로 추운 겨울이 너와 같이 찾아왔어. 처음이였어. 너도 처음이였고 이렇게 무언가에 빠진 나도 처음이야. 우리 다시 만나면 그 전 보다 더 잘될 수 있지 않을까...? 안녕? 잘지내? 한동안 따뜻 했다가 다시 추워졌네. 항상 감기 조심해... 이런 추운 겨울만 되면 항상 너가 생각나. 추운 겨울이 생각나지 않을 정도로 우리, 따뜻했잖아. 그런 겨울이 다시 올줄 알았는데 안타깝게도 그렇게 되진 못헀네. 너랑 헤어진 이후 내 머리속엔 항상 너로 가득했어. 돌이킬 수 없는 나의 실수에 자책을 너무 했어. 잊어보려 노력했지만, 시릴 정도로 추운 겨울이 너와 같이 찾아왔어. 처음이였어. 너도 처음이였고 이렇게 무언가에 빠진 나도 처음이야. 우리 다시 만나면 그 전 보다 더 잘될 수 있지 않을까...?",
            isReceived: true,
            isFavorite: false,
            images: [
                UIImage(systemName: "heart.square.fill")!,
                UIImage(systemName: "envelope.fill")!,
                UIImage(systemName: "folder.fill")!
            ]
        )
    }
}
