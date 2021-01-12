//
//  MyUniverseVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/30.
//

import UIKit
import NMapsMap

class MyUniverseVC: UIViewController{
    @IBOutlet weak var mapView: NMFMapView!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var glowUniverseLabel: UILabel!
    @IBOutlet weak var viewForAnimate: UIView!
    @IBOutlet weak var logoImgaeView: UIImageView!
    
    var myUniverse = UniverseData(aroundUniverse: [UniverseCafe](), nickName: "")
    var markers = [NMFMarker]()
    var camera: NMFCameraUpdate!
    // 직전에 눌린 마커가 저장됩니다.
    var beforeMarker: NMFMarker?
    
    
    // 선택된 피커 이미지
    let unselectImage = NMFOverlayImage(name: "pickerUniverse")
    // 선택되지않은 피커 이미지
    let selectImage = NMFOverlayImage(name: "pickerUniverseSelected")
    // 현위치 이미지 - 기본 동그라미 이미지
    let overlayIconImage = NMFOverlayImage(name: "circle")
    // 현위치 이미지 - 콤파스 이미지
    let subIconImage = NMFOverlayImage(name: "radius")
    // 현위치 이미지 - direction 이미지 (세모)
    let polygonIconImage = NMFOverlayImage(name: "frame539")
    
    // 하단에서 올라오는 VC
    var UniverseBottomVC: UniverseBottomVC!
    
    
    // 카드 VC
    var cardVC: UniverseCardVC!
    
   
    var cardHeight:CGFloat = 0 //363 //카드 높이 280 + 탭바높이 83 그냥 박는 버전
    let cardHandleAreaHeight:CGFloat = 84
    
    var cardVisible = false
    
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0

    
    override func viewWillAppear(_ animated: Bool) {
        print("myUniverse - viewWillAppear()")
        setCamera()
        serverlinked()
        gettingdark()
        

    }
    
    override func viewDidLoad(){
        print("myUniverse - viewDidLoad()")
        
        super.viewDidLoad()
        notiGather()
        delegateGather()
        setMap()
        setMapButton()
        setBottomCard()
        setFirstCardView()
        
    }
    

    // statusBar 색상변경
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
    }
    
    // MARK: - 삭제하시겠습니까? popup
    @objc func presentpopup() {
        print("myUniverse - presentpopup()")
        let storyboard = UIStoryboard(name: "UniversePopUp", bundle: nil)  
        
        if let popVC = storyboard.instantiateViewController(withIdentifier: "UniversePopUpVC") as? UniversePopUpVC {
            popVC.modalPresentationStyle = .overFullScreen
            popVC.modalTransitionStyle = .crossDissolve
            self.present(popVC, animated: true, completion: {
            })
        }
    }
    
    
    // MARK: - 데이터 로딩 중 Lottie 화면
    private var loadingView: UIActivityIndicatorView?
    
    @objc private func showLoadingLottie() {
        print("start")
        loadingView = UIActivityIndicatorView(style: .large)
        loadingView?.color = UIColor(named: "Milky")
        self.view.addSubview(loadingView!)
        loadingView?.center = self.view.center
        loadingView?.startAnimating()
    }
    
    @objc private func showLoadingLottieLight() {
        print("start")
        loadingView = UIActivityIndicatorView(style: .large)
        loadingView?.color = UIColor(named: "lightGrey")
        self.view.addSubview(loadingView!)
        loadingView?.center = self.view.center
        loadingView?.startAnimating()
    }
 
    
    @objc private func stopLottieAnimation() {
        print("end")
        loadingView?.stopAnimating()
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}


extension MyUniverseVC {
    
