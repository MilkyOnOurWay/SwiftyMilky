//
//  HomeVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/30.
//

import UIKit
import NMapsMap

class HomeVC: UIViewController {
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    @IBOutlet var mapView: NMFMapView!
    
    @IBOutlet var filterBtn1: UIButton!
    @IBOutlet var filterBtn2: UIButton!
    @IBOutlet var filterBtn3: UIButton!
    @IBOutlet var filterBtn4: UIButton!
    
    @IBOutlet var locationBtn: UIButton!
    
    
    let marker = NMFMarker()
    var locationManager = CLLocationManager()
    
    var cardVC:CardVC!
    
    let cardHeight:CGFloat = 400
    let cardHandleAreaHeight:CGFloat = 85
    
    var cardVisible = false
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
        override func viewDidLoad(){
        super.viewDidLoad()
        setMapLocation()
        setMapButton()
        setFilterButton()
        setBottomCard()
    }
    
    func setFilterButton() {
        //shadow는 나중에
        filterBtn1.layer.cornerRadius = filterBtn1.frame.height / 2
        filterBtn1.setImage(UIImage(named: "mujibang_w"), for: .normal)
        filterBtn1.setImage(UIImage(named: "mujibang_p"), for: .selected)
        
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
        locationBtn.setImage(UIImage(named: "plus.button"), for: UIControl.State.selected)
        locationBtn.addTarget(self, action: #selector(locationButtonDidTap), for: UIControl.Event.touchUpInside)
    }
    
    @objc func filterButtonDidTap(_ sender:UIButton){
        print(sender.tag)
        if sender.isSelected == true {
            sender.isSelected = false
          
        } else {
            sender.isSelected = true
        }
    }
    @objc func locationButtonDidTap(){
      if locationBtn.isSelected == true {
        locationBtn.isSelected = false
        mapView.positionMode = .direction
        
      } else {
        locationBtn.isSelected = true
        mapView.positionMode = .compass
      }
    }
    
    
    
    // MARK: - 검색화면으로 이동
    @IBAction func searchBtnClicked(_ sender: Any) {
        
        print("Home - searchBtnClicked")
        guard let nvc = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier:"SearchVC") as? SearchVC else {
            return
        }
        
        self.navigationController?.pushViewController(nvc, animated: true) // 다음 뷰 띄우기
        
    }
}
extension HomeVC: CLLocationManagerDelegate {
    
}

extension HomeVC {
    // MARK: - Bottom Card Setting GitHub -> https://github.com/brianadvent/InteractiveCardViewAnimation
    
    func setBottomCard() {
        
        cardVC = CardVC(nibName:"CardVC", bundle:nil)
        self.cardVC.view.layer.cornerRadius = 12
        // shadow 나중에
        
        self.addChild(cardVC)
        self.view.addSubview(cardVC.view)
        
        let tabbarFrame = self.tabBarController?.tabBar.frame; // 바텀 시트 올릴 때 사용
        
        //탭바 높이만큼 더 올리기
        cardVC.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight - tabbarFrame!.size.height, width: self.view.bounds.width, height: cardHeight)
        
        cardVC.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeVC.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(HomeVC.handleCardPan(recognizer:)))
        
        cardVC.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardVC.handleArea.addGestureRecognizer(panGestureRecognizer)
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
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        
        let tabbarFrame = self.tabBarController?.tabBar.frame; // 바텀 시트 내릴 때 사용
        
        //탭바 높이만큼 덜 내리기
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
}
