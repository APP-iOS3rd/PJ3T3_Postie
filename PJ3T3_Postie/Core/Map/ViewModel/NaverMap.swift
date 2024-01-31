//
//  NaverMap.swift
//  PJ3T3_Postie
//
//  Created by kwon ji won on 1/23/24.
//

import SwiftUI

import NMapsMap

struct NaverMap: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator.shared
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
}
