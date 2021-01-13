//
//  DetailCafeMenuVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/04.
//

import UIKit
import SafariServices
import Alamofire

class DetailCafeMenuVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMyUniverseBtn: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var universeImageView: UIImageView!
    
    
    // 일단 더미로 넣어놓은 데이터 ,,,
    var testCafe = CafeDatas(cafeInfo: CafeInfo(id: 0, cafeName: "", cafeAddress: "", businessHours: "", cafePhoneNum: "", cafeLink: "", honeyTip: [], universeCount: 0, isUniversed: 0), menu: [])
    
    
    let cafeMenu = ["무지방우유","저지방우유","두유","디카페인"]
    var like: Bool = false
    
    
    // MARK: - 뷰

    override func viewDidLoad() {
        
        super.viewDidLoad()
        delegateFunc()
        cellResister()
        notiGather()
        print(testCafe)
        likeLabel.text = "\(testCafe.cafeInfo.universeCount)"
        universeImageView.image = like ? UIImage(named: "btnUniverseAdded") : UIImage(named: "btnUniverse")
    }
    
    @IBAction func addMyUniverseBtnClicked(_ sender: Any) {
        addMyUniverseBtn.isEnabled = false
        like ? iHateYou() : iLoveYou()
        tableView.reloadSections(IndexSet(0...0), with: .none)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


// 어떤 '동작'을 할 지 정해주는 부분
// 이 row를 선택하면 어떤 일을 할까요?
extension DetailCafeMenuVC: UITableViewDelegate {
    
    
}


// 테이블 뷰의 뷰를 그려주는 역할
// 어떤 정보를 그려줄 건가요?
extension DetailCafeMenuVC: UITableViewDataSource {
    
    
    // section 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // section 별 행 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 1
        }
        else {
            return testCafe.menu.count
        }
    }
    
    
    // section 행의 높이 -> 나중에는 이렇게 말고 ...
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 350
        }
        else if indexPath.section == 1 {
            return 260
        }
        else {
            return 70
        }
    }
    
    // cell 그려주기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 { // cafe 기본정보
            
            
            guard let cell: CafeBasicCell = tableView.dequeueReusableCell(withIdentifier: "CafeBasicCell" , for: indexPath) as? CafeBasicCell else{
                return UITableViewCell()
            }
            cell.modifyBtn.addTarget(self, action: #selector(modifyBtnClicked), for: .touchUpInside)
            cell.cafeNameLabel.text = testCafe.cafeInfo.cafeName
            cell.howManyLikeLabel.text = "\(testCafe.cafeInfo.universeCount)명의 밀키들이 유니버스에 추가했어요"
            cell.locationLabel.text = testCafe.cafeInfo.cafeAddress
            cell.openTimeLabel.text = testCafe.cafeInfo.businessHours
            cell.telNumBtn.setTitle(testCafe.cafeInfo.cafePhoneNum, for: .normal)
            cell.webPageBtn.setTitle(testCafe.cafeInfo.cafeLink, for: .normal)
            if testCafe.cafeInfo.cafeLink == nil || testCafe.cafeInfo.cafeLink == "" {
                cell.webPageBtn.setTitle(" 제공되는 카페 링크가 없습니다.", for: .normal)
            }
            if testCafe.cafeInfo.cafePhoneNum == nil || testCafe.cafeInfo.cafePhoneNum == "" {
                cell.telNumBtn.setTitle(" 제공되는 카페 번호가 없습니다.", for: .normal)
            }
            cell.selectionStyle = .none // 셀 선택 불가능하게
            
            return cell
        }
        
        else if indexPath.section == 1 { // 밀키의 꿀팁
            guard let cell: CafeHoneyCell = tableView.dequeueReusableCell(withIdentifier: "CafeHoneyCell", for: indexPath) as? CafeHoneyCell else{
                return UITableViewCell()
            }
            
            // 꿀팁 -> 받아온 숫자에 해당하는 라벨 색 변경 (나중에는 이미지 변경으로 바꿀듯?)
            for i in testCafe.cafeInfo.honeyTip {
                (cell.viewWithTag(i) as? UILabel)?.textColor = UIColor(named: "Milky")
                (cell.viewWithTag(i) as? UILabel)?.layer.borderColor = UIColor(named: "Milky")?.cgColor
            }
            
            cell.selectionStyle = .none // 셀 선택 불가능하게
            return cell
        }
        
        else { // 카페 메뉴
            guard let cell: CafeMenuCell = tableView.dequeueReusableCell(withIdentifier: "CafeMenuCell", for: indexPath) as? CafeMenuCell else{
                return UITableViewCell()
            }
            
            cell.cafeMenuNameLabel.text = testCafe.menu[indexPath.row].menuName
            cell.categoryLabel.text = ""
            // 메뉴 하단에 선택지 표시
            for i in testCafe.menu[indexPath.row].category {
                cell.categoryLabel.text! += (cafeMenu[i-1] + "  ")
                
            }
            
            // , 원 없이 들어온 거 처리하기
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.locale = .current
            let changeToDouble = Double(testCafe.menu[indexPath.row].price ) ?? 0
            let price = numberFormatter.string(from: NSNumber(value: changeToDouble))!
            
            cell.howMuchLabel.text = price + "원"
            cell.selectionStyle = .none // 셀 선택 불가능하게
            return cell
        }
        
        
    }
}


