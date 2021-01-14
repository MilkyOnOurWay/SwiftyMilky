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
    @IBOutlet weak var wideBtn: UIButton!
    
    var universeCount = 0 // 서버 위키 추후에 다시 참고할 것. 일단 박아놓은 값
    var buttonIsSelected: Bool = true
    var cafeId: Int? // 나중에 받아온 아이디값 넣어주면 된다
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setUniverseButton()
       
    }
    
    @IBAction func wideBtnClicked(_ sender: Any) {
        print ( " Home - DetailInfo \(cafeId)" )
        // 눌렀을 때 서버통신 !
        // 통신중일때 더이상 누를 수 없게 // 이중 클릭 방지
        self.wideBtn.isUserInteractionEnabled = false
        
        // 로딩뷰 시작
        NotificationCenter.default.post(name: Notification.Name("startlottiehome"), object: nil)
        
        DetailCafeService.shared.DetailInfoGet(cafeId: cafeId!) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? CafeDatas {
                    
                    print("success")
                    
                    let storyboard = UIStoryboard(name: "DetailCafeMenu", bundle: nil)
                    if let dvc = storyboard.instantiateViewController(identifier: "DetailCafeMenuVC") as? DetailCafeMenuVC {
                        dvc.testCafe = loadData
                        dvc.like = buttonIsSelected
                        self.navigationController?.pushViewController(dvc, animated: true)
                        
                    }
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
            // 로딩뷰 끝
            NotificationCenter.default.post(name: Notification.Name("stoplottiehome"), object: nil)
            //다시 클릭 활성화
            self.wideBtn.isUserInteractionEnabled = true
            
        }
        
        
    }

    
}

extension FilterResultCardVC {
    
    func setView(){
        print("왜 안먹혀 샹")
        rootView.layer.cornerRadius = 12
        rootView.layer.shadowColor = UIColor.black.cgColor
        rootView.layer.shadowOpacity = 0.1
        rootView.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        rootView.layer.shadowRadius = 12
        rootView.layer.masksToBounds = false
        
    }
    
    func setUniverseButton(){
        
        print(#function)
        universeButton.addTarget(self, action: #selector(universeButtonDidTap), for: .touchUpInside)
    }
    
    @objc func universeButtonDidTap(){
        
        universeButton.isEnabled = false
        buttonIsSelected ? deleteUniverse() : addUniverse()
        print(#function)
        print(buttonIsSelected)
    }
    
    func addUniverse(){
        
        print("이건 원래 유니버스 \(buttonIsSelected)였다")
        print("home - addUniverse \(cafeId!)")
        ToastView.showIn(viewController: self, message: "카페가 나의 유니버스로 들어왔어요.", fromBottom: 40)
        universeButton.setImage(UIImage(named: "btnUniverseAdded"), for: .normal)
        universeCount += 1
        universeCountLabel.text = "\(universeCount)"
        universeCountLabel.textColor = UIColor(named: "Milky")
        universeCountLabel.font = UIFont(name: "SF Pro Text Bold", size: 12.0) ?? .systemFont(ofSize: 12.0, weight: .bold)
        buttonIsSelected = true
        
        UniverseService.shared.addUniverse(cafeId!) { [self] (networkResult) -> (Void) in
            
            switch networkResult {
            case.success(let res):
                
                let addUniverse = res as? AddUniverse
                dump(addUniverse)
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
            universeButton.isEnabled = true
            // 전체 리로드
            NotificationCenter.default.post(name: Notification.Name("homeMarkerSet"), object: nil)
        }
        
    }
    
    
    
    func deleteUniverse(){
        print("home - deleteUniverse \(cafeId!)")
        ToastView.showIn(viewController: self, message: "카페가 나의 유니버스를 탈출했어요.", fromBottom: 40)
        universeButton.setImage(UIImage(named: "btnUniverse"), for: .normal)
        universeCount -= 1
        universeCountLabel.text = "\(universeCount)"
        universeCountLabel.textColor = UIColor(named: "darkGrey")
        universeCountLabel.font = UIFont(name: "SF Pro Text Regular", size: 12.0) ?? .systemFont(ofSize: 12.0, weight: .regular)
        buttonIsSelected = false
        
        UniverseService.shared.deleteUniverse(cafeId!) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? ThrowUniverse {
                    print("success")
                    print(loadData)
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
            universeButton.isEnabled = true
            // 전체 리로드
            NotificationCenter.default.post(name: Notification.Name("homeMarkerSet"), object: nil)
        }
        
    }
    
    
    
}


