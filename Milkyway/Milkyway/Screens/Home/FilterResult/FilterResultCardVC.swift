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
    var buttonIsSelected: Bool = true
    //var addStateUniverse = UniverseOn(from: )
    var plusUniverse: AddUniverse?
    var infoUniverse: UniverseOn?
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
        
        addMyUniverse(15592715)
        universeButton.setImage(UIImage(named: "btnUniverseAdded"), for: .normal)
        buttonIsSelected = false
        
    }
    @objc func addMyUniverse(_ cafeId: Int){
        UniverseService.shared.addUniverse(cafeId) {
            (responseData) in
            
            switch responseData {
            case.success(let res):
                dump(res)
                self.plusUniverse = res as? AddUniverse
                self.infoUniverse = self.plusUniverse?.universeOn[0]
                self.universeCountLabel.text = String(self.plusUniverse?.universeCount ?? 0)
                print("success")
                
            case.requestErr(_):
                print("requestErr")
                
            case .pathErr:
                print("pathErr")
                
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print(".failureErr")
            }
        }
    }
    func deleteUniverse(){
        
        universeButton.setImage(UIImage(named: "btnUniverse"), for: .normal)
        buttonIsSelected = true
    
    }
}
