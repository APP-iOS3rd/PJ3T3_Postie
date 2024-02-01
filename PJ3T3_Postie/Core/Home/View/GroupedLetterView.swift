//
//  GroupedLetterView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/1/24.
//

import SwiftUI

struct GroupedLetterView: View {
    var letterReceivedGrouped: [String] = []
    var letterWritedGrouped: [String] = []
    var letterGrouped: [String] = []
    let letterCount: Int
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var authManager = AuthManager.shared
    
    var body: some View {
        // recipient 에서 중복 된것을 제외 후 letterReceivedGrouped 에 삽입
        let letterReceivedGrouped: [String] = Array(Set(firestoreManager.letters.map { $0.recipient }.filter { !$0.isEmpty }))
        // writer 에서 중복 된것을 제외 후 letterWritedGrouped 에 삽입
        let letterWritedGrouped: [String] = Array(Set(firestoreManager.letters.map { $0.writer }.filter { !$0.isEmpty }))
        // letterReceivedGrouped와 letterWritedGrouped를 합친 후 중복 제거
        let letterGrouped: [String] = Array(Set(letterReceivedGrouped + letterWritedGrouped))
        // 본인 이름 항목 제거
        // "me" << 추후에는 authManager.currentUser?.fullName 로 해야함
        let filteredLetterGrouped: [String] = letterGrouped.filter { $0 != "me" }
        
        ForEach(filteredLetterGrouped, id: \.self) { recipient in
            HStack {
                ZStack {
                    if letterCount > 2 {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color(hex: 0xFCFBF7))
                            .frame(width: 350, height: 130)
                            .offset(x: 10, y: 10)
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
                    }
                    
                    if letterCount > 1 {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color(hex: 0xFCFBF7))
                            .frame(width: 350, height: 130)
                            .offset(x: 5, y: 5)
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("From.")
                                    .font(.custom("SourceSerifPro-Black", size: 18))
                                    .foregroundColor(.black)
                                
                                Text("\(recipient)")
                                    .foregroundStyle(Color(hex: 0x1E1E1E))
                                
                                Spacer()
                                
                                Text(" ") // date
                                    .font(.custom("SourceSerifPro-Light", size: 18))
                                    .foregroundStyle(Color(hex: 0x1E1E1E))
                                
                                ZStack {
                                    Image(systemName: "water.waves")
                                        .font(.headline)
                                        .offset(x:18)
                                    
                                    Image(systemName: "sleep.circle")
                                        .font(.largeTitle)
                                }
                                .foregroundStyle(Color(hex: 0x979797))
                            }
                            
                            Spacer()
                            
                            Text("\"\"")
                        }
                    }
                    .padding()
                    .frame(width: 350, height: 130)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color(hex: 0xFCFBF7))
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
                    )
                }
                
                Spacer()
            }
        }
    }
}

//#Preview {
//    GroupedLetterView()
//}
