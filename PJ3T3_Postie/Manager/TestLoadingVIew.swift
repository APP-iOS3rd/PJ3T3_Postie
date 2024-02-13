//
//  TestLoadingVIew.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/14/24.
//

import SwiftUI

struct TestLoadingVIew: View {
    @ObservedObject private var counter = Counter(interval: 1)
    let images: [Image] = [Image("postyReceiving"), Image("postyReceivingBeige"), Image("postyReceivingOrange")]
    var text: String
    @Binding var isThemeGroupButton: Int
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        ZStack {
            Rectangle()
                .background(.ultraThinMaterial)
                .opacity(0.7)
                .ignoresSafeArea()
            
            postieColors.backGroundColor
                .ignoresSafeArea()
                .opacity(0.5)
            
            
            VStack {
                images[counter.value % images.count]
                    .resizable()
                    .frame(width: 150, height: 150)
                
                Text(text)
                    .font(.system(size: 15))
                    .foregroundStyle(postieColors.dividerColor)
            }
        }
    }
}

#Preview {
    TestLoadingVIew(text: "프리뷰", isThemeGroupButton: .constant(0))
}

private class Counter: ObservableObject {
    private var timer: Timer?

    @Published var value: Int = 0
    
    init(interval: Double) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in self.value += 1 }
    }
}
