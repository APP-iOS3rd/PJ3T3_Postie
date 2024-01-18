//
//  HomeView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        VStack {
                            
                        }
                    }
                }
            }
        }
    }
}

func receiveLetterView(sender: String, date: String, receiver: String, isToggleOn: Bool) -> some View {
    HStack {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 35)
                        .overlay(
                            Text("보내는 사람")
                                .foregroundStyle(Color(hex: 0x1e1e1e))
                        )
                        .foregroundStyle(Color(hex: 0x979797))
                    
                    Text("\(sender)")
                        .foregroundStyle(Color(hex: 0x1e1e1e))
                    
                    Spacer()
                    
                    Image(systemName: "swift")
                        .font(.title)
                        .foregroundStyle(Color(hex: 0x1e1e1e))
                }
                
                Text(" ")
                
                HStack {
                    VStack (alignment: .leading) {
                        Text(date)
                            .foregroundStyle(Color(hex: 0x1e1e1e))
                    }
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 90, height: 35)
                        .overlay(
                            Text("받는 사람")
                                .foregroundColor(.black)
                        )
                        .foregroundStyle(Color(hex: 0x979797))
                    
                    Text("\(receiver)")
                        .foregroundStyle(Color(hex: 0x1e1e1e))
                }
            }
        }
        .padding()
        .frame(width: 300)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(hex: 0xD1CEC7))
        )
        Spacer()
    }
}

func sendLetterView(sender: String, date: String, receiver: String, isToggleOn: Bool) -> some View {
    HStack {
        Spacer()
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 35)
                        .overlay(
                            Text("보내는 사람")
                                .foregroundColor(.black)
                        )
                        .foregroundStyle(Color(hex: 0x979797))
                    
                    Text("\(sender)")
                        .foregroundStyle(Color(hex: 0x1e1e1e))
                    
                    Spacer()
                    
                    Image(systemName: "swift")
                        .foregroundStyle(Color(hex: 0x1e1e1e))
                        .font(.title)
                }
                
                Text(" ")
                
                HStack {
                    VStack (alignment: .leading) {
                        Text(date)
                    }
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 90, height: 35)
                        .overlay(
                            Text("받는 사람")
                                .foregroundColor(Color(hex: 0x1e1e1e))
                        )
                        .foregroundStyle(Color(hex: 0x979797))
                    
                    Text("\(receiver)")
                        .foregroundStyle(Color(hex: 0x1e1e1e))
                }
            }
        }
        .padding()
        .frame(width: 300)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(hex: 0xD1CEC7))
        )
    }
}

#Preview {
    HomeView()
}
