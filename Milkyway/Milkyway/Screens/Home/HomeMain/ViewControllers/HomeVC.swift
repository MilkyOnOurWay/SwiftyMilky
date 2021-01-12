//
//  HomeVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/30.
//

import UIKit
import NMapsMap
import DLRadioButton

class HomeVC: UIViewController {
    
    
    
    @IBOutlet var mapView: NMFMapView!
    
    @IBOutlet var nickNameLabel: UILabel!
    
    @IBOutlet var filterBtn1: UIButton!
    @IBOutlet var filterBtn2: UIButton!
    @IBOutlet var filterBtn3: UIButton!
    @IBOutlet var filterBtn4: UIButton!
    
    @IBOutlet var locationBtn: UIButton!
    
    var homeData = HomeData(result: [AroundCafe](), nickName: "")
    var filterData = CategoryData(categoryCafe: [CategoryCafe](), nickName: "")
    var tag = [Int]()
    
    // 이미지들 넣기
    let markerImage = NMFOverlayImage(name: "picker") //마커
    let currentLImage = NMFOverlayImage(name: "group511") // 현위치 동그라미 이미지
    let directionImage = NMFOverlayImage(name: "myuniPolygon")
    let compassImage = NMFOverlayImage(name: "group510")
    
    let selectedImage = NMFOverlayImage(name: "pickerSelected")
    let unselectedImage = NMFOverlayImage(name: "picker")
    let uniSelectedImage = NMFOverlayImage(name: "pickerUniSelected")
    
    // 바텀시트 관련
    var bottomCardVC:CardVC!
    var cafeCardVC: CafeCardVC!
    
    var cardHeight:CGFloat = 0 //363 //카드 높이 280 + 탭바높이 83 그냥 박는 버전
    let cardHandleAreaHeight:CGFloat = 84
    
    var cardVisible = false
    
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    // 서버에서 모든 시작이 1이라고 해서 tag 값을 1부터 설정함. 여섯개 넣어줌
    var beforeState: [Bool] = [false, false, false, false, false, false]
    
    let searchLocation = [[0, 0],
                          [37.557852, 126.907507], //망원
                          [37.562680, 126.921358], //연남
                          [37.536427, 127.005132], //한남
                          [37.523733, 127.021235], //신사
                          [37.500667, 127.038390]] //역삼
    
    
    // 지도 관련
    var locationManager = CLLocationManager()
    var markers = [NMFMarker]()
    var beforeMarker: NMFMarker?
    
    var cameraUpdate: NMFCameraUpdate!
    
    var placeMangWon = NMGLatLng(lat: 37.555941, lng: 126.910067)
    
