//
//  SettingViewModel.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
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
