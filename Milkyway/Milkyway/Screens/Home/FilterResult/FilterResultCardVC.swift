//
//  FilterResultCardVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/08.
//

import UIKit

class FilterResultCardVC: UIViewController {

    @IBOutlet var rootView: UIView!
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var cafeTimeLabel: UILabel!
    @IBOutlet weak var universeButton: UIButton!
    @IBOutlet weak var universeCountLabel: UILabel!
    
    var universeCount = 0 // 서버 위키 추후에 다시 참고할 것. 일단 박아놓은 값
    var buttonIsSelected: Bool = true
    var cafeId: Int? // 나중에 받아온 아이디값 넣어주면 된다
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setUniverseButton()
        rootView.layer.cornerRadius = 12
    }

}

extension FilterResultCardVC {
    
    func setView(){
        
        
    }
    
    func setUniverseButton(){
        
        print(#function)
        universeButton.addTarget(self, action: #selector(universeButtonDidTap), for: .touchUpInside)
        universeButton.setImage(UIImage(named: "btnUniverse"), for: .normal)
      
        
        
        
    }
    
    @objc func universeButtonDidTap(){
        
        buttonIsSelected ? addUniverse() : deleteUniverse()
        print(#function)
        print(buttonIsSelected)
    }
    
    func addUniverse(){
        // 유니버스 추가하는 서버 통신 연결
        // 임시 카페아이디
        addMyUniverse(60050010)
        
     
        universeButton.setImage(UIImage(named: "btnUniverseAdded"), for: .normal)
        buttonIsSelected = false
        
    }

    
    @objc func addMyUniverse(_ cafeId: Int){
        UniverseService.shared.addUniverse(cafeId) {
            (responseData) in
            
            switch responseData {
            case.success(let res):
              
                let addUniverse = res as? AddUniverse
             
                dump(addUniverse)
                self.universeCountLabel.text = String(addUniverse?.universeCount ?? 0)
               
                print("success")
                
            case.requestErr(_):
                print("requestErr")
                
            case .pathErr:
                print("pathErr")
                
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print(".networkFail")
            }
        }
        

    }
    
    func deleteUniverse(){
        
        deleteMyUniverse(60050010)
        universeButton.setImage(UIImage(named: "btnUniverse"), for: .normal)
        buttonIsSelected = true
    
    }
    
    @objc func deleteMyUniverse(_ cafeId: Int){
        UniverseService.shared.deleteUniverse(cafeId) {
            (responseData) in
            
            switch responseData {
            case.success(let res):
                let deleteUniverse = res as? ThrowUniverse
                self.universeCountLabel.text = String(deleteUniverse?.universeCount ?? 0)
            dump(deleteUniverse)
                
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print(".networkFail")
            }
        }
        
    }
 
}