    // 망원 좌표
//    var mangWon: [NMGLatLng] = [NMGLatLng(lat: 37.556635, lng: 126.908433),
//                                NMGLatLng(lat: 37.556987, lng: 126.907755),
//                                NMGLatLng(lat: 37.556748, lng: 126.910195),
//                                NMGLatLng(lat: 37.555522, lng: 126.904833),
//                                NMGLatLng(lat: 37.557539, lng: 126.904790),
//                                NMGLatLng(lat: 37.556534, lng: 126.907744),
//                                NMGLatLng(lat: 37.560183, lng: 126.909584),
//                                NMGLatLng(lat: 37.560889, lng: 126.906703),
//                                NMGLatLng(lat: 37.561905, lng: 126.903533),
//                                NMGLatLng(lat: 37.560668, lng: 126.901677),
//                                NMGLatLng(lat: 37.559249, lng: 126.902487),
//                                NMGLatLng(lat: 37.554322, lng: 126.906648),
//                                NMGLatLng(lat: 37.555351, lng: 126.902356),
//                                NMGLatLng(lat: 37.558472, lng: 126.907506),
//                                NMGLatLng(lat: 37.557741, lng: 126.910403),
//                                NMGLatLng(lat: 37.560786, lng: 126.906412),
//                                NMGLatLng(lat: 37.558884, lng: 126.905102)
//    ]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        delegateGather()
        setLocation()
        setMap()
        setService()
//        setMarker()
        setMapButton()
        setFilterButton()
        setBottomCard()
        setFirstCardView()
        setRadioBtn()
    }
    
    // MARK: - 검색화면으로 이동
    @IBAction func searchBtnClicked(_ sender: Any) {
        
        print("Home - searchBtnClicked")
        guard let nvc = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier:"SearchVC") as? SearchVC else {
            return
        }
        
        self.navigationController?.pushViewController(nvc, animated: true)
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
        filterBtn1.setImage(UIImage(named: "decaffeine_w"), for: .normal)
        filterBtn1.setImage(UIImage(named: "decaffeine_p"), for: .selected)
        
        filterBtn2.setImage(UIImage(named: "soybeanMilk_w"), for: .normal)
        filterBtn2.setImage(UIImage(named: "soybeanMilk_p"), for: .selected)
        
        filterBtn3.setImage(UIImage(named: "lowfatMilk_w"), for: .normal)
        filterBtn3.setImage(UIImage(named: "lowfatMilk_p"), for: .selected)
        
        filterBtn4.setImage(UIImage(named: "fatFreeMilk_w"), for: .normal)
        filterBtn4.setImage(UIImage(named: "fatFreeMilk_p"), for: .selected)
        
        filterBtn1.addTarget(self, action: #selector(filterButtonDidTap), for: UIControl.Event.touchUpInside)
        filterBtn2.addTarget(self, action: #selector(filterButtonDidTap), for: UIControl.Event.touchUpInside)
        filterBtn3.addTarget(self, action: #selector(filterButtonDidTap), for: UIControl.Event.touchUpInside)
        filterBtn4.addTarget(self, action: #selector(filterButtonDidTap), for: UIControl.Event.touchUpInside)
    }
//    func addFilterTarget() {
//        filterBtn1.addTarget(self, action: #selector(filterButtonDidTap), for: UIControl.Event.touchUpInside)
//        filterBtn2.addTarget(self, action: #selector(filterButtonDidTap), for: UIControl.Event.touchUpInside)
//        filterBtn3.addTarget(self, action: #selector(filterButtonDidTap), for: UIControl.Event.touchUpInside)
//        filterBtn4.addTarget(self, action: #selector(filterButtonDidTap), for: UIControl.Event.touchUpInside)
//    }
    func delegateGather() {
        locationManager.delegate = self
        mapView.addCameraDelegate(delegate: self)
        mapView.touchDelegate = self
    }
    
    func setFirstCardView() {
        cafeCardVC = CafeCardVC(nibName: "CafeCardVC", bundle: nil)
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
        markers = []
        for index in 0..<homeData.result.count {

            let marker = NMFMarker(position: NMGLatLng(lat: homeData.result[index].latitude, lng: homeData.result[index].longitude), iconImage: unselectedImage)
                marker.isHideCollidedMarkers = true
                marker.touchHandler = { [self] (overlay: NMFOverlay) -> Bool in
                    self.beforeMarker?.iconImage = self.unselectedImage
                    marker.iconImage = self.selectedImage
                    self.beforeMarker = marker
                    cafeCardVC.cafeNameLabel.text = homeData.result[index].cafeName
                    cafeCardVC.cafeTimeLabel.text = homeData.result[index].businessHours
                    cafeCardVC.cafeAddressLabel.text = homeData.result[index].cafeAddress
                    cafeCardVC.addCountLabel.text = String(homeData.result[index].universeCount)
                    if homeData.result[index].isUniversed == true {
                        cafeCardVC.addCountLabel.textColor = UIColor(named: "Milky")
                        cafeCardVC.addButton.isSelected = true
                    }
                    cafeCardVC.view.isHidden = false
                    bottomCardVC.view.isHidden = true
                    return true
                }
                marker.mapView = mapView
                markers.append(marker)
            }
    }
    func setFilterMarker() {
        print("home - setFilterMarker()")
        markers = []
        for index in 0..<filterData.categoryCafe.count {
            //result
            let marker = NMFMarker(position: NMGLatLng(lat: filterData.categoryCafe[index].latitude, lng: filterData .categoryCafe [index].longitude), iconImage: unselectedImage)
                marker.isHideCollidedMarkers = true
                marker.touchHandler = { [self] (overlay: NMFOverlay) -> Bool in
                    self.beforeMarker?.iconImage = self.unselectedImage
                    marker.iconImage = self.selectedImage
                    self.beforeMarker = marker
                    cafeCardVC.cafeNameLabel.text = filterData.categoryCafe[index].cafeName
                    cafeCardVC.cafeTimeLabel.text = filterData.categoryCafe[index].businessHours
                    cafeCardVC.cafeAddressLabel.text = filterData.categoryCafe[index].cafeAddress
//                    cafeCardVC.addCountLabel.text = String(filterData.categoryCafe[index].universeCount)
//                    if filterData.categoryCafe[index].isUniversed == true {
//                        cafeCardVC.addCountLabel.textColor = UIColor(named: "Milky")
//                        cafeCardVC.addButton.isSelected = true
//                    }
                    cafeCardVC.view.isHidden = false
                    bottomCardVC.view.isHidden = true
                    return true
                }
                marker.mapView = mapView
                markers.append(marker)
            }
    }
    func setService() {
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
        }
        
        
        
    }
    func setMapButton() {
        locationBtn.setImage(UIImage(named: "btnCurrentLocation"), for: UIControl.State.normal)
        locationBtn.setImage(UIImage(named: "compassIc"), for: UIControl.State.selected)
        locationBtn.addTarget(self, action: #selector(locationButtonDidTap), for: UIControl.Event.touchUpInside)
    }

    @objc func filterButtonDidTap(_ sender:UIButton) {

        if sender.isSelected == true {
            sender.isSelected = false
            self.tag.popLast()
        } else {
            sender.isSelected = true
            self.tag.append(sender.tag)
        }
        
        print(tag)
        HomeService.shared.GetCategoryCafe(categoryId: tag) { [self] (networkResult) -> (Void) in
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
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
        
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
        
        if beforeState[sender.tag] == true {
            sender.isSelected = false
        }
        beforeState[1] = bottomCardVC.mangwonBtn.isSelected
        beforeState[2] = bottomCardVC.younnamBtn.isSelected
        beforeState[3] = bottomCardVC.hannamBtn.isSelected
        beforeState[4] = bottomCardVC.shinsaBtn.isSelected
        beforeState[5] = bottomCardVC.yuksamBtn.isSelected
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
        self.beforeMarker?.iconImage = self.unselectedImage
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        print(symbol)
        cafeCardVC.view.isHidden = true
        bottomCardVC.view.isHidden = false
        self.beforeMarker?.iconImage = self.unselectedImage
        return true
    }
}

extension HomeVC: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool){
        if reason == NMFMapChangedByGesture {
//            print("지도 움직이는 중 zoom level: \(mapView.zoomLevel)")
            mapView.locationOverlay.icon = currentLImage
            
//            cafeCardVC.view.isHidden = true
            self.beforeMarker?.iconImage = self.unselectedImage
            
        }
      
    }
    
//    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
//
//    }
//
//    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
//
//    }
//
//    func mapViewCameraIdle(_ mapView: NMFMapView){
//    }
}
