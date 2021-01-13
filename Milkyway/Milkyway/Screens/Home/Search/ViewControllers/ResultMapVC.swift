//
//  ResultMapVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/10.
//

import UIKit
import NMapsMap

class ResultMapVC: UIViewController {
    
    @IBOutlet weak var mapView: NMFMapView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var naviCafeNameLabel: UILabel!
    
    var latitude: Double?
    var longitude: Double?
    var cafeName: String?
    var cafeAddress: String?
    var businessHours: String?
    
    let markerImage = NMFOverlayImage(name:"picker")
    let compassImage = NMFOverlayImage(name: "group510")
    let currentImage = NMFOverlayImage(name: "group511")
    let selectedPickerImage = NMFOverlayImage(name: "pickerSelected")
    let pickerImage = NMFOverlayImage(name: "picker")
    let UniSelectedImage = NMFOverlayImage(name: "pickerUniSelected")
    let directionImage = NMFOverlayImage(name: "myuniPolygon")
    let uniUnSelectedImage = NMFOverlayImage(name: "pickerUni")
    var cameraUpdate: NMFCameraUpdate!
    var marker: NMFMarker? // [NMFMarker]()
    var beforeMarker: NMFMarker?
    // 위치 더미로 잡아놓기
    var locationManager = CLLocationManager()
    //var location = NMGLatLng(lat: 37.555351, lng: 126.902356)
    // 필터링 결과 카드 뷰와 UI 동일하므로 그대로 재사용하기
    var cardVC: FilterResultCardVC!
    
    var moveState = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        
        setDelegate()
        setMarker()
        setMap()
        setCamera()
        //setLocation()
        setBackButton()
        setMapButton()
        setDeleteButton()
        setCardView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

extension ResultMapVC {
    
    
    func setDelegate(){
        locationManager.delegate = self
        mapView.addCameraDelegate(delegate: self)
        mapView.touchDelegate = self
    }
    func setCamera(){
        
        //let cameraPosition = NMFCameraPosition(NMGLatLng(lat: latitude ?? 0.0, lng: longitude ?? 0.0), zoom: 14)
        
        //cameraUpdate = NMFCameraUpdate(position: cameraPosition)
        cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude ?? 0.0, lng: longitude ?? 0.0))
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
        
    }
    func setMapButton(){
        
        locationButton.setImage(UIImage(named: "btnCurrentLocation"), for: UIControl.State.normal)
        locationButton.setImage(UIImage(named: "compassIc"), for: UIControl.State.selected)
        locationButton.addTarget(self, action: #selector(locationButtonDidTap), for: UIControl.Event.touchUpInside)
        
    }
    func setMarker(){
        
        let marker = NMFMarker(position: NMGLatLng(lat: latitude ?? 0.0, lng: longitude ?? 0.0), iconImage: selectedPickerImage)
        
        //marker.isHideCollidedMarkers = true
        print("카페이름\(cafeName)")
        print("카페이름\(cafeAddress)")
        print("카페이름\(businessHours)")

        marker.mapView = mapView
        
    }
    
    func setMap(){
        
        mapView.minZoomLevel = 5
        mapView.maxZoomLevel = 18
        
    }
    
    
    func setLocation(){
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let coor = locationManager.location?.coordinate
        move(at: coor)
        
    }
    
    func move(at coordinate: CLLocationCoordinate2D?){
        
        let locationOverlay = mapView.locationOverlay
        
        mapView.positionMode = .direction
        mapView.locationOverlay.icon = currentImage
        mapView.locationOverlay.subIcon = directionImage
        
        print("zoom level: \(mapView.zoomLevel)")
        
        locationOverlay.circleRadius = 0 // 기본 원그림자 없애기
        locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        
    }
    
    func setBackButton(){
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    func setDeleteButton(){
        
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        
    }
    
    // 카드뷰 불러오는 함수
    func setCardView(){
        
        cardVC = FilterResultCardVC(nibName: "FilterResultCardVC", bundle: nil)
        self.addChild(cardVC)
        self.view.addSubview(cardVC.view)
        let tabbarFrame = self.tabBarController?.tabBar.frame
        
        cardVC.view.frame = CGRect(x: 0, y: self.view.frame.height-tabbarFrame!.size.height-125, width: self.view.bounds.width, height: 125)
        
        
        cardVC?.cafeNameLabel.text = cafeName
        cardVC?.cafeAddressLabel.text = cafeAddress
        cardVC?.cafeTimeLabel.text = businessHours
        naviCafeNameLabel.text = cafeName
        
        cardVC.view.isHidden = false
        
    }
    
    @objc func backButtonClicked(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteButtonClicked(){
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func locationButtonDidTap(_ sender: UIButton){
        
        if sender.isSelected {
            
            sender.isSelected = false
            mapView.positionMode = .direction
            mapView.locationOverlay.icon = currentImage
            mapView.locationOverlay.subIcon = directionImage
            
        } else {
            
            sender.isSelected = true
            mapView.positionMode = .compass
            mapView.locationOverlay.icon = currentImage
            mapView.locationOverlay.subIcon = compassImage
        }
    }
    
    
    
    
    
    
}

extension ResultMapVC: NMFMapViewTouchDelegate {
    
    //
    //    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
    //        print("\(latlng)")
    //        //cardVC.view.isHidden = true
    //        self.beforeMarker?.iconImage = self.selectedPickerImage
    //
    //    }
    //
    //    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
    //        print(symbol)
    //
    //        cardVC.view.isHidden = true
    //        self.beforeMarker?.iconImage = self.pickerImage
    //
    //        return true
    //    }
    
}

extension ResultMapVC: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool){
        if reason == NMFMapChangedByGesture {
            
            mapView.locationOverlay.icon = currentImage
            
            
            beforeMarker?.iconImage = moveState ? self.uniUnSelectedImage : pickerImage
            
        }
    }
}

extension ResultMapVC: CLLocationManagerDelegate {
    
    
    
}
