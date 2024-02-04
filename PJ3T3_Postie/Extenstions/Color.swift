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

struct ThemeManager {
    static let themeColors = [
        ThemeData(backGroundColor: Color.postieBeige, receivedLetterColor: Color.postieWhite, writenLetterColor: Color.postieLightGray, profileColor: Color.postieGray, tabBarTintColor: Color.postieBlack, tintColor: Color.postieOrange, dividerColor: Color.postieDarkGray),
        ThemeData(backGroundColor: Color.postieRealWhite, receivedLetterColor: Color.postieWhite, writenLetterColor: Color.postieLightGray, profileColor: Color.postieGray, tabBarTintColor: Color.postieBlack, tintColor: Color.postieYellow, dividerColor: Color.postieDarkGray),
        ThemeData(backGroundColor: Color.postieWhite, receivedLetterColor: Color.postieLightBeige, writenLetterColor: Color.postieRealWhite, profileColor: Color.postieGray, tabBarTintColor: Color.postieBlack, tintColor: Color.postieGreen, dividerColor: Color.postieDarkGray),
        ThemeData(backGroundColor: Color.postieRealWhite, receivedLetterColor: Color.postieLightBlue, writenLetterColor: Color.postieLightYellow, profileColor: Color.postieGray, tabBarTintColor: Color.postieBlack, tintColor: Color.postieBlue, dividerColor: Color.postieDarkGray),
        ThemeData(backGroundColor: Color.postieBlack, receivedLetterColor: Color.postieLightBlack, writenLetterColor: Color.postieSpaceGray, profileColor: Color.postieGray, tabBarTintColor: Color.postieLightGray, tintColor: Color.postieLightGray, dividerColor: Color.postieLightGray)
    ]
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
