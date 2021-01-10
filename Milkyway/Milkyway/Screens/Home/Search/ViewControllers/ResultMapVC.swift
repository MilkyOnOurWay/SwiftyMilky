//
//  ResultMapVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/10.
//

import UIKit
import NMapsMap

class ResultMapVC: UIViewController {
    
    @IBOutlet weak var mapView: NMFMapView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    var cardVC: FilterResultCardVC! // 필터링 결과 카드 뷰와 UI 동일하므로 그대로 재사용하기
    // 뷰 등장할 때 다시 등장
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        setBackButton()
        setDeleteButton()
        setCardView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.tabBarController?.tabBar.isHidden = true
//    }
}

extension ResultMapVC {
    
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
        
    }
    @objc func backButtonClicked(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteButtonClicked(){
        
        navigationController?.popToRootViewController(animated: true)
    }
}
