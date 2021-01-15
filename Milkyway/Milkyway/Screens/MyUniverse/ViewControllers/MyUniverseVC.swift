//
//  MyUniverseVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/30.
//

import UIKit
import NMapsMap
import Lottie


class MyUniverseVC: UIViewController, UIGestureRecognizerDelegate{
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
    var universeBottomVC: UniverseBottomVC!
    
    
    // 카드 VC
    var cardVC: UniverseCardVC!
    
   
    var cardHeight:CGFloat = 0 //363 //카드 높이 280 + 탭바높이 83 그냥 박는 버전
    let cardHandleAreaHeight:CGFloat = 84
    var selectedCardCafeID = 0
    var cardVisible = false
    var selectIndex = 0
    
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0

    
    override func viewWillAppear(_ animated: Bool) {
        print("myUniverse - viewWillAppear()")
        serverlinked()
        
        

    }
    
    override func viewDidLoad(){
        
        print("myUniverse - viewDidLoad()")
        locationBtn.isEnabled = false
        super.viewDidLoad()
        notiGather()
        delegateGather()
        setMap()
        gettingdark()
        setCamera()
        setMapButton()
        setBottomCard()
        setFirstCardView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
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
            print( "cafeID : \(selectedCardCafeID)")
            popVC.cafeID = selectedCardCafeID
            popVC.modalPresentationStyle = .overFullScreen
            popVC.modalTransitionStyle = .crossDissolve
            
            self.present(popVC, animated: true, completion: {
            })
        }
        
        
    }
    
    
    // MARK: - 데이터 로딩 중 Lottie 화면
    
    let loadingView = AnimationView(name: "loadingLottie")
    
    @objc private func showLoadingLottie() {
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


extension MyUniverseVC {
    
    // MARK: - 관련 노티
    func notiGather() {
        NotificationCenter.default.addObserver(self, selector: #selector(showLoadingLottie), name: Notification.Name("startlottieuni"),object: nil)
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
        universeBottomVC.view.isHidden = false
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
            sender.isSelected = false
            mapView.positionMode = .direction
            mapView.locationOverlay.icon = overlayIconImage
            mapView.locationOverlay.subIcon = polygonIconImage
            
        } else {
            sender.isSelected = true
            mapView.positionMode = .compass
            mapView.locationOverlay.icon = overlayIconImage
            mapView.locationOverlay.subIcon = subIconImage
        }

    }
    
    // MARK: - 삭제 누르고 팝업창 확인까지 눌리면 실행되는 함수
    @objc func removeBeforeCafe() {
        markers[selectIndex].mapView = nil
        self.beforeMarker?.iconImage = self.unselectImage
        cardVC.view.isHidden = true
        universeBottomVC.view.isHidden = false
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
                    selectedCardCafeID = myUniverse.aroundUniverse[index].id
                    cardVC.cafeID = selectedCardCafeID
                    
                    cardVC.view.isHidden = false
                    universeBottomVC.view.isHidden = true
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
                    universeBottomVC.bottomCafeInfo = loadData
                    universeBottomVC.tableView.reloadData()
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
            locationBtn.isEnabled = true
            
        }
    }
    
    // 마커를 누르는 게 아닐 때 cardVC 내리고 / 바텀 보이며 / 마커는 선택전으로 돌아간다.
    func mapMove() {
        cardVC.view.isHidden = true
        universeBottomVC.view.isHidden = false
        self.beforeMarker?.iconImage = self.unselectImage
    }
    
}

// MARK: - 지도 touch Delegate
extension MyUniverseVC: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("\(latlng)")
        mapMove()
        
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        print(symbol)
        mapMove()
        return true
    }
}


// MARK: - 지도 camera Delegate
extension MyUniverseVC: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool){
        if reason == NMFMapChangedByGesture {
            mapView.locationOverlay.icon = overlayIconImage
            mapView.locationOverlay.subIcon = nil
            
            mapMove()
        }
        
    }
}


// MARK: - 바텀 sheet
extension MyUniverseVC {
    
    // MARK: - Bottom Card Setting GitHub -> https://github.com/brianadvent/InteractiveCardViewAnimation
    
    func setBottomCard() {
        universeBottomVC = Milkyway.UniverseBottomVC(nibName:"UniverseBottomVC", bundle:nil)
        self.addChild(universeBottomVC)
        self.view.addSubview(universeBottomVC.view)
        
        // 탭바 높이
        let tabbarFrame = self.tabBarController?.tabBar.frame;
        
        // SE에서 너무 많이 올라와서 이렇게 해봤는데 탭바 높이가 짧아서 덜 나오게 됨.
        
        if tabbarFrame!.size.height < 83 {
            cardHeight = self.mapView.frame.height / 2.3 + tabbarFrame!.size.height + (83 - tabbarFrame!.size.height)
        } else {
            cardHeight = self.mapView.frame.height / 1.8 + tabbarFrame!.size.height
        }
        //        cardHeight = self.mapView.frame.height / 2 + tabbarFrame!.size.height
        //        print("탭바 높이 \(tabbarFrame!.size.height)")
               print("card 높이 \(cardHeight)")
        
        //탭바 높이만큼 더하기
        universeBottomVC.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight - tabbarFrame!.size.height, width: self.view.bounds.width, height: cardHeight)
        
        universeBottomVC.view.clipsToBounds = false //여기 true면 shadow 안먹음
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyUniverseVC.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MyUniverseVC.handleCardPan(recognizer:)))
        
        universeBottomVC.handleArea.addGestureRecognizer(tapGestureRecognizer)
        universeBottomVC.handleArea.addGestureRecognizer(panGestureRecognizer)
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
                    self.universeBottomVC.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.universeBottomVC.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight - tabbarFrame!.size.height
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
            let translation = recognizer.translation(in: self.universeBottomVC.handleArea)
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
