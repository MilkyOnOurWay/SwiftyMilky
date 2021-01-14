//
//  HomeVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/30.
//

import UIKit
import NMapsMap
import DLRadioButton
import Lottie

class HomeVC: UIViewController, UIGestureRecognizerDelegate {
    
    
    
    @IBOutlet var mapView: NMFMapView!
    
    @IBOutlet var nickNameLabel: UILabel!
    
    @IBOutlet var filterBtn1: DLRadioButton!
    @IBOutlet var filterBtn2: DLRadioButton!
    @IBOutlet var filterBtn3: DLRadioButton!
    @IBOutlet var filterBtn4: DLRadioButton!
    
    @IBOutlet var locationBtn: UIButton!
    
    var homeData = HomeData(result: [AroundCafe](), nickName: "")
    var filterData = CategoryData(result: [CategoryCafe](), nickName: "")
    
    // 이미지들 넣기
    let markerImage = NMFOverlayImage(name: "picker") //마커
    let currentLImage = NMFOverlayImage(name: "group511") // 현위치 동그라미 이미지
    let directionImage = NMFOverlayImage(name: "myuniPolygon")
    let compassImage = NMFOverlayImage(name: "group510")
    
    let selectedImage = NMFOverlayImage(name: "pickerSelected")
    let unselectedImage = NMFOverlayImage(name: "picker")
    let uniSelectedImage = NMFOverlayImage(name: "pickerUniSelected")
    let uniUnSelectedImage = NMFOverlayImage(name: "pickerUni")
    
    // 바텀시트 관련
    var bottomCardVC:CardVC!
    var cafeCardVC: FilterResultCardVC!
    
    var cardHeight:CGFloat = 0 //363 //카드 높이 280 + 탭바높이 83 그냥 박는 버전
    let cardHandleAreaHeight:CGFloat = 84
    
    var cardVisible = false
    
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    // 서버에서 모든 시작이 1이라고 해서 tag 값을 1부터 설정함. 여섯개 넣어줌
    var locationState: [Bool] = [false, false, false, false, false, false]
    var filterState: [Bool] = [false, false, false, false, false]
    
    let searchLocation = [[0, 0],
                          [37.557852, 126.907507], //망원
                          [37.562680, 126.921358], //연남
                          [37.536427, 127.005132], //한남
                          [37.523733, 127.021235], //신사
                          [37.500667, 127.038390]] //역삼
    
    
    // 지도 관련
    var locationManager = CLLocationManager()
    var markers = [NMFMarker]()
    var filterMarkers = [NMFMarker]()
    
    var beforeMarker: NMFMarker?
    var beforeIS = true
    
    var cameraUpdate: NMFCameraUpdate!
    
    var placeMangWon = NMGLatLng(lat: 37.555941, lng: 126.910067)
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        delegateGather()
        setLocation()
        setMap()
        setMapButton()
        setFilterButton()
        setBottomCard()
        setFirstCardView()
        setRadioBtn()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        // 로티관련 노티
        NotificationCenter.default.addObserver(self, selector: #selector(showLoadingLottie), name: Notification.Name("startlottiehome"),object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopLottieAnimation), name: Notification.Name("stoplottiehome"),object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setService()
    }
    // MARK: - 검색화면으로 이동
    @IBAction func searchBtnClicked(_ sender: Any) {
        
        print("Home - searchBtnClicked")
        guard let nvc = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier:"SearchResultVC") as? SearchResultVC else {
            return
        }
        
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    
    
    // MARK: - 데이터 로딩 중 Lottie 화면
    
    let loadingView = AnimationView(name: "loadingLottie")
    
    @ objc private func showLoadingLottie() {
        print("start")
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        loadingView.center = self.view.center
        loadingView.contentMode = .scaleAspectFill
        loadingView.loopMode = .loop
        self.view.addSubview(loadingView)
        
        loadingView.play()
    }
    
    
    @objc private func stopLottieAnimation() {
        print("end")
        loadingView.stop()
        loadingView.removeFromSuperview()
    }
    
    
    
}

