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

private let themeColors = [
    ThemeData(backGroundColor: .blue, receivedLetterColor: .green, writenLetterColor: .white, profileColor: .black, tabBarTintColor: .black, tintColor: .black, dividerColor:. black),
    ThemeData(backGroundColor: .blue, receivedLetterColor: .green, writenLetterColor: .white, profileColor: .black, tabBarTintColor: .black, tintColor: .black, dividerColor:. black),
    ThemeData(backGroundColor: .blue, receivedLetterColor: .green, writenLetterColor: .white, profileColor: .black, tabBarTintColor: .black, tintColor: .black, dividerColor:. black),
    ThemeData(backGroundColor: .blue, receivedLetterColor: .green, writenLetterColor: .white, profileColor: .black, tabBarTintColor: .black, tintColor: .black, dividerColor:. black),
    ThemeData(backGroundColor: .blue, receivedLetterColor: .green, writenLetterColor: .white, profileColor: .black, tabBarTintColor: .black, tintColor: .black, dividerColor:. black)
    ]


struct ThemeData {
    let backGroundColor: Color
    let receivedLetterColor: Color
    let writenLetterColor: Color
    let profileColor: Color
    let tabBarTintColor: Color
    let tintColor: Color
    let dividerColor: Color
}
