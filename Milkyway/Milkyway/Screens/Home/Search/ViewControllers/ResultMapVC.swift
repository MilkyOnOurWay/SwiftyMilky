//
//  ResultMapVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/10.
//

import UIKit
import NMapsMap
import Lottie

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
    var locationManager = CLLocationManager()
    var cardVC: FilterResultCardVC!
    
    var homeData = HomeData(result: [AroundCafe](), nickName: "")
    var moveState = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        
        setAllCafes()
        setDelegate()
        setMarker()
        setMap()
        setCamera()
        //setLocation()
        setBackButton()
        setMapButton()
        setDeleteButton()
        setCardView()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLottie), name: Notification.Name("startlottiehome"),object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopLottie), name: Notification.Name("stoplottiehome"),object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMap), name: Notification.Name("homeMarkerSet"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    let loadingView = AnimationView(name: "loadingLottie")
    
    @objc func showLottie(){
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        loadingView.center = self.view.center
        loadingView.contentMode = .scaleAspectFill
        loadingView.loopMode = .loop
        self.view.addSubview(loadingView)
        
        loadingView.play()
        
        
    }
    
    @objc func stopLottie(){
        loadingView.stop()
        loadingView.removeFromSuperview()
        
    }
    
}

// MARK: - 익스텐션 모음
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
        
        for index in 0..<homeData.result.count {
            let marker: NMFMarker
            if homeData.result[index].cafeName == cafeName && homeData.result[index].cafeAddress == cafeAddress {
                print("결과보여줘\(homeData.result[index])")
                if homeData.result[index].isUniversed == true {
                    marker = NMFMarker(position: NMGLatLng(lat: latitude ?? 0.0, lng: longitude ?? 0.0), iconImage: UniSelectedImage)
                    cardVC.universeButton.setImage(UIImage(named: "btnUniverseAdded"), for: .normal)
                    cardVC.universeCountLabel.textColor = UIColor(named: "Milky")
                    cardVC.buttonIsSelected = true
                    marker.mapView = mapView
                } else {
                    marker = NMFMarker(position: NMGLatLng(lat: latitude ?? 0.0, lng: longitude ?? 0.0),iconImage: selectedPickerImage)
                    cardVC.universeButton.setImage(UIImage(named: "btnUniverse"), for: .normal)
                    cardVC.universeCountLabel.textColor = UIColor(named: "darkGrey")
                    cardVC.buttonIsSelected = false
                    marker.mapView = mapView
                }
                print(homeData.result[index].universeCount)
                cardVC.universeCountLabel.font = UIFont(name: "SF Pro Text Bold", size: 12.0) ?? .systemFont(ofSize: 12.0, weight: .bold)
                cardVC.universeCount = homeData.result[index].universeCount
                cardVC.universeCountLabel.text = "\(homeData.result[index].universeCount)"
                cardVC.cafeId = homeData.result[index].id
                
               
            }
        }
       
        
        
        
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
    
    func checkUniverse(){
        
        
        
        
        
    }
    
    // MARK: - 홈 조회 API 연결 / 유니버스 여부 체크
    @objc func setAllCafes(){
        
        print("setService")
        showLottie()
        HomeService.shared.GetMilkyHome() { [self] (networkResult) -> (Void) in
         
            switch networkResult {
            case .success(let data):
                if let loadData = data as? HomeData {
                    print("success")
                    homeData = loadData
                    setMarker()
                    let ad = UIApplication.shared.delegate as? AppDelegate
                    print("nickName:\(homeData.nickName)")
                    ad?.userNickNameInHere = homeData.nickName
                   
                }
            case .requestErr( _):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
            stopLottie()
        }
    }
    
    @objc func reloadMap(){
        
        
        setAllCafes()
        setMarker()
        
        
        
        
    }
    
    
    
    
}

// MARK: - 네이버 지도 관련 Delegate
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
