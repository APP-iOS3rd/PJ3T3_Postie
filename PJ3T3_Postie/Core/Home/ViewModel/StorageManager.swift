//
//  StorageManager.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/22/24.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    static let shared = StorageManager()
    private let storage = Storage.storage().reference() //db의 root reference location
    private init() { }
    
    private func userReference(userId: String) -> StorageReference {
        //이미지를 추가할 때 storage에 users 폴더 > 폴더 내부에 해당 유저의 uuid를 이름으로 가지는 폴더를 함께 생성
        //폴더 depth에 letters의 documentId도 가지도록 리팩토링 예정
        storage.child("users").child(userId)
    }
    
    func saveImage(data: Data, userId: String) async throws -> (path: String, name: String) {
        //metadata없이도 data를 업로드 할 수 있지만, 그 경우 서버는 어떤 타입의 데이터를 저장하는지 알지 못해 오류를 발생시킬 수 있으므로 upload하는 metadata 타입을 명시 해 주는 편이 좋다.
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let imageName = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await userReference(userId: userId).child(imageName).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        
        return (returnedPath, returnedName)
    }
    
    //UIImage 타입을 받아 저장할 수 있다. 사용하지 않아 삭제 할 경우 UIKit import도 함께 삭제한다.
    func saveImage(image: UIImage, userId: String) async throws -> (path: String, name: String) {
        //compressionQuality: 1 => 100%를 의미해 압축 없음
        //이미지가 너무 클 경우 직접 compress하거나 firebase extension 중 resize images(유료)를 사용해보자.
        //이미지 타입이 png라면 data = image.png()
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        
        return try await saveImage(data: data, userId: userId)
    }
}
