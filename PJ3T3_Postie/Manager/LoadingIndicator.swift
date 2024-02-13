//
//  LoadingIndicator.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/13/24.
//

import Foundation
import UIKit
import SwiftUI

class LoadingIndicator {
    var uiView: UIView?
    
    private func makeUIView(text: String, isThemeGroupButton: Binding<Int>) {
        guard let uiView = LoadingHostingController(rootView: TestLoadingVIew(text: text, isThemeGroupButton: isThemeGroupButton)).view else {
            print(#function, "Cannot change TestLoadingView to UIView")
            return
        }
        
        self.uiView = uiView
    }
    
    static func showLoading(text: String, isThemeGroupButton: Binding<Int>) {
        DispatchQueue.main.async {
            // 최상단에 있는 window 객체 획득
            let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let window = windowScenes?.windows.last else {
                print(#function, "Cannot find window")
                return
            }
            
            let blurEffect = UIBlurEffect(style: .regular)
            let blurView = UIVisualEffectView(effect: blurEffect)
            
//            blurView.frame = window.frame
            window.addSubview(blurView)

            guard let loadingView = LoadingHostingController(rootView: TestLoadingVIew(text: text, isThemeGroupButton: isThemeGroupButton)).view else {
                print(#function, "Cannot change TestLoadingView to UIView")
                return
            }
            
            loadingView.center = window.center
            window.addSubview(loadingView)
        }
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let window = windowScenes?.windows.last else {
                print(#function, "Cannot find window")
                return
            }
            
            window.subviews.filter({ $0 is UIVisualEffectView }).forEach { $0.removeFromSuperview() }
        }
    }
}

final class LoadingHostingController: UIHostingController<TestLoadingVIew> { }
