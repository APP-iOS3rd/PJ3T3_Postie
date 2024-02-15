//
//  GroupedLetterViewModel.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/15/24.
//

import Foundation

class GroupedLetterViewModel: ObservableObject {
    // 숫자, 한글, 알파벳 순서대로 정렬
    func customSort(recipients: [String]) -> [String] {
        return recipients.sorted { (lhs: String, rhs: String) -> Bool in
            func isKoreanConsonant(_ string: String) -> Bool {
                for scalar in string.unicodeScalars {
                    if scalar.value >= 0x3131 && scalar.value <= 0x314E {
                        return true
                    }
                }
                
                return false
            }
            
            func isKoreanSyllable(_ string: String) -> Bool {
                for scalar in string.unicodeScalars {
                    if scalar.value >= 0xAC00 && scalar.value <= 0xD7A3 {
                        return true
                    }
                }
                
                return false
            }
            
            // 우선순위 -> 숫자: 0, 한글 초성: 1, 한글 음절: 2, 그 외: 3
            let lhsPriority = isKoreanConsonant(lhs) ? 1 : isKoreanSyllable(lhs) ? 2 : 3
            let rhsPriority = isKoreanConsonant(rhs) ? 1 : isKoreanSyllable(rhs) ? 2 : 3
            
            if lhsPriority == rhsPriority {
                if lhsPriority == 1 || lhsPriority == 2 {
                    return lhs < rhs
                } else {
                    return lhs.lowercased() < rhs.lowercased()
                }
            } else {
                return lhsPriority < rhsPriority
            }
        }
    }
}
