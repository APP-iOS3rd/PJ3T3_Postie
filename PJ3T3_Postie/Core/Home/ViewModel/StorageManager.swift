//
//  StorageManager.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/22/24.
//

import Foundation
import FirebaseStorage

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
}
