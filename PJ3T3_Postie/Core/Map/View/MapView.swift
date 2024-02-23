//
//  MapView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI
import Foundation

import MapKit
import CoreLocation
import NMapsMap

struct MapView: View {
    
    private let name = ["우체국", "우체통"]
    
    @StateObject var naverGeocodeAPI = NaverGeocodeAPI.shared
    @StateObject var officeInfoServiceAPI = OfficeInfoServiceAPI.shared
    @StateObject var locationManager = LocationManager() // 지금 위치를 알기 위한 값
    @StateObject var coordinator: Coordinator = Coordinator.shared
    
    @State private var selectedButtonIndex: Int = 0
    @State private var postLatitude: Double = 37.56
    @State private var postLongitude: Double = 126.98
    @State private var isSideMenuOpen = false
    @State private var isKeyboardVisible = false
    @State private var searchText = ""
    @State private var showButton = true
//    @State private var CheckMyLocation = false
    @State private var checkAlert = false
    @State var coord: MyCoord = MyCoord(37.579081, 126.974375) //Dafult값 (서울역)
    
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        NavigationView {
            ZStack {
                postieColors.backGroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Postie Map")
                            .font(.custom("SourceSerifPro-Black", size: 40))
                            .foregroundStyle(postieColors.tintColor)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 10) {
                        ForEach(0...1, id: \.self) { index in
                            Button(action: {
                                selectedButtonIndex = index
                            }) {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 72, height: 30)
                                        .background(selectedButtonIndex == index ? postieColors.tintColor : postieColors.receivedLetterColor)
                                        .cornerRadius(20)
                                        .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 2, y: 2)
                                    
                                    Text(name[index])
                                        .font(.caption)
                                        .fontWeight(selectedButtonIndex == index ? .bold : .regular)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(selectedButtonIndex == index ? Color.postieWhite : Color.postieBlack)
                                        .frame(width: 60, alignment: .top)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    
                    HStack() {
                        Spacer(minLength: 10)
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("장소 검색(서초구, 서초동)", text: $searchText)
                            .foregroundColor(.primary)
                            .disableAutocorrection(true)
                            .focused($isSearchFocused)
                            .onSubmit {
                                naverGeocodeAPI.fetchLocationForPostalCode(searchText) { latitude, longitude in
                                    locationManager.stopUpdatingLocation()
                                    
                                    if let latitude = latitude, let longitude = longitude {
                                        //위경도 값 저장
                                        coordinator.updateMapView(coord: MyCoord(latitude,longitude))
                                        
                                        self.coord = MyCoord(latitude, longitude)
                                        
                                        officeInfoServiceAPI.fetchData(postDivType: selectedButtonIndex + 1, postLatitude: coord.lat, postLongitude: coord.lng)
                                        
                                        print("위경도 변환 성공\(coord)")
                                    } else {
                                        //알럿창 띄우기
                                        print("위치 정보를 가져오는데 실패했습니다.\(coord)")
                                        self.checkAlert.toggle()
                                    }
                                }
                            }
                            .alert("위치 정보가 잘못되었습니다.", isPresented: $checkAlert) {
                                Button("확인", role: .cancel) {
                                    
                                }
                            } message: {
                                Text("동이나 구 단위로 입력해주세요")
                                    .foregroundColor(.gray)
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer(minLength: 10)
                    }
                    .frame(height: 35)
//                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.clear))
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 15)
                    .padding(.bottom, 15)
                                        .onAppear (perform : UIApplication.shared.hideKeyboard)
                    //                    .background(Color(uiColor: .secondarySystemBackground))
                    //                    .textFieldStyle(.roundedBorder)
                    
                    ZStack(alignment: .top) {
                        NaverMap(coord: coord)
                            .ignoresSafeArea(.all, edges: .top)
                        
                        VStack {
                            Button(action: {
                                
                                print("현재 위치에서 \(name[selectedButtonIndex]) 찾기 버튼 눌림")
                                
                                locationManager.stopUpdatingLocation() // 현재 위치 추적 금지
                                
                                coord = MyCoord(coordinator.cameraLocation?.lat ?? coord.lat, coordinator.cameraLocation?.lng ?? coord.lng)
                                
                                officeInfoServiceAPI.fetchData(postDivType: selectedButtonIndex + 1, postLatitude: coord.lat, postLongitude: coord.lng)
                                
                                // 버튼 비활성화
                                showButton = false
                                // coordinator.cameraLocation 값이 바뀌면
                            }) {
                                if showButton {
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 150, height: 35)
                                            .background(Color.white) //색상
                                            .cornerRadius(16)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.gray, lineWidth: 0.3))
                                        
                                        HStack {
                                            Image(systemName: "arrow.clockwise")
                                                .frame(height: 10)
                                            Text("현 지도에서 검색")
                                                .font(Font.custom("SF Pro Text", size: 15))
                                        }
                                        .padding()
                                        .foregroundColor(.blue)
                                    }
                                }
                            }
                            Spacer()
                            
