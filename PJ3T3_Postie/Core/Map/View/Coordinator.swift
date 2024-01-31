//
//  Coordinator.swift
//  PJ3T3_Postie
//
//  Created by kwon ji won on 1/23/24.
//

import SwiftUI
import UIKit

import NMapsMap

// - NMFMapViewCameraDelegate 카메라 이동에 필요한 델리게이트,
// - NMFMapViewTouchDelegate 맵 터치할 때 필요한 델리게이트,
// - CLLocationManagerDelegate 위치 관련해서 필요한 델리게이트

class Coordinator: NSObject, ObservableObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    
    //    @Published var coord: (Double, Double) = (37.5626106, 126.9775524)
    @Published var userLocation: (Double, Double) = (37.5626106, 126.9775524)
    
    static let shared = Coordinator()
    
    //    let startInfoWindow = NMFInfoWindow()
    let view = NMFNaverMapView(frame: .zero)
    
    var markers: [NMFMarker] = []
    var locationManager: CLLocationManager?
    
    override init() {
        super.init()
        
        view.mapView.positionMode = .direction
        
        view.mapView.zoomLevel = 15 // 기본 맵이 표시될때 줌 레벨
        view.mapView.minZoomLevel = 10 // 최소 줌 레벨
        view.mapView.maxZoomLevel = 17 // 최대 줌 레벨
        
        view.showLocationButton = true // 현위치 버튼: 위치 추적 모드를 표현합니다. 탭하면 모드가 변경됩니다.
        view.showZoomControls = true // 줌 버튼: 탭하면 지도의 줌 레벨을 1씩 증가 또는 감소합니다.
        view.showCompass = true //  나침반 : 카메라의 회전 및 틸트 상태를 표현합니다. 탭하면 카메라의 헤딩과 틸트가 0으로 초기화됩니다. 헤딩과 틸트가 0이 되면 자동으로 사라집니다
        view.showScaleBar = true // 스케일 바 : 지도의 축척을 표현합니다. 지도를 조작하는 기능은 없습니다.
        
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
    }
    
    func getNaverMapView() -> NMFNaverMapView {
        view
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        // 카메라 이동이 시작되기 전 호출되는 함수
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        // 현재 지도 중심 좌표 가져오기
        let center = mapView.cameraPosition.target
        
        print("change position")
        print(center)
        // 카메라의 위치가 변경되면 호출되는 함수
    }
    
    func fetchLocation(latitude: Double, longitude: Double, name: String) {
        let marker = NMFMarker()
        
        //카메라가 옮겨지는 기능
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 15)
        
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        
        let locationOverlay = view.mapView.locationOverlay
        
        locationOverlay.hidden = true
        marker.position = NMGLatLng(lat: latitude, lng: longitude)
        
        marker.captionText = name
        
        //다른 아이콘이 필요하다면 추가 할 것
        //marker.iconImage = NMFOverlayImage(name: "marker_icon")
        locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
        
        marker.mapView = view.mapView
        view.mapView.moveCamera(cameraUpdate)
    }
    
    func addMarkerAndInfoWindow(latitude: Double, longitude: Double, caption: String) {
        let marker = NMFMarker()
        
        marker.captionText = caption
        marker.position = NMGLatLng(lat: latitude, lng: longitude)
        marker.mapView = view.mapView
        markers.append(marker)
        
        //        let infoWindow = NMFInfoWindow()
        //        let dataSource = NMFInfoWindowDefaultTextSource.data()
        //        //시간 설정, 나중에 구현 예정
        //        dataSource.title = time
        //        infoWindow.dataSource = dataSource
    }
    
    func removeAllMakers() {
        markers.forEach { marker in
            marker.mapView = nil
        }
        markers.removeAll()
    }
}

