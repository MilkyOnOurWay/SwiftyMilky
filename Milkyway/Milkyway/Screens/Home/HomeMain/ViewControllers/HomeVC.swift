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
    @IBOutlet var locationBtn: UIButton!
    
    
    let marker = NMFMarker()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setMapLocation()
        setMapButton()
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
