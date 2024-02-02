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
    @State var coord: MyCoord = MyCoord(37.579081, 126.974375) //Dafult값 (서울역)
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 10) {
                    ForEach(0...1, id: \.self) { index in
                        Button(action: {
                            selectedButtonIndex = index
                            officeInfoServiceAPI.fetchData(postDivType: selectedButtonIndex + 1)
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
            }
            
            NaverMap(coord: coord)
                .ignoresSafeArea(.all, edges: .top)
        }
        .onAppear() {
            CLLocationManager().requestWhenInUseAuthorization()
            
            officeInfoServiceAPI.fetchData(postDivType: 1)
            
            locationManager.startUpdatingLocation()
        }
        .onChange(of: officeInfoServiceAPI.infos) { newInfos in
            coordinator.removeAllMakers()
            
            for result in newInfos {
                coordinator.addMarkerAndInfoWindow(latitude: Double(result.postLat)!, longitude: Double(result.postLon)!, caption: result.postNm)
            }
        }
        .onChange(of: locationManager.location) { newLocation in
            if let location = newLocation {
                coord = MyCoord(location.coordinate.latitude, location.coordinate.longitude)
                
                print("현재위치: \(coord)")
            }
        }
        
        // 카메라 위치 바뀌면 그 값에 따라 좌표 실시간으로 바꾸기 구현 예정
        //        .onChange(of: locationManager.isUpdatingLocation) { locations in
        //            if locations {
        //                locationManager.startUpdatingLocation()
        //            } else {
        //                locationManager.stopUpdatingLocation()
        //            }
        //        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
        }
        .zIndex(1)
        
    }
}

//#Preview {
//    MapView()
//}