extension HomeVC: CLLocationManagerDelegate {
    
}

extension HomeVC {
    
    // 상단 ~님
    func setNickNameLabel() {
        let boldAtt = [
            NSAttributedString.Key.font: UIFont(name: "SFProText-Bold", size: 16.0)!
        ]
        let regularAtt = [
            NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 16.0)!
        ]
        let boldText = NSAttributedString(string: "\(homeData.nickName)님!\n", attributes: boldAtt)
        let regularText = NSAttributedString(string: "오늘도 ‘속’ 편한 탐험 시작해 볼까요?", attributes: regularAtt)
        
        
        let newString = NSMutableAttributedString()
        newString.append(boldText)
        newString.append(regularText)
        nickNameLabel.attributedText = newString
        nickNameLabel.numberOfLines = 2
    }
    
    // 상단 필터 버튼
    func setFilterButton() {
        filterBtn1.addTarget(self, action: #selector(filterButtonDidTap), for: UIControl.Event.touchUpInside)
        filterBtn2.addTarget(self, action: #selector(filterButtonDidTap), for: UIControl.Event.touchUpInside)
        filterBtn3.addTarget(self, action: #selector(filterButtonDidTap), for: UIControl.Event.touchUpInside)
        filterBtn4.addTarget(self, action: #selector(filterButtonDidTap), for: UIControl.Event.touchUpInside)
    }
    func delegateGather() {
        locationManager.delegate = self
        mapView.addCameraDelegate(delegate: self)
        mapView.touchDelegate = self
    }
    
    func setFirstCardView() {
        cafeCardVC = FilterResultCardVC(nibName: "FilterResultCardVC", bundle: nil)
        self.addChild(cafeCardVC)
        self.view.addSubview(cafeCardVC.view)
        print("addsubView")
        let tabbarFrame = self.tabBarController?.tabBar.frame
        cafeCardVC.view.frame = CGRect(x:0, y: self.view.frame.height - tabbarFrame!.size.height - 125, width: self.view.bounds.width, height: 125)
        
        cafeCardVC.view.isHidden = true
    }
    
    func setLocation(){
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization() //권한요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let coor = locationManager.location?.coordinate
        move(at: coor)
    }
    
    func setMap() {
        mapView.minZoomLevel = 5
        mapView.maxZoomLevel = 18
    }
    
    func move(at coordinate: CLLocationCoordinate2D?) {
        let locationOverlay = mapView.locationOverlay
        
        mapView.positionMode = .direction
        mapView.locationOverlay.icon = currentLImage
        mapView.locationOverlay.subIcon = directionImage
        
        print("zoom level: \(mapView.zoomLevel)")
        
        locationOverlay.circleRadius = 0 // 기본 원그림자 없애기
        locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
    }
    func setMarker() {
        print("home - setMarker()")
        markerReset(marker: markers)
        markers = []
        for index in 0..<homeData.result.count {
            let marker: NMFMarker
            
            if homeData.result[index].isUniversed == true {
                marker = NMFMarker(position: NMGLatLng(lat: homeData.result[index].latitude, lng: homeData.result[index].longitude), iconImage: uniUnSelectedImage)
            } else {
                marker = NMFMarker(position: NMGLatLng(lat: homeData.result[index].latitude, lng: homeData.result[index].longitude), iconImage: unselectedImage)
            }
            
            //                marker.isHideCollidedMarkers = true
            marker.touchHandler = { [self] (overlay: NMFOverlay) -> Bool in
                cafeCardVC.cafeNameLabel.text = homeData.result[index].cafeName
                cafeCardVC.cafeTimeLabel.text = homeData.result[index].businessHours
                cafeCardVC.cafeAddressLabel.text = homeData.result[index].cafeAddress
                cafeCardVC.universeCount = homeData.result[index].universeCount
                cafeCardVC.universeCountLabel.text = "\(homeData.result[index].universeCount)"
                if homeData.result[index].isUniversed {
                    cafeCardVC.universeButton.setImage(UIImage(named: "btnUniverseAdded"), for: .normal)
                    cafeCardVC.universeCountLabel.textColor = UIColor(named: "Milky")
                    cafeCardVC.universeCountLabel.font = UIFont(name: "SF Pro Text Bold", size: 12.0) ?? .systemFont(ofSize: 12.0, weight: .bold)
                }
                else {
                    cafeCardVC.universeButton.setImage(UIImage(named: "btnUniverse"), for: .normal)
                    cafeCardVC.universeCountLabel.textColor = UIColor(named: "darkGrey")
                    cafeCardVC.universeCountLabel.font = UIFont(name: "SF Pro Text Regular", size: 12.0) ?? .systemFont(ofSize: 8.0, weight: .regular)
                    
                }
                
                cafeCardVC.cafeId = homeData.result[index].id
                print("isUniversed : \(homeData.result[index].isUniversed)")
                cafeCardVC.buttonIsSelected = homeData.result[index].isUniversed
                
                // 이전 마커체크
                beforeMarker?.iconImage = beforeIS ? self.uniUnSelectedImage : unselectedImage
                
                
                // 현재마커 변경
                if homeData.result[index].isUniversed == true {
                    marker.iconImage = self.uniSelectedImage
                    beforeIS = true
                    beforeMarker = marker
                }
                else {
                    marker.iconImage = self.selectedImage
                    beforeIS = false
                    beforeMarker = marker
                }
                
                
                
                cafeCardVC.view.isHidden = false
                bottomCardVC.view.isHidden = true
                return true
            }
            marker.mapView = mapView
            markers.append(marker)
        }
        markerReset(marker: filterMarkers)
    }
    
    
    func setFilterMarker() {
        print("home - setFilterMarker()")
        markerReset(marker: filterMarkers)
        filterMarkers = []
        for index in 0..<filterData.result.count {
            let marker: NMFMarker
            if filterData.result[index].isUniversed == true {
                marker = NMFMarker(position: NMGLatLng(lat: filterData.result[index].latitude, lng: filterData.result [index].longitude), iconImage: uniUnSelectedImage)
            } else {
                marker = NMFMarker(position: NMGLatLng(lat: filterData.result[index].latitude, lng: filterData.result [index].longitude), iconImage: unselectedImage)
            }
            //                marker.isHideCollidedMarkers = true
            marker.touchHandler = { [self] (overlay: NMFOverlay) -> Bool in
                
                cafeCardVC.cafeNameLabel.text = filterData.result[index].cafeName
                cafeCardVC.cafeTimeLabel.text = filterData.result[index].businessHours
                cafeCardVC.cafeAddressLabel.text = filterData.result[index].cafeAddress
                cafeCardVC.universeCount = filterData.result[index].universeCount
                cafeCardVC.universeCountLabel.text = "\(filterData.result[index].universeCount)"
                
                if filterData.result[index].isUniversed {
                    cafeCardVC.universeButton.setImage(UIImage(named: "btnUniverseAdded"), for: .normal)
                    cafeCardVC.universeCountLabel.textColor = UIColor(named: "Milky")
                    cafeCardVC.universeCountLabel.font = UIFont(name: "SF Pro Text Bold", size: 12.0) ?? .systemFont(ofSize: 8.0, weight: .bold)
                }
                else {
                    cafeCardVC.universeButton.setImage(UIImage(named: "btnUniverse"), for: .normal)
                    cafeCardVC.universeCountLabel.textColor = UIColor(named: "darkGrey")
                    cafeCardVC.universeCountLabel.font = UIFont(name: "SF Pro Text Regular", size: 12.0) ?? .systemFont(ofSize: 12.0, weight: .regular)
                }
                cafeCardVC.cafeId = filterData.result[index].id
                cafeCardVC.buttonIsSelected = filterData.result[index].isUniversed
                
                // 이전 마커체크
                beforeMarker?.iconImage = beforeIS ? self.uniUnSelectedImage : unselectedImage
                
                
                // 현재마커 변경
                if homeData.result[index].isUniversed == true {
                    marker.iconImage = self.uniSelectedImage
                    beforeIS = true
                    beforeMarker = marker
                }
                else {
                    marker.iconImage = self.selectedImage
                    beforeIS = false
                    beforeMarker = marker
                }
                
                
                cafeCardVC.view.isHidden = false
                bottomCardVC.view.isHidden = true
                return true
            }
            marker.mapView = mapView
            filterMarkers.append(marker)
        }
        markerReset(marker: markers)
    }
    
    
    func setService() {
        showLoadingLottie()
        print("setService")
        HomeService.shared.GetMilkyHome() { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? HomeData {
                    print("success")
                    
                    homeData = loadData
                    setMarker()
                    // 유저닉네임 전역변수로 설정
                    let ad = UIApplication.shared.delegate as? AppDelegate
                    print("nickName:\(homeData.nickName)")
                    ad?.userNickNameInHere = homeData.nickName
                    setNickNameLabel()
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
            stopLottieAnimation()
        }
    }
    func setMapButton() {
        locationBtn.setImage(UIImage(named: "btnCurrentLocation"), for: UIControl.State.normal)
        locationBtn.setImage(UIImage(named: "compassIc"), for: UIControl.State.selected)
        locationBtn.addTarget(self, action: #selector(locationButtonDidTap), for: UIControl.Event.touchUpInside)
    }
    
    func markerReset(marker: [NMFMarker]){
        for i in 0..<marker.count {
            marker[i].mapView = nil
        }
    }
    @objc func filterButtonDidTap(_ sender:DLRadioButton) {
        showLoadingLottie()
        
        if filterState[sender.tag] == true {
            sender.isSelected = false
            //            markerReset(marker: markers)
            setMarker()
            //            markerReset(marker: filterMarkers)
            stopLottieAnimation()
        } else {
            //            markerReset(marker: filterMarkers)
            HomeService.shared.GetCategoryCafe(categoryId: sender.tag) { [self] (networkResult) -> (Void) in
                switch networkResult {
                case .success(let data):
                    if let loadData = data as? CategoryData {
                        print("success")
                        filterData = loadData
                        setFilterMarker()
                    }
                case .requestErr( _):
                    print("requestErr")
                case .pathErr:
                    print("pathErr")
                    markerReset(marker: filterMarkers)
                    markerReset(marker: markers)
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
                stopLottieAnimation()
            }
            print(sender.icon, filterData.result.count)
            //            markerReset(marker: markers)
        }
        
        filterState[1] = filterBtn1.isSelected
        filterState[2] = filterBtn2.isSelected
        filterState[3] = filterBtn3.isSelected
        filterState[4] = filterBtn4.isSelected
        
    }
    
    @objc func locationButtonDidTap(_ sender:UIButton){
        mapView.zoomLevel = 14
        cafeCardVC.view.isHidden = true
        bottomCardVC.view.isHidden = false
        
        if sender.isSelected == true {
            sender.isSelected = false
            print("direction btn | zoom level \(mapView.zoomLevel)")
            
            mapView.positionMode = .direction
            mapView.locationOverlay.icon = currentLImage
            mapView.locationOverlay.subIcon = directionImage
        } else {
            sender.isSelected = true
            print("compass btn | zoom level \(mapView.zoomLevel)")
            
            mapView.positionMode = .compass
            mapView.locationOverlay.icon = currentLImage
            mapView.locationOverlay.subIcon = compassImage
        }
    }
    
    
    
    
    // MARK: - Bottom Card Setting GitHub -> https://github.com/brianadvent/InteractiveCardViewAnimation
    
    func setBottomCard() {
        bottomCardVC = CardVC(nibName:"CardVC", bundle:nil)
        
        self.addChild(bottomCardVC)
        self.view.addSubview(bottomCardVC.view)
        
        // 탭바 높이
        let tabbarFrame = self.tabBarController?.tabBar.frame;
        
        // SE에서 너무 많이 올라와서 이렇게 해봤는데 탭바 높이가 짧아서 덜 나오게 됨.
        
        if tabbarFrame!.size.height < 83 {
            cardHeight = self.mapView.frame.height / 2 + tabbarFrame!.size.height + (83 - tabbarFrame!.size.height)
        } else {
            cardHeight = self.mapView.frame.height / 2 + tabbarFrame!.size.height
        }
        //        cardHeight = self.mapView.frame.height / 2 + tabbarFrame!.size.height
        //        print("탭바 높이 \(tabbarFrame!.size.height)")
        //        print("card 높이 \(cardHeight)")
        
        //탭바 높이만큼 더하기
        bottomCardVC.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight - tabbarFrame!.size.height, width: self.view.bounds.width, height: cardHeight)
        
        bottomCardVC.view.clipsToBounds = false //여기 true면 shadow 안먹음
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeVC.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(HomeVC.handleCardPan(recognizer:)))
        
        bottomCardVC.handleArea.addGestureRecognizer(tapGestureRecognizer)
        bottomCardVC.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    func setRadioBtn() {
        bottomCardVC.mangwonBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        bottomCardVC.younnamBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        bottomCardVC.hannamBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        bottomCardVC.shinsaBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        bottomCardVC.yuksamBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
    }
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        
        // 탭바 높이
        let tabbarFrame = self.tabBarController?.tabBar.frame;
        
        if tabbarFrame!.size.height < 83 {
            cardHeight = self.mapView.frame.height / 2 + tabbarFrame!.size.height + (83 - tabbarFrame!.size.height)
        } else {
            cardHeight = self.mapView.frame.height / 2 + tabbarFrame!.size.height
        }
        
        //탭바 높이 추가 설정
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.bottomCardVC.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.bottomCardVC.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight - tabbarFrame!.size.height
                    self.bottomCardVC.resetRadioButton()
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    @objc func sendBtnTag(_ sender:DLRadioButton) {
        
        print(sender.tag)
        
        cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: searchLocation[sender.tag][0], lng: searchLocation[sender.tag][1]))
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 0.5
        mapView.moveCamera(cameraUpdate)
        
        if locationState[sender.tag] == true {
            sender.isSelected = false
        }
        locationState[1] = bottomCardVC.mangwonBtn.isSelected
        locationState[2] = bottomCardVC.younnamBtn.isSelected
        locationState[3] = bottomCardVC.hannamBtn.isSelected
        locationState[4] = bottomCardVC.shinsaBtn.isSelected
        locationState[5] = bottomCardVC.yuksamBtn.isSelected
    }
    
    @objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.bottomCardVC.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
}
extension HomeVC: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("\(latlng)")
        cafeCardVC.view.isHidden = true
        bottomCardVC.view.isHidden = false
        beforeMarker?.iconImage = beforeIS ? self.uniUnSelectedImage : unselectedImage
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        print(symbol)
        cafeCardVC.view.isHidden = true
        bottomCardVC.view.isHidden = false
        beforeMarker?.iconImage = beforeIS ? self.uniUnSelectedImage : unselectedImage
        return true
    }
}

extension HomeVC: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool){
        if reason == NMFMapChangedByGesture {
            //            print("지도 움직이는 중 zoom level: \(mapView.zoomLevel)")
            mapView.locationOverlay.icon = currentLImage
            
            //            cafeCardVC.view.isHidden = true
            beforeMarker?.iconImage = beforeIS ? self.uniUnSelectedImage : unselectedImage
            cafeCardVC.view.isHidden = true
        }
    }
}
