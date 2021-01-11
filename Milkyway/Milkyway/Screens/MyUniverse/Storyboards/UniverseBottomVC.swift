//
//  UniverseBottomVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/10.
//

import UIKit

class UniverseBottomVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var handleBar: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    
    var bottomCafeInfo = HomeData(aroundCafe: [AroundCafe](), nickName: "")
    
    
    var count = 5
    
    override func viewDidLoad() {
        emptyView.isHidden = true
        
        super.viewDidLoad()
        setView()
        setHandler()
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeBeforeCafe), name: Notification.Name("removeCafe"), object: nil)
        
        
        let BottomCellNib = UINib(nibName: "BottomTVC", bundle: nil)
        self.tableView.register(BottomCellNib, forCellReuseIdentifier: "BottomTVC")
        emptyLabel.text = "아직 유니버스에 담긴 카페가 없어요.\n마음에 드는 카페를 담으면\n소영님의 빛나는 유니버스를 만날 수 있어요!"
        
    }
    
}


extension UniverseBottomVC {
    
    func setView() {
        rootView.layer.cornerRadius = 12
        
        rootView.layer.shadowColor = UIColor.black.cgColor
        rootView.layer.shadowOpacity = 0.1
        rootView.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        rootView.layer.shadowRadius = 12
        rootView.layer.masksToBounds = false
    }
    func setHandler() {
        handleBar.layer.cornerRadius = handleBar.frame.height / 2
        
        
    }
    
    @objc func removeBeforeCafe() {
        count -= 1
        tableView.reloadData()
    }
}

extension UniverseBottomVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 눌렀을 때 서버통신 !
        // 통신중일때 더이상 나의제보 누를 수 없게 // 이중 클릭 방지
        self.tableView.isUserInteractionEnabled = false
        
        print(indexPath.row)
        NotificationCenter.default.post(name: Notification.Name("startlottieuni"), object: nil)
        DetailCafeService.shared.DetailInfoGet(cafeId: 17) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? CafeDatas {
                    
                    print("success")
                    let storyboard = UIStoryboard(name: "DetailCafeMenu", bundle: nil)
                    if let dvc = storyboard.instantiateViewController(identifier: "DetailCafeMenuVC") as? DetailCafeMenuVC {
                        dvc.testCafe = loadData
                        self.navigationController?.pushViewController(dvc, animated: true)
                        NotificationCenter.default.post(name: Notification.Name("stoplottieuni"), object: nil)
                        //다시 클릭 활성화
                        self.tableView.isUserInteractionEnabled = true
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



extension UniverseBottomVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if count == 0 {
            emptyView.isHidden = false
            return 0
        }
        else {
            emptyView.isHidden = true
            return count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: BottomTVC = tableView.dequeueReusableCell(withIdentifier: "BottomTVC" , for: indexPath) as? BottomTVC else{
            return UITableViewCell()
            
        }
        
        cell.deleteBtnAction = { [unowned self] in
            
            editIndex = indexPath.row
            NotificationCenter.default.post(name: Notification.Name("removePopUp"), object: nil)
            
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}
