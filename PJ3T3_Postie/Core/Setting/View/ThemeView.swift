//
//  ThemeView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 1/30/24.
//

import SwiftUI

struct ThemeView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isClicked") private var isClicked: Int = 0
    @AppStorage("isClicked2") private var isClicked2: Bool = true
    @State private var selectedThemeButton: Bool = true
    @Binding var isThemeGroupButton: Int
    @Binding var currentColorPage: Int
    @Binding var isTabGroupButton: Bool
    @Binding var currentGroupPage: Int
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        let items = ["포스티 오렌지", "포스티 옐로우", "포스티 그린", "포스티 블루", "포스티 블랙"]
        let images = ["postieListOrange", "postieListYellow", "postieListGreen", "postieListBlue", "postieListBlack"]
        
        // 2열 그리드 레이아웃을 정의합니다.
        let columns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        GeometryReader { geometry in
            ZStack {
                postieColors.backGroundColor
                    .ignoresSafeArea()
                
                VStack {
                    HStack(spacing: 10) {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 72, height: 30)
                                .background(selectedThemeButton ? postieColors.tintColor : postieColors.receivedLetterColor)
                                .cornerRadius(20)
                                .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 2, y: 2)
                            
                            Button(action: {
                                selectedThemeButton = true
                            }) {
                                if isThemeGroupButton == 4 {
                                    Text("테마 설정")
                                        .font(.caption)
                                        .bold(selectedThemeButton)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(selectedThemeButton ? Color.postieBlack : Color.postieWhite)
                                        .frame(width: 60, alignment: .top)
                                } else {
                                    Text("테마 설정")
                                        .font(.caption)
                                        .bold(selectedThemeButton)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(selectedThemeButton ? Color.postieWhite : Color.postieBlack)
                                        .frame(width: 60, alignment: .top)
                                }
                            }
                        }
                        
                        ZStack(alignment: .center) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 72, height: 30)
                                .background(selectedThemeButton ? postieColors.receivedLetterColor : postieColors.tintColor)
                                .cornerRadius(20)
                                .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 2, y: 2)
                            
                            Button(action: {
                                selectedThemeButton = false
                            }) {
                                if isThemeGroupButton == 4 {
                                    Text("나열 변경")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .bold(!selectedThemeButton)
                                        .foregroundColor(selectedThemeButton ? Color.postieWhite : Color.postieBlack)
                                        .frame(width: 60, alignment: .top)
                                } else {
                                    Text("나열 변경")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .bold(!selectedThemeButton)
                                        .foregroundColor(selectedThemeButton ? Color.postieBlack : Color.postieWhite)
                                        .frame(width: 60, alignment: .top)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if selectedThemeButton {
                            Button(action: {
                                isClicked = (isClicked + 1) % 3
                            }) {
                                if isClicked == 0 {
                                    Image(systemName: "square.split.2x1")
                                    
                                    Text("스플릿")
                                } else if isClicked == 1 {
                                    Image(systemName: "square.grid.2x2")
                                    
                                    Text("그리드")
                                } else {
                                    Image(systemName: "list.bullet")
                                    
                                    Text("리스트")
                                }
                            }
                        } else {
                            Button(action: {
                                isClicked2.toggle()
                            }) {
                                if isClicked2 {
                                    Image(systemName: "square.split.2x1")
                                    
                                    Text("스플릿")
                                } else {
                                    Image(systemName: "list.bullet")
                                    
                                    Text("리스트")
                                }
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    if selectedThemeButton {
                        if isClicked == 0 {
                            TabView(selection: $currentColorPage) {
                                Button(action: {
                                    isThemeGroupButton = 0
                                    currentColorPage = isThemeGroupButton
                                }) {
                                    VStack {
                                        HStack {
                                            Text("포스티 오렌지")
                                            
                                            Image(systemName: isThemeGroupButton == 0 ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(isThemeGroupButton == 0 ? postieColors.tintColor : postieColors.tabBarTintColor)
                                        }
                                        
                                        Image(isTabGroupButton ? "postieGroupOrange" : "postieListOrange")
                                            .resizable()
                                            .modifier(CustomImageModifier(height: geometry.size.height))
                                            .border(isThemeGroupButton == 0 ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                        
                                        Spacer()
                                    }
                                }
                                .tag(0)
                                
                                Button(action: {
                                    isThemeGroupButton = 1
                                    currentColorPage = isThemeGroupButton
                                }) {
                                    VStack {
                                        HStack {
                                            Text("포스티 옐로우")
                                            
                                            Image(systemName: isThemeGroupButton == 1 ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(isThemeGroupButton == 1 ? postieColors.tintColor : postieColors.tabBarTintColor)
                                        }
                                        
                                        Image(isTabGroupButton ? "postieGroupYellow" : "postieListYellow")
                                            .resizable()
                                            .modifier(CustomImageModifier(height: geometry.size.height))
                                            .border(isThemeGroupButton == 1 ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                        
                                        Spacer()
                                    }
                                }
                                .tag(1)
                                
                                Button(action: {
                                    isThemeGroupButton = 2
                                    currentColorPage = isThemeGroupButton
                                }) {
                                    VStack {
                                        HStack {
                                            Text("포스티 그린")
                                            
                                            Image(systemName: isThemeGroupButton == 2 ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(isThemeGroupButton == 2 ? postieColors.tintColor : postieColors.tabBarTintColor)
                                        }
                                        
                                        Image(isTabGroupButton ? "postieGroupGreen" : "postieListGreen")
                                            .resizable()
                                            .modifier(CustomImageModifier(height: geometry.size.height))
                                            .border(isThemeGroupButton == 2 ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                        
                                        Spacer()
                                    }
                                }
                                .tag(2)
                                
                                Button(action: {
                                    isThemeGroupButton = 3
                                    currentColorPage = isThemeGroupButton
                                }) {
                                    VStack {
                                        HStack {
                                            Text("포스티 블루")
                                            
                                            Image(systemName: isThemeGroupButton == 3 ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(isThemeGroupButton == 3 ? postieColors.tintColor : postieColors.tabBarTintColor)
                                        }
                                        
                                        Image(isTabGroupButton ? "postieGroupBlue" : "postieListBlue")
                                            .resizable()
                                            .modifier(CustomImageModifier(height: geometry.size.height))
                                            .border(isThemeGroupButton == 3 ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                        
                                        Spacer()
                                    }
                                }
                                .tag(3)
                                
                                Button(action: {
                                    isThemeGroupButton = 4
                                    currentColorPage = isThemeGroupButton
                                }) {
                                    VStack {
                                        HStack {
                                            Text("포스티 블랙")
                                            
                                            Image(systemName: isThemeGroupButton == 4 ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(isThemeGroupButton == 4 ? postieColors.tintColor : postieColors.tabBarTintColor)
                                        }
                                        
                                        Image(isTabGroupButton ? "postieGroupBlack" : "postieListBlack")
                                            .resizable()
                                            .modifier(CustomImageModifier(height: geometry.size.height))
                                            .border(isThemeGroupButton == 4 ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                        
                                        Spacer()
                                    }
                                }
                                .tag(4)
                            }
                            .tabViewStyle(PageTabViewStyle())
                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                            .onChange(of: isThemeGroupButton) { newValue in
                                saveToUserDefaults(value: newValue, key: "IsThemeGroupButton")
                            }
                        } else if isClicked == 1 {
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(Array(zip(items.indices, items)), id: \.0) { index, item in
                                        Button (action: {
                                            isThemeGroupButton = index
                                        }) {
                                            VStack {
                                                Image(images[index])
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 200)
                                                    .border(isThemeGroupButton == index ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                                    .padding()
                                                
                                                Text(item)
                                                    .padding(.bottom)
                                                
                                                Image(systemName: isThemeGroupButton == index ? "checkmark.circle.fill" : "circle")
                                                    .foregroundStyle(isThemeGroupButton == index ? postieColors.tintColor : postieColors.tabBarTintColor)
                                                    .font(.title2)
                                            }
                                            .frame(height: 300)
                                        }
                                    }
                                }
                                .padding()
                            }
                        } else {
                            ScrollView {
                                ForEach(Array(zip(items.indices, items)), id: \.0) { index, item in
                                    Button (action: {
                                        isThemeGroupButton = index
                                    }) {
                                        VStack {
                                            HStack {
                                                Image(images[index])
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 70)
                                                
                                                Text(item)
                                                
                                                Spacer()
                                                
                                                Image(systemName: isThemeGroupButton == index ? "checkmark.circle.fill" : "circle")
                                                    .foregroundStyle(isThemeGroupButton == index ? postieColors.tintColor : postieColors.tabBarTintColor)
                                                    .font(.title2)
                                            }
                                            
                                            DividerView(isThemeGroupButton: $isThemeGroupButton)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    } else {
                        if isClicked2 {
                            TabView(selection: $currentGroupPage) {
                                Button(action: {
                                    currentGroupPage = 0
                                    isTabGroupButton = true
                                }) {
                                    VStack {
                                        HStack {
                                            Text("편지 그룹")
                                            
                                            Image(systemName: isTabGroupButton ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(isTabGroupButton ? postieColors.tintColor : postieColors.tabBarTintColor)
                                        }
                                        
                                        Image("postieGroup\(stringFromNumber(isThemeGroupButton))")
                                            .resizable()
                                            .modifier(CustomImageModifier(height: geometry.size.height))
                                            .border(isTabGroupButton ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                        
                                        Spacer()
                                    }
                                }
                                .tag(0)
                                
                                Button(action: {
                                    currentGroupPage = 1
                                    isTabGroupButton = false
                                }) {
                                    VStack {
                                        HStack {
                                            Text("편지 리스트")
                                            
                                            Image(systemName: !isTabGroupButton ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(!isTabGroupButton ? postieColors.tintColor : postieColors.tabBarTintColor)
                                        }
                                        
                                        Image("postieList\(stringFromNumber(isThemeGroupButton))")
                                            .resizable()
                                            .modifier(CustomImageModifier(height: geometry.size.height))
                                            .border(isTabGroupButton ? postieColors.tintColor.opacity(0) : postieColors.tintColor)
                                        
                                        Spacer()
                                    }
                                }
                                .tag(1)
                            }
                            .tabViewStyle(PageTabViewStyle())
                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                            .onChange(of: isTabGroupButton) { newValue in
                                saveToUserDefaults(value: newValue, key: "IsTabGroupButton")
                            }
                        } else {
                            ScrollView {
                                VStack {
                                    Button (action: {
                                        isTabGroupButton = true
                                    }) {
                                        HStack {
                                            Image("postieGroupOrange")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 70)
                                            
                                            Text("편지 그룹")
                                            
                                            Spacer()
                                            
                                            Image(systemName: isTabGroupButton ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(isTabGroupButton ? postieColors.tintColor : postieColors.tabBarTintColor)
                                                .font(.title2)
                                        }
                                    }
                                    
                                    DividerView(isThemeGroupButton: $isThemeGroupButton)
                                    
                                    Button (action: {
                                        isTabGroupButton = false
                                    }) {
                                        HStack {
                                            Image("postieListOrange")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 70)
                                            
                                            Text("편지 리스트")
                                            
                                            Spacer()
                                            
                                            Image(systemName: !isTabGroupButton ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(!isTabGroupButton ? postieColors.tintColor : postieColors.tabBarTintColor)
                                                .font(.title2)
                                        }
                                    }
                                    
                                    DividerView(isThemeGroupButton: $isThemeGroupButton)
                                }
                                .padding()
                            }
                        
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Text("테마 설정")
                        .bold()
                        .foregroundStyle(postieColors.tintColor)
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("완료")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .tint(postieColors.tabBarTintColor)
        }
    }
}

struct CustomImageModifier: ViewModifier {
    var height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .frame(height: height < 650 ? height * 0.7 : height * 0.75)
            .shadow(color: Color.postieBlack.opacity(0.1), radius: 3)
    }
}

func saveToUserDefaults<T>(value: T, key: String) {
    UserDefaults.standard.set(value, forKey: key)
}

private func stringFromNumber(_ number: Int) -> String {
    switch number {
    case 1:
        return "Yellow"
    case 2:
        return "Green"
    case 3:
        return "Blue"
    case 4:
        return "Black"
    default:
        return "Orange"
    }
}

//#Preview {
//    ThemeView()
//}
