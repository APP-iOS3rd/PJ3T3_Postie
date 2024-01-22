//
//  MapView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ZStack(alignment: .center) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 72, height: 30)
                        .background(Color(red: 1, green: 0.98, blue: 0.95))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
                    Button(action: {
                        
                    }) {
                        Text("우체국")
                            .font(Font.custom("SF Pro Text", size: 12))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.12, green: 0.12, blue: 0.12))
                            .frame(width: 60, alignment: .top)
                    }
                }
                
                ZStack(alignment: .center) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 72, height: 30)
                        .background(Color(red: 1, green: 0.98, blue: 0.95))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
                    Button(action: {
                
                    }) {
                        Text("우체통")
                            .font(Font.custom("SF Pro Text", size: 12))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.12, green: 0.12, blue: 0.12))
                            .frame(width: 60, alignment: .top)
                    }
                }
                Spacer()
            }
            .padding()
            
        }
    }
}

#Preview {
    MapView()
}
