//
//  Font.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/02/04.
//

import SwiftUI

extension Font {
    enum ViewFont {
        case sourceSerifProBlack
        case sourceSerifProLight

        var value: String {
            switch self {
            case .sourceSerifProBlack:
                return "SourceSerifPro-Black"
            case .sourceSerifProLight:
                return "SourceSerifPro-Light"
            }
        }
    }

    /// 뷰에서 사용하는 폰트를 가져옵니다.
    /// - Parameters:
    ///   - type: 뷰 폰트의 종류를 선택합니다.
    ///   - size: 폰트의 사이즈를 설정합니다. ( 기본 16 ).
    /// - Returns: 선택한 폰트와 사이즈를 적용해 폰트를 반환합니다.
    ///
    /// **[사용법]**
    /// ```swift
    /// Text("예시 입니다")
    ///     .font(.view(.sourceSerifProBlack))
    /// ```
    static func view(_ type: ViewFont, size: CGFloat = 16) -> Font {
        return .custom(type.value, size: size)
    }

    enum LetterFont {
        case nanumMyeongjo
        case nanumMyeongjoBold

        var value: String {
            switch self {
            case .nanumMyeongjo:
                return "NanumMyeongjoOTF"
            case .nanumMyeongjoBold:
                return "NanumMyeongjoOTFBold"
            }
        }
    }

    /// 편지에서 사용하는 폰트를 가져옵니다.
    /// - Parameters:
    ///   - type: 편지 폰트 종류를 선택합니다.
    ///   - size: 폰트의 사이즈를 설정합니다. ( 기본 16 ).
    /// - Returns: 선택한 폰트와 사이즈를 적용해 폰트를 반환합니다.
    ///
    /// **[사용법]**
    /// ```swift
    /// Text("예시 입니다")
    ///     .font(.letter(.nanumMyeongjo))
    /// ```
    static func letter(_ type: LetterFont, size: CGFloat = 16) -> Font {
        return .custom(type.value, size: size)
    }
}
