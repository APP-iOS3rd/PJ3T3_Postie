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
    @StateObject var naverGeocodeAPI = NaverGeocodeAPI.shared
    @StateObject var officeInfoServiceAPI = OfficeInfoServiceAPI.shared
    @StateObject var coordinator: Coordinator = Coordinator.shared
    
    @State private var selectedPostDivType: Int = 1 //Dafault 우체국(1)
    
    var body: some View {
        NavigationStack {
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
                            selectedPostDivType = 1
                            officeInfoServiceAPI.fetchData(postDivType: selectedPostDivType)
                            
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
                            selectedPostDivType = 2
                            officeInfoServiceAPI.fetchData(postDivType: selectedPostDivType)
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
            List {
                ForEach(officeInfoServiceAPI.infos, id: \.self) { result in
                    VStack {
                        Button(result.postNm)
                        {
                            coordinator.fetchLocation(latitude: Double(result.postLat)!, longitude: Double(result.postLon)!, name: result.postNm)
                        }
                    }
                }
            }
            NaverMap()
                .ignoresSafeArea(.all, edges: .top)
        }
        .navigationBarTitle("Postie Map")
        .foregroundStyle(Color(hex: 0x1E1E1E))
        .onAppear() {
            CLLocationManager().requestWhenInUseAuthorization()
        }
        
        //iOS17버전
//        .onChange(of: officeInfoServiceAPI.infos) {
////            $coordinator.removeAllMakers
//            for result in officeInfoServiceAPI.infos {
//                coordinator.addMarkerAndInfoWindow(latitude: Double(result.postLat)!, longitude: Double(result.postLon)!, caption: result.postNm)
//            }
//        }
        .onChange(of: officeInfoServiceAPI.infos) { newInfos in
            for result in newInfos {
                coordinator.addMarkerAndInfoWindow(latitude: Double(result.postLat)!, longitude: Double(result.postLon)!, caption: result.postNm)
            }
        }
        .zIndex(1)
    }
}

#Preview {
    MapView()
}
