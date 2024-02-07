//
//  MapView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

import MapKit
import CoreLocation
import NMapsMap

struct MapView: View {
    private let name = ["우체국", "우체통"]
    
    @StateObject var naverGeocodeAPI = NaverGeocodeAPI.shared
    @StateObject var officeInfoServiceAPI = OfficeInfoServiceAPI.shared
    @StateObject var locationManager = LocationManager() // 지금 위치를 알기 위한 값
    @StateObject var coordinator: Coordinator = Coordinator.shared
    
    //    @State private var selectedPostDivType: Int = 1 //Dafault 우체국(1)
    @State private var selectedButtonIndex: Int = 0
    @State private var postLatitude: Double = 37.56
    @State private var postLongitude: Double = 126.98
    @State private var isSideMenuOpen = false
    @State var coord: MyCoord = MyCoord(37.579081, 126.974375) //Dafult값 (서울역)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Text("Postie Map")
                        .font(.custom("SourceSerifPro-Black", size: 40))
                        .foregroundStyle(Color.orange)
                    HStack(spacing: 10) {
                        ForEach(0...1, id: \.self) { index in
                            Button(action: {
                                selectedButtonIndex = index
                            }) {
                                ZStack {
                                    if selectedButtonIndex == index {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 70, height: 30)
                                            .background(Color(red: 1, green: 0.98, blue: 0.95))
                                            .cornerRadius(16)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .inset(by: 0.5)
                                                    .stroke(Color(red: 0.45, green: 0.45, blue: 0.45), lineWidth: 1)
                                            )} else {
                                                Rectangle()
                                                    .foregroundColor(.clear)
                                                    .frame(width: 72, height: 30)
                                                    .background(Color(red: 1, green: 0.98, blue: 0.95))
                                                    .cornerRadius(20)
                                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
                                            }
                                    
                                    Text(name[index])
                                        .font(Font.custom("SF Pro Text", size: 12))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.12, green: 0.12, blue: 0.12))
                                        .frame(width: 60, alignment: .center)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    
                    NaverMap(coord: coord)
                        .ignoresSafeArea(.all, edges: .top)
                    
                    Button("현재 위치에서 \(name[selectedButtonIndex])찾기") {
                        //현재 coord( 카메라 위치) 불러오기
                        //값을 불러 오기
                        print("버튼 눌림 \(coordinator.cameraLocation)")
                        
                        coord = MyCoord(coordinator.cameraLocation?.lat ?? 37.579081, coordinator.cameraLocation?.lng ?? 126.974375 )
                        
                        officeInfoServiceAPI.fetchData(postDivType: selectedButtonIndex + 1, postLatitude: coord.lat, postLongitude: coord.lng)
                        
                        print("불러옵니다\(coord)")
                    }
                }
                
                Spacer()
            }
        }
        .onAppear() {
            CLLocationManager().requestWhenInUseAuthorization()
            
            officeInfoServiceAPI.fetchData(postDivType: selectedButtonIndex + 1, postLatitude: coord.lat, postLongitude: coord.lng)
            
            locationManager.startUpdatingLocation()
        }
        .onChange(of: officeInfoServiceAPI.infos) { newInfos in
            coordinator.removeAllMakers()
            
            for result in newInfos {
                coordinator.addMarkerAndInfoWindow(latitude: Double(result.postLat)!, longitude: Double(result.postLon)!, caption: result.postNm, time: result.postTime)
            }
        }
        //초기 화면이 열리 때 위치값을 불러온다.
        .onChange(of: locationManager.location) { newLocation in
            if let location = newLocation {
                coord = MyCoord(location.coordinate.latitude, location.coordinate.longitude)
                
                print("현재위치: \(coord)")
                
                locationManager.stopUpdatingLocation()
            }
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
        }
        .zIndex(1)
        
    }
}

//#Preview {
//    MapView()
//}
