//
//  ContenViewModel.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/6/24.
//

import SwiftUI
import Foundation

class AppViewModel: ObservableObject {
    @Published var isLoading = false
    
    init() {
        // 데이터 로딩 또는 초기화 작업을 여기서 수행
        // 데이터 로딩 또는 초기화에 2초 소요
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = true
        }
    }
}

struct TabItemContent: View {
    let image: String
    let text: String
    
    var body: some View {
        Group {
            Image(systemName: image)
            
            Text(text)
        }
    }
}

class TabSelection: ObservableObject {
    @Published var selectedTab: Int = 0 {
        didSet {
            if selectedTab == oldValue {
                resetViewAction()
            }
        }
    }
    
    var resetViewAction: () -> Void = {}
}