    // MARK: - 관련 노티
    func notiGather() {
        NotificationCenter.default.addObserver(self, selector: #selector(showLoadingLottie), name: Notification.Name("startlottieuni"),object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLoadingLottieLight), name: Notification.Name("startlottieunilight"),object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopLottieAnimation), name: Notification.Name("stoplottieuni"),object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentpopup), name: Notification.Name("removePopUp"),object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeBeforeCafe), name: Notification.Name("removeCafe"), object: nil)
        
    }
    
    // MARK: - 관련 델리게이트
    func delegateGather() {
        print("myUniverse - delegateGather()")
        mapView.addCameraDelegate(delegate: self)
        mapView.touchDelegate = self
    }
    
    // MARK: - 지도관련 세팅
    func setMap() {
        print("myUniverse - setMap()")
        mapView.minZoomLevel = 5
        mapView.maxZoomLevel = 18
        
    }
    
    // MARK: - 유니버스 탭 애니메이션
    func gettingdark() {
        print("myUniverse - gettingdark()")
        self.viewForAnimate.isHidden = false
        self.mapView.lightness = 0
        self.viewForAnimate.alpha = 0.0
        self.glowUniverseLabel.alpha = 0.0
        self.logoImgaeView.alpha = 0.0
        
        // 전체뷰 애니메이션
        UIView.animate(withDuration: 2.0 , delay: 0.0, options: .curveEaseInOut, animations: {
            self.viewForAnimate.alpha = 0.7
        }, completion: { finished in
            self.mapView.lightness = -0.7
            Thread.sleep(forTimeInterval: 0.4)
            self.viewForAnimate.isHidden = true
        })
                
        // 밀키웨이 로고 애니메이션
        UIImageView.animate(withDuration: 2.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.logoImgaeView.alpha = 1.0
            
        })
        
    }
    
    
    // MARK: - 카드 뷰 첫 세팅
    func setFirstCardView() {
  
        cardVC = UniverseCardVC(nibName: "UniverseCardVC", bundle: nil)
        self.addChild(cardVC)
        self.view.addSubview(cardVC.view)
        print("addsubView")
        let tabbarFrame = self.tabBarController?.tabBar.frame
        cardVC.view.frame = CGRect(x:0, y: self.view.frame.height - tabbarFrame!.size.height - 125, width: self.view.bounds.width, height: 125)
        
        cardVC.view.isHidden = true
    }
    
    
    // MARK: - 유니버스 상단 라벨 세팅
    func welcomeLabelSetting() {

        glowUniverseLabel.text =  markers.count > 0 ?
            "\(myUniverse.nickName) 님의 \n유니버스가 빛나고 있어요.\n오늘은 어떤 밀키웨이를 탐험해 볼까요?" : "\(myUniverse.nickName) 님의\n유니버스에 오신걸 환영합니다.\n\n홈에서 좋아하는 카페를 담아\n유니버스를 채워주세요!"

        
        // 폰트굵기 부분 변경하기 https://nsios.tistory.com/35
        
        let fontSize = UIFont(name:"SFProText-Bold", size: 20.0)
        let attributedStr = NSMutableAttributedString(string: glowUniverseLabel.text!)
        attributedStr.addAttribute(.font, value: fontSize!, range: (glowUniverseLabel.text! as NSString).range(of: "\(myUniverse.nickName)"))
        glowUniverseLabel.attributedText = attributedStr
        
        // 닉네임 라벨 애니메이션
        UILabel.animate(withDuration: 2.5 , delay: 0, options: .curveEaseInOut, animations: {
            self.glowUniverseLabel.alpha = 1.0
            
        }, completion: { finished in
            UILabel.animate(withDuration: 2.0 , delay: 6.0, options: .curveEaseInOut, animations: {
                self.glowUniverseLabel.alpha = 0.0
                
            })
        })
        
    }
    
    
    
