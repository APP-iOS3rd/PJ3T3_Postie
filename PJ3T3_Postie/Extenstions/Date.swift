//
//  Date.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 1/24/24.
//

import Foundation

extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    static var nowInKorea: Date {
        let nowUTC = Date()
        guard let koreaTimeZone = TimeZone(identifier: "Asia/Seoul") else {
            return nowUTC // 한국 시간대를 가져오지 못한 경우 현재 UTC 시간을 반환
        }
        let timeOffset = koreaTimeZone.secondsFromGMT(for: nowUTC)
        return Date(timeInterval: TimeInterval(timeOffset), since: nowUTC)
    }
}

func dateAtNineAM(from date: Date) -> Date {
    let calendar = Calendar.current
    var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
    dateComponents.hour = 18 // Date()가 현재 국가 시간 기준 아니였나요??? 대.충.격. 런던 시간 기준으로 +18을 해야 한국 오전 9시가 되네요;
    dateComponents.minute = 0
    dateComponents.second = 0
    return calendar.date(from: dateComponents) ?? date
}
