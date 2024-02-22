//
//  SettingViewModel.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import Foundation
import SwiftUI

struct Person: Identifiable {
    var id = UUID()
    var name: String
    var subtitle: String
    var image: String
    var color: Color
    var link: String
}

var PersonData: [Person] = [
    Person(name: "UnKi", subtitle: "iOS Developer", image: "postyWinkLineColor", color: .postieBlue, link: "https://github.com/qlrmr111"),
    Person(name: "JiWon", subtitle: "iOS Developer", image: "postyTrumpetLineColor", color: .postieOrange, link: "https://github.com/wonny1012"),
    Person(name: "HyeonJin", subtitle: "iOS Developer", image: "postySmileLineColor", color: .postieYellow, link: "https://github.com/hjsupernova"),
    Person(name: "JooWon", subtitle: "iOS Developer", image: "postySleepingLineColor", color: Color(hex: 0xED3025), link: "https://github.com/lm-loki"),
    Person(name: "EunSu", subtitle: "iOS Developer", image: "postyReceivingLineColor", color: .postieGreen, link: "https://github.com/Eunice0927")
]

var ContributeData: [Person] = [
    Person(name: "Ohtt", subtitle: "iOS Developer", image: "postyHeartLineColor", color: Color(hex: 0xFF8599), link: "https://github.com/ohtt-iOS")
]