                            HStack {
                                Button( action: {
                                    // 내 위치
                                    locationManager.startUpdatingLocation()
                                    
                                    coordinator.cameraLocation?.lat = (locationManager.location!.coordinate.latitude)
                                    coordinator.cameraLocation?.lng = (locationManager.location!.coordinate.longitude)
                                    
                                    coordinator.updateMapView(coord: MyCoord(coordinator.cameraLocation!.lat, coordinator.cameraLocation!.lng))
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 6)
                                            .frame(width: 46, height: 46)
                                            .foregroundColor(.white)
                                        
                                        Image(systemName: "dot.scope")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 27, height: 20)
                                            .clipShape(Circle())
                                            .foregroundColor(.blue)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.bottom, 25)
                        }
                        .padding()
                    }
                }
                Spacer()
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button {
                        isSearchFocused = false
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
            isSearchFocused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
            isSearchFocused = false
        }
        
        .onAppear() {
            CLLocationManager().requestWhenInUseAuthorization()
            
            officeInfoServiceAPI.fetchData(postDivType: selectedButtonIndex + 1, postLatitude: coord.lat, postLongitude: coord.lng)
            
            // 초기 데이터 로드
                loadInitialData()
        }
        .onChange(of: officeInfoServiceAPI.infos) { newInfos in
            coordinator.removeAllMakers()
            
            for result in newInfos {
                var lunchtime: String = ""
                if result.lunchTime == "null" {
                    lunchtime = "없음"
                } else {
                    lunchtime = result.lunchTime!
                }
                coordinator.addMarkerAndInfoWindow(latitude: Double(result.postLat)!, longitude: Double(result.postLon)!, caption: result.postNm, time: result.postTime, lunchtime: lunchtime)
            }
        }
        
        .onChange(of: coordinator.cameraLocation) { result in
            self.showButton = true
        }
        
        //초기 화면이 열리 때 위치값을 불러온다.
        .onChange(of: locationManager.location) { newLocation in
            if let location = newLocation {
                coord = MyCoord(location.coordinate.latitude, location.coordinate.longitude)
                
                // 위치 정보 업데이트 후 필요한 작업 수행
                        handleLocationUpdate()
                
                locationManager.stopUpdatingLocation()
            }
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
        }
        .zIndex(1)
        
        
    }
    private func loadInitialData() {
        // 현재 위치 정보 업데이트
        updateLocation()
        
        // 초기 데이터 로드
        fetchData()
    }

    private func handleLocationUpdate() {
        // 위치 정보가 업데이트된 후 필요한 작업 수행
        // 예: 데이터 업데이트 등
        fetchData()
    }

    private func updateLocation() {
        // 현재 위치 업데이트
        locationManager.startUpdatingLocation()
        // 처음 들어올 때 coord 업데이트
        coord = MyCoord(coordinator.cameraLocation?.lat ?? coord.lat, coordinator.cameraLocation?.lng ?? coord.lng)
    }

    private func fetchData() {
        // 데이터 로드
        officeInfoServiceAPI.fetchData(postDivType: selectedButtonIndex + 1, postLatitude: coord.lat, postLongitude: coord.lng)
    }
}



extension UIApplication {
    func hideKeyboard() {
        guard let window = windows.first else { return }
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.delegate = self
        window.addGestureRecognizer(tapRecognizer)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
