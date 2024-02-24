//
//  Coordinator.swift
//  PJ3T3_Postie
//
//  Created by kwon ji won on 1/23/24.
//

import OSLog
import SwiftUI
import UIKit
import CoreLocation

import NMapsMap

// - NMFMapViewCameraDelegate 카메라 이동에 필요한 델리게이트,
// - NMFMapViewTouchDelegate 맵 터치할 때 필요한 델리게이트,
// - CLLocationManagerDelegate 위치 관련해서 필요한 델리게이트

class Coordinator: NSObject, ObservableObject, NMFMapViewCameraDelegate {
    
    static let shared = Coordinator()
    
    let view = NMFNaverMapView(frame: .zero) // 지도 객체 생성
    //    let locationManager = CLLocationManager()
    //    let startInfoWindow = NMFInfoWindow()
    
    var markers: [NMFMarker] = []
    var coord: MyCoord = MyCoord(0.0,0.0) // 내 위치값 초기 설정
    
    @Published var currentLocation: CLLocation?
    @Published var isUpdatingLocation: Bool = false
    @Published var cameraLocation: NMGLatLng?
//    @Published var checkMyLocation: Bool = true
    
    override init() {
        super.init()
        
        view.mapView.positionMode = .disabled
        
        view.mapView.zoomLevel = 15 // 기본 맵이 표시될때 줌 레벨
        view.mapView.minZoomLevel = 10 // 최소 줌 레벨
        view.mapView.maxZoomLevel = 17 // 최대 줌 레벨
        
        view.showLocationButton = false // 현위치 버튼: 위치 추적 모드를 표현합니다. 탭하면 모드가 변경됩니다.
        view.showZoomControls = true // 줌 버튼: 탭하면 지도의 줌 레벨을 1씩 증가 또는 감소합니다.
        view.showCompass = true //  나침반 : 카메라의 회전 및 틸트 상태를 표현합니다. 탭하면 카메라의 헤딩과 틸트가 0으로 초기화됩니다. 헤딩과 틸트가 0이 되면 자동으로 사라집니다
        view.showScaleBar = true // 스케일 바 : 지도의 축척을 표현합니다. 지도를 조작하는 기능은 없습니다.
        
        view.mapView.addCameraDelegate(delegate: self)
    }
    
    func getNaverMapView() -> NMFNaverMapView {
        view
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        // 카메라 이동이 시작되기 전 호출되는 함수
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        // 현재 지도 중심 좌표 가져오기
        cameraLocation = mapView.cameraPosition.target
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int) {
        // 현재 지도 중심 좌표 가져오기
        cameraLocation = mapView.cameraPosition.target
    }
    
    // 맵을 업데이트 -> 해당 위치에서 우체국 찾기 때 사용 예정
    func updateMapView(coord: MyCoord) {
        self.coord = coord //클래스 속성인 coord를 함수 인자로 전달된 값으로 변경
        
        // NMGLatLng: 하나의 위경도 좌표를 나타내는 클래스
        // https://navermaps.github.io/ios-map-sdk/guide-ko/2-2.html
        let updatecoord = NMGLatLng(lat: coord.lat, lng: coord.lng)
        
        moveCamera(coord: updatecoord) //카메라 바로 이동
        
        // 마커와 정보 창을 새롭게 추가하기 위해 기존 내용을 삭제
        removeAllMakers()
        
        // 위치 오버레이
        setLocationOverlay(coord: updatecoord)
        
        // 정보창과 연결된 마커를 추가
        //        addMarkerAndInfoWindow(coord: coord,
        //                               caption: self.coord.name,
        //                               infoTitle: "정보 창 내용/마커를 탭하면 닫힘")
    }
    
    //이건 뭐야
    func setLocationOverlay(coord: NMGLatLng) {
        let locationOverlay = view.mapView.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.location = coord
        locationOverlay.circleRadius = 50
        locationOverlay.circleOutlineWidth = 6
//        locationOverlay.circleColor = UIColor.blue
    }
    
    // 카메라를 옮기는 기능
    func moveCamera(coord: NMGLatLng, animation: NMFCameraUpdateAnimation = .none, duration: TimeInterval = 1) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = animation
        cameraUpdate.animationDuration = duration
        view.mapView.moveCamera(cameraUpdate)
        
        
        // 뷰 업데이트가 완료된 후에 checkMyLocation을 변경
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.checkMyLocation = false
//            }
    }
    
    // 카메라 위치 이동
    func moveCameraLocation(latitude: Double, longitude: Double) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 15)
        // 뷰 업데이트가 완료된 후에 checkMyLocation을 변경
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.checkMyLocation = false
            }
        
        Logger.map.info("움직인다 움직여 \(self.coord.lat) \(self.coord.lng)")
        view.mapView.moveCamera(cameraUpdate)
    }
    
    // 내 위치 주변에 원 그리기
    func drawCircleOvelay(center: NMGLatLng, radius: Double) {
        let circleOverlay = NMFCircleOverlay()
        circleOverlay.center = center
        circleOverlay.radius = radius // 미터 단위
        //        circleOverlay.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.2) // 원의 내부 색상
        circleOverlay.outlineWidth = 2 // 원의 외곽선 두께
        circleOverlay.outlineColor = UIColor.blue // 원의 외곽선 색상
        circleOverlay.mapView = view.mapView
        let cameraUpdate = NMFCameraUpdate(fit: NMGLatLngBounds(southWest: NMGLatLng(lat: center.lat - 0.01, lng: center.lng - 0.01),
                                                                northEast: NMGLatLng(lat: center.lat + 0.01, lng: center.lng + 0.01)))
        view.mapView.moveCamera(cameraUpdate)
    }
    
    // 마커 찍는 행위
    func addMarkerAndInfoWindow(latitude: Double, longitude: Double, caption: String, time: String, lunchtime: String) {
        let marker = NMFMarker()
        
        marker.captionText = caption
        //        marker.iconTintColor = UIColor.red
        //        marker.captionColor = UIColor.orange
        marker.captionTextSize = 16
        marker.subCaptionText = "영업시간 \(time) \n 점심시간 \(lunchtime)"
        
        marker.position = NMGLatLng(lat: latitude, lng: longitude)
        marker.mapView = view.mapView
        markers.append(marker)
    }

    // 기존 마커 삭제
    func removeAllMakers() {
        markers.forEach { marker in
            marker.mapView = nil
        }
        markers.removeAll()
    }
}

