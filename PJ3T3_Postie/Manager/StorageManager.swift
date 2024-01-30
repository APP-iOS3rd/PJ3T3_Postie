//
//  StorageManager.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/22/24.
//

import UIKit

import FirebaseStorage

final class StorageManager: ObservableObject {
    static let shared = StorageManager()
    var userReference: StorageReference
    @Published var images: [LetterPhoto] = []
    
    private init() { 
        let userUid = AuthManager.shared.userUid
        self.userReference = Storage.storage().reference().child("users").child(userUid)
    }
    
    /**
     [UIImage]를 받아 반복문을 돌며 각 이미지들을 Data type으로 변환, saveImage 함수를 호출해 Storage에 이미지를 업로드하고
     업로드가 완료될 때 마다 업로드된 이미지의 urlString을 urlArray에 append한다.
     ### Notes ###
     - _이미지 업로드 실패 alert창 띄워주기_
     - Parameters:
       - images: Storage에 저장하고싶은 이미지들의 배열
       - userId: 현재 로그인중인 유저의 uuid로 이미지를 업로드 할 경로를 생성하거나 찾는데 사용한다.
       - docId: 방금 생성한 firestore문서 id로 이미지를 업로드 할 경로를 생성하거나 찾는데 사용한다.
     */
    func saveUIImage(images: [UIImage], docId: String) async throws {
        //metadata없이도 data를 업로드 할 수 있지만, 그 경우 서버는 어떤 타입의 데이터를 저장하는지 알지 못해 오류를 발생시킬 수 있으므로 upload하는 metadata 타입을 명시 해 주는 편이 좋다.
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        var currentImageNo = 1
        let totalImages = images.count
        
        for img in images {
            let imageName = "\(UUID().uuidString).jpeg"
            let fileReference = userReference.child(docId).child(imageName)
            
            print("업로드 시작 \(currentImageNo)/\(totalImages)")
            
            //compressionQuality: 1 => 100%를 의미해 압축 없음
            //이미지가 너무 클 경우 직접 compress하거나 firebase extension 중 resize images(유료)를 사용
            //이미지 타입이 png라면 data = image.png()
            guard let data = img.jpegData(compressionQuality: 1) else {
                throw URLError(.backgroundSessionWasDisconnected)
            }
            
            let returnedMetaData = try await fileReference.putDataAsync(data, metadata: meta)
            currentImageNo += 1
        }
        
        print("업로드 종료")
    }
    
    //Firebase의 listAll() 메서드를 사용하여 특정 경로에 포함된 모든 항목을 images 배열에 추가
    func listAllFile(docId: String) {
        //이미지 폴더의 모든 파일을 나열
        let folderRef = userReference.child(docId)
        
        folderRef.listAll { result, error in
            guard let result = result, error == nil else {
                print("Error while getting list of file: ", error ?? "Undefined error")
                return
            }
            
            //result.items == 지정한 경로에 포함된 모든 파일
            for item in result.items {
                item.getData(maxSize: 20 * 1024 * 1024) { data, error in
                    //UIImage타입으로 데이터를 저장 할 필요가 없다면 error 부분 제외하고 모두 삭제 필요
                    guard let data = data, let image = UIImage(data: data), error == nil else {
                        print("\(#function): \(error?.localizedDescription)")
                        return
                    }
                    
                    Task {
                        let absoluteString = try await item.downloadURL().absoluteString
                        
                        DispatchQueue.main.async {
                            self.images.append(LetterPhoto(id: item.name, fullPath: item.fullPath, urlString: absoluteString, image: image))
                        }
                    }
                }
            }
        }
    }
    
    func deleteItem(fullPath: String) {
        let item = Storage.storage().reference().child(fullPath)
        
        item.delete { error in
            guard error == nil else {
                print("Error deleting item.", error)
                return
            }
            
            for (index, item) in self.images.enumerated() where fullPath == item.fullPath {
                self.images.remove(at: index)
            }
        }
    }
}
