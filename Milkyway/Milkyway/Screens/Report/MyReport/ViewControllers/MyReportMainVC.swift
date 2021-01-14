//
//  MyReportMainVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/02.
//

import UIKit
import XLPagerTabStrip
import Lottie

class MyReportMainVC: UIViewController, IndicatorInfoProvider {
    
    
    @IBOutlet var myReportTableView: UITableView!
    // 테이블 숨기고 나오는 뷰
    
    @IBOutlet var emptyView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    
    
    var tabName: String = ""
    var nickName: String = ""
    
    var myReportData = MyReportData(cancel: [MyReport](),
                                    ing: [MyReport](),
                                    done: [MyReport]())

    override func viewDidLoad() {
        super.viewDidLoad()
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
        myReportTableView.reloadData()
    }
    
    
    // MARK: - 데이터 로딩 중 Lottie 화면
    
    let loadingView = AnimationView(name: "loadingLottie")
    
    @objc private func showLoadingLottie() {
        print("start")
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        loadingView.center = self.view.center
        loadingView.contentMode = .scaleAspectFill
        loadingView.loopMode = .loop
        self.view.addSubview(loadingView)
        
        loadingView.play()
    }
    
    
    @objc private func stopLottieAnimation() {
        print("end")
        loadingView.stop()
        loadingView.removeFromSuperview()
    }
}

// MARK: - Function
extension MyReportMainVC {
    
    /// 상단 탭바 관련
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(tabName)")
    }
    
    // empty view auto
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
    
    func notiGather() {
        NotificationCenter.default.addObserver(self, selector: #selector(cancelReasonTap(_:)), name: Notification.Name("cancelReason"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: Notification.Name("cancelConfirm"), object: nil)
        
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
        
        // 맨위 닉네임, 취소된 제보, 진행 중인 제보, 완료된 제보
        myReportTableView.register(topTVCellNib, forCellReuseIdentifier: "TopTVCell")
        myReportTableView.register(canceledTVCellNib, forCellReuseIdentifier: "CanceledTVCell")
        myReportTableView.register(inProgressTVCellNib, forCellReuseIdentifier: "InProgressTVCell")
        myReportTableView.register(completedTVCellNib, forCellReuseIdentifier: "CompletedTVCell")
    }
    func setService() {
        showLoadingLottie()
        print("my report setService")
        MyReportService.shared.GetMyReport() { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? MyReportData {
                    print("success")
                    myReportData = loadData
                    // 유저닉네임 전역변수로 설정
                    let ad = UIApplication.shared.delegate as? AppDelegate
                    nickName = (ad?.userNickNameInHere)!
                    
                    self.myReportTableView.reloadData()
                    if myReportData.cancel.isEmpty && myReportData.ing.isEmpty && myReportData.done.isEmpty {
                        myReportTableView.isHidden = true
                        emptyView.isHidden = false
                    } else {
                        myReportTableView.isHidden = false
                        emptyView.isHidden = true
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
            stopLottieAnimation()
        }
        
    }
    
    // 취소된 제보 탭하면 cancelReasonVC로 넘어가기
    @objc func cancelReasonTap(_ noti: NSNotification) {
        print("MyReport - cancelReason")
        guard let cancelVC = UIStoryboard(name: "MyReportMain", bundle: nil).instantiateViewController(withIdentifier:"CancelReasonVC") as? CancelReasonVC else {
            return
        }
        let getInfo = noti.object as! [Int]
        cancelVC.rejectReasonId = getInfo[0]
        cancelVC.cafeId = getInfo[1]
//        cancelVC.modalPresentationStyle = .overCurrentContext
        cancelVC.modalPresentationStyle = .overFullScreen
        cancelVC.modalTransitionStyle = .crossDissolve
        present(cancelVC, animated: true, completion: nil)
        self.myReportTableView.reloadData()
    }
    
    @objc func reloadTable() {
        myReportTableView.reloadData()
    }
}

extension MyReportMainVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            if myReportData.cancel.count == 0 {
                return 0
            } else {
                return 1
            }
        case 2:
            return 1
        default:
            if myReportData.done.count == 0 {
                return 1
            } else {
                return myReportData.done.count
            }
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: // 닉네임 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopTVCell.identifier) as? TopTVCell else {
                return UITableViewCell()
            }
            cell.setCell(nickName: nickName)
            cell.selectionStyle = .none
            return cell
        case 1: // 취소된 제보
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CanceledTVCell.identifier) as? CanceledTVCell else {
                return UITableViewCell()
            }
            cell.setCell(cancelData: myReportData.cancel)
            print(myReportData.cancel)
            cell.selectionStyle = .none
            return cell
        case 2: // 진행중인 제보
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InProgressTVCell.identifier) as? InProgressTVCell else {
                return UITableViewCell()
            }
            if myReportData.ing.count == 0 {
                cell.collectionView.isHidden = true
                cell.setLabel()
            } else {
                cell.collectionView.isHidden = false
                cell.setCell(ingData: myReportData.ing)
            }
            cell.selectionStyle = .none
            return cell
        default: // 완료된 제보
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
                cell.setCell()
                cell.setCategory(category: myReportData.done[indexPath.row].category!)
                
                // 시간 date formatt
                let originAddTime = myReportData.done[indexPath.row].createdAt
                let formattedTime = originAddTime.getDateFormat(time: originAddTime)
              
                cell.dateLabel.text = formattedTime
                    
                cell.cafeNameLabel.text = myReportData.done[indexPath.row].cafeName
                cell.addressLabel.text = myReportData.done[indexPath.row].cafeAddress
                
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
}


extension MyReportMainVC: UITableViewDelegate {
    /// 상세페이지와 연결되는 부분
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
