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
    @IBOutlet var filterBtn1: UIButton!
    @IBOutlet var filterBtn2: UIButton!
    @IBOutlet var filterBtn3: UIButton!
    @IBOutlet var filterBtn4: UIButton!
    
    @IBOutlet var locationBtn: UIButton!
    
    
    let marker = NMFMarker()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setMapLocation()
        setMapButton()
        setFilterButton()
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
        let coor = locationManager.location?.coordinate
        
        marker.mapView = mapView
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    
        move(at: coor)
    }
    func move(at coordinate: CLLocationCoordinate2D?) {
        mapView.positionMode = .direction
    }
    
    func setMapButton() {
        
        locationBtn.setImage(UIImage(named: "plus.button"), for: UIControl.State.normal)
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
