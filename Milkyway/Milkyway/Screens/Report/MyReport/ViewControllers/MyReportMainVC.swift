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
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    
    
    var tabName: String = ""
    var nickName: String = ""
    var rejectReason = 0
    
    var myReportData = MyReportData(cancel: [MyReport](),
                                    ing: [MyReport](),
                                    done: [MyReport]())

    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        setAuto()
        notiGather()
        registerXib()
        registerDelegate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        setService()
    }
    func setAuto() {
        let margins = view.layoutMarginsGuide
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 143.0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40.0).isActive = true
        mainLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16.0).isActive = true
        subLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
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
    func setService() {
        print("my report setService")
        MyReportService.shared.GetMyReport() { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? MyReportData {
                    print("success")
                    myReportData = loadData
                    // 유저닉네임 전역변수로 설정
//                    let ad = UIApplication.shared.delegate as? AppDelegate
//                    ad?.userNickNameInHere =
//                    print("table 들어옴")
                    self.myReportTableView.reloadData()
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
    @objc func cancelReasonTap(_ sender: UITableView) {
        print("MyReport - cancelReason")
        guard let cancelVC = UIStoryboard(name: "MyReportMain", bundle: nil).instantiateViewController(withIdentifier:"CancelReasonVC") as? CancelReasonVC else {
            return
        }
        cancelVC.rejectReasonId = rejectReason
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
            return myReportData.done.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 다 비어있으면 테이블 숨기고 안내 화면 보여주기
//        if myReportData.cancel.isEmpty && myReportData.ing.isEmpty && myReportData.done.isEmpty {
//            tableView.isHidden = true
//        }
        
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
            cell.setCell(cancelData: myReportData.cancel)
            print(myReportData.cancel)
//            rejectReason = myReportData.cancel[indexPath.row].rejectReasonID!
            
            print("여긴 취소된 제본데요,,\(myReportData.cancel.count)")
            // 취소된 제보 없애면 hidden하고 높이 0 만들기
//            if myReportData.cancel.count == 0 {
//                cell.isHidden = true
//                cell.rootHeight.constant = 0
//            } else {
//
//            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 2 { // 진행중인 제보
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InProgressTVCell.identifier) as? InProgressTVCell else {
                return UITableViewCell()
            }
            cell.setLabel()
            print("여긴 진행중인 제본데요,,\(myReportData.ing.count)")
            cell.setCell(ingData: myReportData.ing)
            cell.selectionStyle = .none
            return cell
        } else { // 완료된 제보
            if myReportData.done.count == 0 {
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
                cell.setCell(category: myReportData.done[indexPath.row].category!)
                cell.dateLabel.text = myReportData.done[indexPath.row].createdAt
                cell.cafeNameLabel.text = myReportData.done[indexPath.row].cafeName
                cell.addressLabel.text = myReportData.done[indexPath.row].cafeAddress
                
//                let category = myReportData.done[indexPath.row].category!
                print(myReportData.done[indexPath.row].category!.count)
//                for i in 0...myReportData.done[indexPath.row].category!.count-1 {
//                    cell.viewWithTag(category[i])?.isHidden = false
//                }
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
}


extension MyReportMainVC: UITableViewDelegate {
    /// 상세페이지와 연결되는 부분
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("indexPath.row : \(indexPath.row)")
        if indexPath.section == 3 {
            
            // 눌렀을 때 서버통신 !
            // 통신중일때 더이상 나의제보 누를 수 없게 // 이중 클릭 방지
            self.myReportTableView.isUserInteractionEnabled = false
            
            // 로딩뷰 시작
            NotificationCenter.default.post(name: Notification.Name("startlottie"), object: nil)
            
            DetailCafeService.shared.DetailInfoGet(cafeId: myReportData.done[indexPath.row].id ) { [self] (networkResult) -> (Void) in
                switch networkResult {
                case .success(let data):
                    if let loadData = data as? CafeDatas {
                        
                        print("success")
                        let storyboard = UIStoryboard(name: "DetailCafeMenu", bundle: nil)
                        if let dvc = storyboard.instantiateViewController(identifier: "DetailCafeMenuVC") as? DetailCafeMenuVC {
                            dvc.testCafe = loadData
                            dvc.like = loadData.cafeInfo.isUniversed == 1 ? true : false
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
}
