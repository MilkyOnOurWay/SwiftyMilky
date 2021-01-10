//
//  HomeVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/30.
//

import UIKit
import NMapsMap

class HomeVC: UIViewController {
    
    
    
    @IBOutlet var mapView: NMFMapView!
    
    @IBOutlet var nickNameLabel: UILabel!
    
    @IBOutlet var filterBtn1: UIButton!
    @IBOutlet var filterBtn2: UIButton!
    @IBOutlet var filterBtn3: UIButton!
    @IBOutlet var filterBtn4: UIButton!
    
    @IBOutlet var locationBtn: UIButton!
    
    
    let marker = NMFMarker()
    var locationManager = CLLocationManager()
    
    var cardVC:CardVC!
    
    var cardHeight:CGFloat = 0 //363 //카드 높이 280 + 탭바높이 83 그냥 박는 버전
    let cardHandleAreaHeight:CGFloat = 84
    
    var cardVisible = false
    
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setNickNameLabel(nickName: "유진") //일단 박아넣기 ~,~
        
        setMapLocation()
        setMapButton()
        setFilterButton()
        setBottomCard()
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
    func setNickNameLabel(nickName: String) {
        let boldAtt = [
            NSAttributedString.Key.font: UIFont(name: "SFProText-Bold", size: 16.0)!
        ]
        let regularAtt = [
            NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 16.0)!
        ]
        let boldText = NSAttributedString(string: "\(nickName)님!\n", attributes: boldAtt)
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
    
    func setMapLocation() {
        marker.mapView = mapView
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let coor = locationManager.location?.coordinate
        move(at: coor)
    }
    
    func move(at coordinate: CLLocationCoordinate2D?) {
        
        mapView.positionMode = .direction
    }
    
    func setMapButton() {
        locationBtn.setImage(UIImage(named: "btnCurrentLocation"), for: UIControl.State.normal)
        locationBtn.setImage(UIImage(named: "compassIc"), for: UIControl.State.selected)
        locationBtn.addTarget(self, action: #selector(locationButtonDidTap), for: UIControl.Event.touchUpInside)
    }
    
    @objc func filterButtonDidTap(_ sender:UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    @objc func locationButtonDidTap(_ sender:UIButton){
//        cardVC.resetRadioButton()
        
      if sender.isSelected == true {
        sender.isSelected = false
        mapView.positionMode = .direction
        
      } else {
        sender.isSelected = true
        mapView.positionMode = .compass
      }
    }
    
    
    
    // MARK: - Bottom Card Setting GitHub -> https://github.com/brianadvent/InteractiveCardViewAnimation
    
    func setBottomCard() {
        cardVC = CardVC(nibName:"CardVC", bundle:nil)

        self.addChild(cardVC)
        self.view.addSubview(cardVC.view)
        
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
        cardVC.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight - tabbarFrame!.size.height, width: self.view.bounds.width, height: cardHeight)
        
        cardVC.view.clipsToBounds = false //여기 true면 shadow 안먹음
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeVC.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(HomeVC.handleCardPan(recognizer:)))
        
        cardVC.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardVC.handleArea.addGestureRecognizer(panGestureRecognizer)
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
                    self.cardVC.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardVC.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight - tabbarFrame!.size.height
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
            let translation = recognizer.translation(in: self.cardVC.handleArea)
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
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        print(symbol)
        return true
    }
}

extension HomeVC: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool){
        if reason == NMFMapChangedByGesture {
//            print("지도 움직이는 중 zoom level: \(mapView.zoomLevel)")
            mapView.locationOverlay.icon = currentLImage
        }
      
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {

    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView){
    }
}
