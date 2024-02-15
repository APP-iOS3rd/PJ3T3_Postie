//
//  Color.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct ThemeData {
    let backGroundColor: Color
    let receivedLetterColor: Color
    let writenLetterColor: Color
    let profileColor: Color
    let tabBarTintColor: Color
    let tintColor: Color
    let dividerColor: Color
}

//struct ThemeManager {
//    static let themeColors = [
//        ThemeData(backGroundColor: .postieBeige, receivedLetterColor: .postieWhite, writenLetterColor: .postieLightGray, profileColor: .postieGray, tabBarTintColor: .postieBlack, tintColor: .postieOrange, dividerColor: .postieDarkGray),
//        ThemeData(backGroundColor: .postieRealWhite, receivedLetterColor: .postieWhite, writenLetterColor: .postieLightGray, profileColor: .postieGray, tabBarTintColor: .postieBlack, tintColor: .postieYellow, dividerColor: .postieDarkGray),
//        ThemeData(backGroundColor: .postieWhite, receivedLetterColor: .postieLightBeige, writenLetterColor: .postieRealWhite, profileColor: .postieGray, tabBarTintColor: .postieBlack, tintColor: .postieGreen, dividerColor: .postieDarkGray),
//        ThemeData(backGroundColor: .postieRealWhite, receivedLetterColor: .postieLightBlue, writenLetterColor: .postieLightYellow, profileColor: .postieGray, tabBarTintColor: .postieBlack, tintColor: .postieBlue, dividerColor: .postieDarkGray),
//        ThemeData(backGroundColor: .postieBlack, receivedLetterColor: .postieLightBlack, writenLetterColor: .postieSpaceGray, profileColor: .postieGray, tabBarTintColor: .postieLightGray, tintColor: .postieLightGray, dividerColor: Color(hex: 0xD5D5D5))
//    ]
//}

class ThemeManager {
    static let shared = ThemeManager()
    
    private let userDefaultsKey = "CurrentThemeIndex"
    private(set) var currentIndex: Int {
        didSet {
            UserDefaults.standard.set(currentIndex, forKey: userDefaultsKey)
        }
    }
    
    private init() {
        // UserDefaults에서 테마 인덱스 로드
        currentIndex = UserDefaults.standard.integer(forKey: userDefaultsKey)
    }
    
    static let themeColors = [
        ThemeData(backGroundColor: .postieBeige, receivedLetterColor: .postieWhite, writenLetterColor: .postieLightGray, profileColor: .postieGray, tabBarTintColor: .postieBlack, tintColor: .postieOrange, dividerColor: .postieDarkGray),
        ThemeData(backGroundColor: .postieRealWhite, receivedLetterColor: .postieWhite, writenLetterColor: .postieLightGray, profileColor: .postieGray, tabBarTintColor: .postieBlack, tintColor: .postieYellow, dividerColor: .postieDarkGray),
        ThemeData(backGroundColor: .postieWhite, receivedLetterColor: .postieLightBeige, writenLetterColor: .postieRealWhite, profileColor: .postieGray, tabBarTintColor: .postieBlack, tintColor: .postieGreen, dividerColor: .postieDarkGray),
        ThemeData(backGroundColor: .postieRealWhite, receivedLetterColor: .postieLightBlue, writenLetterColor: .postieLightYellow, profileColor: .postieGray, tabBarTintColor: .postieBlack, tintColor: .postieBlue, dividerColor: .postieDarkGray),
        ThemeData(backGroundColor: .postieBlack, receivedLetterColor: .postieLightBlack, writenLetterColor: .postieSpaceGray, profileColor: .postieGray, tabBarTintColor: .postieLightGray, tintColor: .postieLightGray, dividerColor: Color(hex: 0xD5D5D5))
    ]
    
    var currentTheme: ThemeData {
        return ThemeManager.themeColors[currentIndex]
    }
    
    func updateTheme(index: Int) {
        currentIndex = index
    }
}

var postieColors: ThemeData {
    ThemeManager.shared.currentTheme
}
