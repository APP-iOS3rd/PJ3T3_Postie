//
//  TestLoadingView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/14/24.
//

import SwiftUI

struct LoadingView: View {
    @ObservedObject private var counter = Counter(interval: 1)
    let profileImages = ["postySmileSketch", "postySmileLine", "postySmileLineColor", "postyThinkingSketch", "postyThinkingLine", "postyThinkingLineColor", "postySendingSketch", "postySendingLine", "postySendingLineColor", "postyReceivingSketch", "postyReceivingLine", "postyReceivingLineColor", "postyHeartSketch", "postyHeartLine", "postyHeartLineColor", "postyTrumpetSketch", "postyTrumpetLine", "postyTrumpetLineColor", "postyQuestionSketch", "postyQuestionLine", "postyQuestionLineColor", "postyNormalSketch", "postyNormalLine", "postyNormalLineColor", "postyWinkSketch", "postyWinkLine", "postyWinkLineColor", "postySleepingSketch", "postySleepingLine", "postySleepingLineColor", "postyNotGoodSketch", "postyNotGoodLine", "postyNotGoodLineColor"].shuffled()
    let sketchPostys = ["postySmileSketch", "postyThinkingSketch", "postySendingSketch", "postyReceivingSketch", "postyHeartSketch", "postyTrumpetSketch", "postyQuestionSketch", "postyNormalSketch", "postyWinkSketch", "postyWinkSketch", "postySleepingSketch", "postyNotGoodSketch"].shuffled()
    var text: String
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
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
                Image("\(sketchPostys[counter.value % sketchPostys.count])")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 20)
                
                Text(text)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(postieColors.dividerColor)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    LoadingView(text: "프리뷰에 로딩이 표시되고 있어요\n공백 미포함 15자 초과시 줄 바꾸기")
}

class Counter: ObservableObject {
    private var timer: Timer?

    @Published var value: Int = 0
    
    init(interval: Double) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in self.value += 1 }
    }
}
