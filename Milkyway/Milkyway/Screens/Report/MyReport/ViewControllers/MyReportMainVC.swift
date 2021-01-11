//
//  MyReportMainVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/02.
//

import UIKit
import XLPagerTabStrip

class MyReportMainVC: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet var myReportTableView: UITableView!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    
    var tabName: String = ""
    
    // 테이블 셀 hidden 테스트용
    var cancelArr: [String] = []
    var inProgressArr: [String] = []
    var completedArr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        notiGather()
        registerXib()
        registerDelegate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Function
extension MyReportMainVC {
    
    /// 상단 탭바 관련
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(tabName)")
    }
    
    func setLabel() {
        mainLabel.text = "제보한 장소를 확인하는 공간입니다"
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont(name: "SFProText-Semibold", size: 20.0)
        
        subLabel.text = "나만의 카페를 제보하고\n더욱 풍성해진 밀키웨이를 탐험해 보세요!"
        subLabel.textAlignment = .center
        subLabel.font = UIFont(name: "SFProText-Regular", size: 12.0)
        subLabel.numberOfLines = 2
    }
    func notiGather() {
        NotificationCenter.default.addObserver(self, selector: #selector(cancelReasonTap), name: Notification.Name("cancelReason"), object: nil)
    }
    func registerDelegate() {
        myReportTableView.dataSource = self
        myReportTableView.delegate = self
    }
    func registerXib() {
        let topTVCellNib = UINib(nibName: "TopTVCell", bundle: nil)
        let inProgressTVCellNib = UINib(nibName: "InProgressTVCell", bundle: nil)
        let completedTVCellNib = UINib(nibName: "CompletedTVCell", bundle: nil)
        let canceledTVCellNib = UINib(nibName: "CanceledTVCell", bundle: nil)
        
        // 맨위 닉네임
        myReportTableView.register(topTVCellNib, forCellReuseIdentifier: "TopTVCell")
        // 취소된 제보
        myReportTableView.register(canceledTVCellNib, forCellReuseIdentifier: "CanceledTVCell")
        // 진행 중인 제보
        myReportTableView.register(inProgressTVCellNib, forCellReuseIdentifier: "InProgressTVCell")
        // 완료된 제보
        myReportTableView.register(completedTVCellNib, forCellReuseIdentifier: "CompletedTVCell")
    }
    @objc func cancelReasonTap() {
        print("MyReport - cancelReason")
        
        guard let cancelVC = UIStoryboard(name: "MyReportMain", bundle: nil).instantiateViewController(withIdentifier:"CancelReasonVC") as? CancelReasonVC else {
            return
        }
        cancelVC.modalPresentationStyle = .overCurrentContext
        present(cancelVC, animated: false, completion: nil)
    }
}

extension MyReportMainVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2{
            return 1
        } else {
            return 1 // 서버에서 받는대로
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 다 비어있으면 테이블 숨기고 안내 화면 보여주기
//        tableView.isHidden = true
        
        
        // 일단 이렇게 박아두기,,
        if indexPath.section == 0 { //닉네임
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopTVCell.identifier) as? TopTVCell else {
                return UITableViewCell()
            }
            cell.setCell(nickName: "열매열매")
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 { //취소된 제보
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CanceledTVCell.identifier) as? CanceledTVCell else {
                return UITableViewCell()
            }
            // 취소된 제보 없애면 hidden하고 높이 0 만들기
//            if cancelArr.count == 0 {
//                cell.isHidden = true
//                cell.rootHeight.constant = 0
//            }
            
            cell.setCell(count: 2) //cancelArr.count)
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 2 { // 진행중인 제보
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InProgressTVCell.identifier) as? InProgressTVCell else {
                return UITableViewCell()
            }
            
            cell.setLabel()
            cell.setCell(count: 0)
            cell.selectionStyle = .none
            return cell
        } else { // 완료된 제보
            if completedArr.count == 0 {
                let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
                cell.textLabel!.text = "\n\n현재 완료된 제보가 없습니다!"
                cell.textLabel!.numberOfLines = 3
                cell.textLabel!.textAlignment = .center
                cell.textLabel!.textColor = UIColor(named: "darkGrey")
                cell.textLabel!.font = UIFont(name: "SFProText-Regular", size: 16.0)
                cell.selectionStyle = .none
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CompletedTVCell.identifier) as? CompletedTVCell else {
                    return UITableViewCell()
                }
                cell.setCardView()
                cell.setLabel()
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
}


extension MyReportMainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 눌렀을 때 서버통신 !
        // 통신중일때 더이상 나의제보 누를 수 없게 // 이중 클릭 방지
        self.myReportTableView.isUserInteractionEnabled = false
        
        // 로딩뷰 시작
        NotificationCenter.default.post(name: Notification.Name("startlottie"), object: nil)
        
        DetailCafeService.shared.DetailInfoGet(cafeId: 17) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? CafeDatas {
                    
                    print("success")
                    
                    let storyboard = UIStoryboard(name: "DetailCafeMenu", bundle: nil)
                    if let dvc = storyboard.instantiateViewController(identifier: "DetailCafeMenuVC") as? DetailCafeMenuVC {
                        dvc.testCafe = loadData
                        self.navigationController?.pushViewController(dvc, animated: true)
                        // 로딩뷰 끝
                        NotificationCenter.default.post(name: Notification.Name("stoplottie"), object: nil)
                        
                        //다시 클릭 활성화
                        self.myReportTableView.isUserInteractionEnabled = true
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
