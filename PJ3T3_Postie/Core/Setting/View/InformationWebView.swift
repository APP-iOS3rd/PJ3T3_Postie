//
//  InformationWebView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/24/24.
//

import SwiftUI
import WebKit

struct InformationWebView: UIViewRepresentable {
    var urlToLoad: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: urlToLoad) else{
            return WKWebView()
        }
        
        let webview = WKWebView() //웹뷰 인스턴스 생성
        
        webview.load(URLRequest(url: url)) //웹뷰 로드
        
        return webview
    }
    
    //uiview 업데이트: context는 uiviewrepresentablecontext로 감싸야 함.
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<InformationWebView>) {
        
    }
}

//#Preview {
//    InformationWebView()
//}
