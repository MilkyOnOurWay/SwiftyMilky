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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        

    }
    
    func setMapView() {
        
    }

    @IBAction func searchBtnClicked(_ sender: Any) {
        
        print("Home - searchBtnClicked")
        guard let nvc = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier:"SearchVC") as? SearchVC else {
            return
        }
        
        self.navigationController?.pushViewController(nvc, animated: true) // 다음 뷰 띄우기
        
    }
   
}