extension DetailCafeMenuVC {
    
    // 노티 옵저버들
    func notiGather() {
        NotificationCenter.default.addObserver(self, selector: #selector(webPageOpen), name: Notification.Name("webPage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(confirmBtnClicked), name: Notification.Name("modifyConfirm"), object: nil)
    }
    
    // 프로토콜 상속
    func delegateFunc() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    // 셀 등록
    func cellResister() {
        
        // 셀 리소스 파일 가져오기
        let CafeBasicCellNib = UINib(nibName: "CafeBasicCell", bundle: nil)
        let CafeHoneyCellNib = UINib(nibName: "CafeHoneyCell", bundle: nil)
        let CafeMenuCellNib = UINib(nibName: "CafeMenuCell", bundle: nil)
        
        
        // 셀에 리소스 등록
        self.tableView.register(CafeBasicCellNib, forCellReuseIdentifier: "CafeBasicCell")
        self.tableView.register(CafeHoneyCellNib, forCellReuseIdentifier: "CafeHoneyCell")
        self.tableView.register(CafeMenuCellNib, forCellReuseIdentifier: "CafeMenuCell")
    }
    
    
    
    func iLoveYou() {
        
        ToastView.showIn(viewController: self, message: "카페가 나의 유니버스로 들어왔어요.", fromBottom: 40)
        universeImageView.image = UIImage(named: "btnUniverseAdded")
        testCafe.cafeInfo.universeCount += 1
        likeLabel.text = "\(testCafe.cafeInfo.universeCount)"
        likeLabel.textColor = UIColor(named: "Milky")
        likeLabel.font = UIFont(name: "SF Pro Text Bold", size: 8.0)!
        like = true
        
        UniverseService.shared.addUniverse(testCafe.cafeInfo.id) { [self] (networkResult) -> (Void) in
            
            switch networkResult {
            case.success(let res):
              
                let addUniverse = res as? AddUniverse
                dump(addUniverse)
                print("success")
                addMyUniverseBtn.isEnabled = true
                
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
    
    func iHateYou() {
        
        ToastView.showIn(viewController: self, message: "카페가 나의 유니버스를 탈출했어요.", fromBottom: 40)
        universeImageView.image = UIImage(named: "btnUniverse")
        testCafe.cafeInfo.universeCount -= 1
        likeLabel.text = "\(testCafe.cafeInfo.universeCount)"
        likeLabel.textColor = UIColor(named: "darkGrey")
        likeLabel.font = UIFont(name: "SF Pro Text Regular", size: 8.0)!
        like = false
        
        UniverseService.shared.deleteUniverse(testCafe.cafeInfo.id) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? ThrowUniverse {
                    print("success")
                    print(loadData)
                    }
                addMyUniverseBtn.isEnabled = true
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
    
    // 셀에서 webPage버튼 누르면 여기서 실행 ... cell에서는 실행이 안되더라 흑흑
    // cell은 present를 할 수 없어서 그런듯
    @objc func webPageOpen() {
        
        guard let url = URL(string: testCafe.cafeInfo.cafeLink ?? "") else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
        
    }
    
    @objc func modifyBtnClicked() {
        print("modifyBtnClicked()")
        let storyboard = UIStoryboard(name: "InfoModifyReq", bundle: nil)
        if let dvc = storyboard.instantiateViewController(identifier: "InfoModifyReqVC") as? InfoModifyReqVC {
            self.navigationController?.pushViewController(dvc, animated: true)
        }
    }
    
    @objc func confirmBtnClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}








