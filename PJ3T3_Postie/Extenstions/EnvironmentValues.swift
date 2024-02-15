//
//  EnvironmentValues.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/13/24.
//

import SwiftUI

extension EnvironmentValues {
    var window: UIWindow? {
        get {
            return self[WindowKey.self].value
        }
        set {
            self[WindowKey.self] = .init(value: newValue)
        }
    }
}

struct WindowKey: EnvironmentKey {
    struct Value {
        weak var value: UIWindow?
    }
    
    static let defaultValue: Value = .init(value: nil)
}
