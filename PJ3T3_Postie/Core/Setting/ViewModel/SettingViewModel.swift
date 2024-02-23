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
}

var PersonData: [Person] = [
    Person(name: "UnKi", subtitle: "iOS Developer", image: "postyWinkLineColor", color: .postieBlue),
    Person(name: "JiWon", subtitle: "iOS Developer", image: "postyTrumpetLineColor", color: .postieOrange),
    Person(name: "HyeonJin", subtitle: "iOS Developer", image: "postySmileLineColor", color: .postieYellow),
    Person(name: "JooWon", subtitle: "iOS Developer", image: "postySleepingLineColor", color: Color(hex: 0xED3025)),
    Person(name: "EunSu", subtitle: "iOS Developer", image: "postyReceivingLineColor", color: .postieGreen)
]

var ContributeData: [Person] = [
    Person(name: "Ohtt", subtitle: "iOS Developer", image: "postyHeartLineColor", color: Color(hex: 0xFF8599)),
    Person(name: "Tuna", subtitle: "Designer", image: "postySendingLineColor", color: Color(hex: 0xED3025)),
    Person(name: "Junyoung", subtitle: "Developer", image: "postyThinkingLineColor", color: .postieYellow)
]
