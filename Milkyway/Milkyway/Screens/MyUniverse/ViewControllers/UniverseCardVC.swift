//
//  UniverseCardVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/09.
//

import UIKit

class UniverseCardVC: UIViewController {
    
    
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var cafeTimeLabel: UILabel!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var wideBtn: UIButton!
    
    var cafeID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDeleteButton()
        setView()
        // Do any additional setup after loading the view.
    }

    @IBAction func wideBtnClicked(_ sender: Any) {
        
        // 눌렀을 때 서버통신 !
        // 통신중일때 더이상 누를 수 없게 // 이중 클릭 방지
        self.wideBtn.isUserInteractionEnabled = false
        
        // 로딩뷰 시작
        NotificationCenter.default.post(name: Notification.Name("startlottieuni"), object: nil)
        
        DetailCafeService.shared.DetailInfoGet(cafeId: cafeID) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? CafeDatas {
                    
                    print("success")
                    
                    let storyboard = UIStoryboard(name: "DetailCafeMenu", bundle: nil)
                    if let dvc = storyboard.instantiateViewController(identifier: "DetailCafeMenuVC") as? DetailCafeMenuVC {
                        dvc.testCafe = loadData
                        dvc.like = true
                        self.navigationController?.pushViewController(dvc, animated: true)
                        // 로딩뷰 끝
                        NotificationCenter.default.post(name: Notification.Name("stoplottieuni"), object: nil)
                        
                        //다시 클릭 활성화
                        self.wideBtn.isUserInteractionEnabled = true
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
            
            
        }
        
    }
}

extension UniverseCardVC {
    
    func setView(){
        rootView.layer.cornerRadius = 12
        rootView.layer.shadowColor = UIColor.black.cgColor
        rootView.layer.shadowOpacity = 0.1
        rootView.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        rootView.layer.shadowRadius = 12
        rootView.layer.masksToBounds = false
        
    }
    
    // MARK: - 유니버스에서 삭제 버튼 눌렸을 때
    func setDeleteButton(){
        DeleteButton.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
    }
    
    @objc func deleteButtonDidTap(){
        // MyUniverVC에 옵저버 있음. -> popup창 띄우기
        NotificationCenter.default.post(name: Notification.Name("removePopUp"), object: nil)
        // 서버통신진행
        
        
    }
    
}
