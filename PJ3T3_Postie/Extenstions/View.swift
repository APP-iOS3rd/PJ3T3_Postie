//
//  View.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/8/24.
//

import SwiftUI

extension View {
    func customOnChange<V>(_ value: V, action: @escaping (_ newValue: V) -> Void) -> some View where V: Equatable {
        modifier(CustomOnChange(value: value, action: action))
    }
}

struct CustomOnChange<V: Equatable>: ViewModifier {
    let value: V
    let action: (_ newValue: V) -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            content
                .onChange(of: value) { oldValue, newValue in
                    action(newValue)
                }
        } else {
            content
                .onChange(of: value, perform: action)
        }
    }
}