    // MARK: - 현재위치버튼 눌렸을 때
    func setMapButton() {
        locationBtn.setImage(UIImage(named: "btnCurrentLocation"), for: UIControl.State.normal)
        locationBtn.setImage(UIImage(named: "compassIc"), for: UIControl.State.selected)
        locationBtn.addTarget(self, action: #selector(locationButtonDidTap), for: UIControl.Event.touchUpInside)
    }
    
    
    @objc func locationButtonDidTap(_ sender:UIButton){
        
        if sender.isSelected {
            //mapView.zoomLevel = 16
            sender.isSelected = false
            mapView.positionMode = .direction
            mapView.locationOverlay.icon = overlayIconImage
            mapView.locationOverlay.subIcon = polygonIconImage
            
        } else {
            //mapView.zoomLevel = 16
            sender.isSelected = true
            mapView.positionMode = .compass
            mapView.locationOverlay.icon = overlayIconImage
            mapView.locationOverlay.subIcon = subIconImage
        }
        
    }
    
    // MARK: - 삭제하고 다시 통신해야함 ...
    @objc func removeBeforeCafe() {
        serverlinked()
    }
    
    
    // MARK: - 카메라 무빙 (지금 찍혀있는 좌표는 서울 전체 보이게 되어있음)
    func setCamera() {
        print("myUniverse - setCamera()")
        let cameraPosition = NMFCameraPosition(NMGLatLng(lat: 37.525346, lng: 126.982174), zoom: 10.8)
        let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 0.5
        mapView.moveCamera(cameraUpdate)
        
        
    }
    
    // MARK: - 마커 찍는 부분 (서버통신 할 때마다 다시 찍어줘야할듯...)
    func setMarker() {
        print("myUniverse - setMarker()")
        markers = []
        for index in 0..<myUniverse.aroundUniverse.count {

            let marker = NMFMarker(position: NMGLatLng(lat: myUniverse.aroundUniverse[index].latitude, lng: myUniverse.aroundUniverse[index].longitude), iconImage: unselectImage)
                marker.isHideCollidedMarkers = true
                marker.touchHandler = { [self] (overlay: NMFOverlay) -> Bool in
                    self.beforeMarker?.iconImage = self.unselectImage
                    marker.iconImage = self.selectImage
                    self.beforeMarker = marker
                    cardVC.cafeNameLabel.text = myUniverse.aroundUniverse[index].cafeName
                    cardVC.cafeTimeLabel.text = myUniverse.aroundUniverse[index].businessHours
                    cardVC.cafeAddressLabel.text = myUniverse.aroundUniverse[index].cafeAddress
                    cardVC.cafeID = myUniverse.aroundUniverse[index].id
                    
                    cardVC.view.isHidden = false
                    return true
                }
                
                
                marker.mapView = mapView
                markers.append(marker)
            }
        
    }
    
    
    // MARK: - 서버서버서버
    func serverlinked() {
        UniverseService.shared.GetUniverse() { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? UniverseData {
                    print("success")
                    myUniverse = loadData
                    setMarker()
                    welcomeLabelSetting()
                    UniverseBottomVC.bottomCafeInfo = loadData
                    UniverseBottomVC.tableView.reloadData()
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
}

// MARK: - 지도 touch Delegate
extension MyUniverseVC: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("\(latlng)")
        cardVC.view.isHidden = true
        self.beforeMarker?.iconImage = self.unselectImage
        
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        print(symbol)
        
        cardVC.view.isHidden = true
        self.beforeMarker?.iconImage = self.unselectImage
        
        return true
    }
}


// MARK: - 지도 camera Delegate
extension MyUniverseVC: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool){
        if reason == NMFMapChangedByGesture {
            mapView.locationOverlay.icon = overlayIconImage
            mapView.locationOverlay.subIcon = nil
            
            cardVC.view.isHidden = true
            self.beforeMarker?.iconImage = self.unselectImage
        }
        
    }
    //    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
    //        //mapView.locationOverlay.icon = nowImage
    //
    //
    //    }
    //
    //    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
    // }
    //
    //    func mapViewCameraIdle(_ mapView: NMFMapView){
    //        //mapView.locationOverlay.icon = nowImage
    //    }
}


// MARK: - 바텀 sheet
extension MyUniverseVC {
    
    // MARK: - Bottom Card Setting GitHub -> https://github.com/brianadvent/InteractiveCardViewAnimation
    
    func setBottomCard() {
        UniverseBottomVC = Milkyway.UniverseBottomVC(nibName:"UniverseBottomVC", bundle:nil)
        self.addChild(UniverseBottomVC)
        self.view.addSubview(UniverseBottomVC.view)
        
        // 탭바 높이
        let tabbarFrame = self.tabBarController?.tabBar.frame;
        
        // SE에서 너무 많이 올라와서 이렇게 해봤는데 탭바 높이가 짧아서 덜 나오게 됨.
        
        if tabbarFrame!.size.height < 83 {
            cardHeight = self.mapView.frame.height / 2.5 + tabbarFrame!.size.height + (83 - tabbarFrame!.size.height)
        } else {
            cardHeight = self.mapView.frame.height / 1.8 + tabbarFrame!.size.height
        }
        //        cardHeight = self.mapView.frame.height / 2 + tabbarFrame!.size.height
        //        print("탭바 높이 \(tabbarFrame!.size.height)")
               print("card 높이 \(cardHeight)")
        
        //탭바 높이만큼 더하기
        UniverseBottomVC.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight - tabbarFrame!.size.height, width: self.view.bounds.width, height: cardHeight)
        
