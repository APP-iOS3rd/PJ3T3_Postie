//
//  String.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/18.
//

import Foundation

extension String {
    /// 문자열을 특정 문자 수 단위로 잘라서 문자열 배열을 반환합니다.
    /// - Parameter size: 문자열을 나눌 문자 개수
    /// - Returns: 문자열을 나눈 것을 담은 배열
    func chunks(size: Int) -> [String] {
        return stride(from: 0, to: count, by: size).map { index in
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: size, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[startIndex..<endIndex])
        }
    }
}
