//
//  ClearBackground.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/14/24.
//

import SwiftUI

struct ClearBackground: UIViewRepresentable {
    public func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        
        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) { }
}