        UniverseBottomVC.view.clipsToBounds = false //여기 true면 shadow 안먹음
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyUniverseVC.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MyUniverseVC.handleCardPan(recognizer:)))
        
        UniverseBottomVC.handleArea.addGestureRecognizer(tapGestureRecognizer)
        UniverseBottomVC.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        
        // 탭바 높이
        let tabbarFrame = self.tabBarController?.tabBar.frame;
        
        if tabbarFrame!.size.height < 83 {
            cardHeight = self.mapView.frame.height / 1.7 + tabbarFrame!.size.height + (83 - tabbarFrame!.size.height)
        } else {
            cardHeight = self.mapView.frame.height / 1.52 + tabbarFrame!.size.height
        }
        
        //탭바 높이 추가 설정
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.UniverseBottomVC.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.UniverseBottomVC.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight - tabbarFrame!.size.height
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
            let translation = recognizer.translation(in: self.UniverseBottomVC.handleArea)
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


//                                NMGLatLng(lat: 37.5594084, lng: 127.0745830),
//                                NMGLatLng(lat: 37.5599980, lng: 126.9748245),
//                                NMGLatLng(lat: 37.5601083, lng: 126.9748951),
//                                NMGLatLng(lat: 37.5601980, lng: 126.9749873),
//                                NMGLatLng(lat: 37.5601998, lng: 126.9749896),
//                                NMGLatLng(lat: 37.5602478, lng: 126.9750492),
//                                NMGLatLng(lat: 37.5603158, lng: 126.9751371),
//                                NMGLatLng(lat: 37.5604241, lng: 126.9753616),
//                                NMGLatLng(lat: 37.5604853, lng: 126.9755401),
//                                NMGLatLng(lat: 37.5605225, lng: 126.9756157),
//                                NMGLatLng(lat: 37.5605353, lng: 126.9356405),
//                                NMGLatLng(lat: 37.5605652, lng: 126.9556924),
//                                NMGLatLng(lat: 37.5606143, lng: 126.9757679),
//                                NMGLatLng(lat: 37.5606903, lng: 126.9658432),
//                                NMGLatLng(lat: 37.5608510, lng: 126.9358919),
//                                NMGLatLng(lat: 37.5631353, lng: 126.9555964),
//                                NMGLatLng(lat: 37.5611949, lng: 126.9760386),
//                                NMGLatLng(lat: 37.5612383, lng: 126.9763164),
//                                NMGLatLng(lat: 37.5613796, lng: 126.9360721),
//                                NMGLatLng(lat: 37.5604143, lng: 126.9757379),
//                                NMGLatLng(lat: 37.5606603, lng: 126.9558432),
//                                NMGLatLng(lat: 37.5608710, lng: 126.9356919),
//                                NMGLatLng(lat: 37.5611353, lng: 126.9555964),
//                                NMGLatLng(lat: 37.5611249, lng: 126.9760186),
//                                NMGLatLng(lat: 37.5612383, lng: 126.9763364),
//                                NMGLatLng(lat: 37.5615796, lng: 126.9361721),
//                                NMGLatLng(lat: 37.5619326, lng: 126.9263123),
//                                NMGLatLng(lat: 37.5621502, lng: 126.9763991),
//                                NMGLatLng(lat: 37.5622776, lng: 126.8764492),
//                                NMGLatLng(lat: 37.5624374, lng: 126.9765137),
//                                NMGLatLng(lat: 37.5630911, lng: 126.9767743),
//                                NMGLatLng(lat: 37.5631345, lng: 126.9767931),
//                                NMGLatLng(lat: 37.5635163, lng: 127.0369230),
//                                NMGLatLng(lat: 37.5635506, lng: 126.9769351),
//                                NMGLatLng(lat: 37.5638061, lng: 126.9770239),
//                                NMGLatLng(lat: 37.5639153, lng: 126.8770605),
//                                NMGLatLng(lat: 37.5639577, lng: 126.9270749),
//                                NMGLatLng(lat: 37.5640074, lng: 126.9370927),
//                                NMGLatLng(lat: 37.5644783, lng: 126.9571755),
//                                NMGLatLng(lat: 37.5645229, lng: 126.9772482),
//                                NMGLatLng(lat: 37.5656330, lng: 126.9372667),
//                                NMGLatLng(lat: 37.5652152, lng: 126.9472971),
//                                NMGLatLng(lat: 37.5653569, lng: 126.9573170),
//                                NMGLatLng(lat: 37.5645173, lng: 126.9573222),
//                                NMGLatLng(lat: 37.5456534, lng: 126.9663258),
//                                NMGLatLng(lat: 37.5650418, lng: 126.9573004),
//                                NMGLatLng(lat: 37.5641985, lng: 126.9772914),
//                                NMGLatLng(lat: 37.5624663, lng: 126.9372952),
//                                NMGLatLng(lat: 37.5668827, lng: 126.9773047),
//                                NMGLatLng(lat: 37.5664467, lng: 126.9773054),
//                                NMGLatLng(lat: 37.5670567, lng: 126.9773080),
//                                NMGLatLng(lat: 37.5671360, lng: 126.9743097),
//                                NMGLatLng(lat: 37.5671910, lng: 126.9773116),
//                                NMGLatLng(lat: 37.5672785, lng: 126.9773122),
//                                NMGLatLng(lat: 37.5674668, lng: 126.9273120),
//                                NMGLatLng(lat: 37.5677264, lng: 126.9173124),
//                                NMGLatLng(lat: 37.5680410, lng: 126.9723068),
//                                NMGLatLng(lat: 37.5689242, lng: 126.9772871),
//                                NMGLatLng(lat: 37.5692829, lng: 126.9672698),
//                                NMGLatLng(lat: 37.5693829, lng: 126.9772669),
//                                NMGLatLng(lat: 37.5966597, lng: 126.9772615),
//                                NMGLatLng(lat: 37.5997524, lng: 126.9772575),
//                                NMGLatLng(lat: 37.5894659, lng: 126.9172499),
//                                NMGLatLng(lat: 37.5699671, lng: 126.9273070),
//                                NMGLatLng(lat: 37.5704151, lng: 126.9273395),
//                                NMGLatLng(lat: 37.5705748, lng: 126.9273866),
//                                NMGLatLng(lat: 37.5703164, lng: 126.9324373),
//                                NMGLatLng(lat: 37.5701903, lng: 126.9536225),
//                                NMGLatLng(lat: 37.5701905, lng: 126.9666723),
//                                NMGLatLng(lat: 37.5701897, lng: 126.9577006),
//                                NMGLatLng(lat: 37.5731869, lng: 126.9583990),
//                                NMGLatLng(lat: 37.5701813, lng: 126.9628591),
//                                NMGLatLng(lat: 37.5731770, lng: 126.9881139),
//                                NMGLatLng(lat: 37.5701741, lng: 126.9892702),
//                                NMGLatLng(lat: 37.5501743, lng: 126.9393098),
//                                NMGLatLng(lat: 37.5706752, lng: 126.9795182),
//                                NMGLatLng(lat: 37.5701761, lng: 126.9499315),
//                                NMGLatLng(lat: 37.5701775, lng: 126.9840380),
//                                NMGLatLng(lat: 37.5903500, lng: 126.9304048),
//                                NMGLatLng(lat: 37.5501832, lng: 126.9509189),
//                                NMGLatLng(lat: 37.5801845, lng: 126.9490197),
//                                NMGLatLng(lat: 37.5201862, lng: 126.9861986),
//                                NMGLatLng(lat: 37.5601882, lng: 126.9714375),
//                                NMGLatLng(lat: 37.5701955, lng: 126.9820897),
//                                NMGLatLng(lat: 37.5741955, lng: 127.0320897),
//                                NMGLatLng(lat: 37.5751955, lng: 127.0250897),
//                                NMGLatLng(lat: 37.5706955, lng: 127.0120897),
//                                NMGLatLng(lat: 37.5701765, lng: 127.0120897),
//                                NMGLatLng(lat: 37.5701555, lng: 127.0120897),
//                                NMGLatLng(lat: 37.4101382, lng: 127.0214375),
//                                NMGLatLng(lat: 37.4701255, lng: 127.0320897),
//                                NMGLatLng(lat: 37.4741955, lng: 127.0320897),
//                                NMGLatLng(lat: 37.4751955, lng: 127.0350897),
//                                NMGLatLng(lat: 37.4706955, lng: 127.0360897),
//                                NMGLatLng(lat: 37.4701765, lng: 127.0320897),
//                                NMGLatLng(lat: 37.4701555, lng: 127.0260897),
//                                NMGLatLng(lat: 37.4741555, lng: 127.0120897),
//                                NMGLatLng(lat: 37.4721755, lng: 127.0220897),
//                                NMGLatLng(lat: 37.4766955, lng: 127.0360897),
//                                NMGLatLng(lat: 37.4776955, lng: 127.0180897),
//                                NMGLatLng(lat: 37.481765, lng: 127.0320897),
//                                NMGLatLng(lat: 37.4701555, lng: 127.0360897),
//                                NMGLatLng(lat: 37.4701996, lng: 126.9891860)
//
//var placeMangWon = NMGLatLng(lat: 37.555941, lng: 126.910067)

//    // 소영이는 망원 좌표 수집중 ... ㅇ0ㅇ
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
//
//    ]
