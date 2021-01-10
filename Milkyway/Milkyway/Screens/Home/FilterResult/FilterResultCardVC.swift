//
//  FilterResultCardVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/08.
//

import UIKit

class FilterResultCardVC: UIViewController {

    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var cafeTimeLabel: UILabel!
    @IBOutlet weak var universeButton: UIButton!
    @IBOutlet weak var universeCountLabel: UILabel!
    
    var universeCount = 0 // 서버 위키 추후에 다시 참고할 것. 일단 박아놓은 값
    var buttonIsSelected = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setUniverseButton()
    }

}

extension FilterResultCardVC {
    
    func setView(){
        
        
    }
    
    func setUniverseButton(){
        
        universeButton.addTarget(self, action: #selector(universeButtonDidTap), for: .touchUpInside)
        
      
        
        
        
    }
    
    @objc func universeButtonDidTap(){
        
        // 서버통신진행
        
        // 버튼 이미지 변경
        universeButton.setBackgroundImage(UIImage(named: "btnUniverseAdded"), for: .normal)
        
        // 유니버스 추가 개수 변화
        if buttonIsSelected == 1 && universeButton.isSelected == true {
            universeCount += 1
            buttonIsSelected = 0
        } else if buttonIsSelected == 0 && universeButton.isSelected == true {
            universeCount -= 1
            buttonIsSelected = 1
        }
        
        
    }
}
