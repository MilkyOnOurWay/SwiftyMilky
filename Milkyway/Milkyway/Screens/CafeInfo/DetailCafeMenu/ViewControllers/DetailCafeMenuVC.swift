//
//  DetailCafeMenuVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/04.
//

import UIKit
import SafariServices

class DetailCafeMenuVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var testCafe = Cafe()
    let cafeMenu = ["무지방우유","저지방우유","두유","디카페인"]
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        delegateFunc()
        cellResister()
        cafeInit()
        notiGather()
        
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
            return testCafe.menus.count
        }
    }
    
    
    // section 행의 높이 -> 나중에는 이렇게 말고 ...
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 350
        }
        else if indexPath.section == 1 {
            return 250
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
            cell.cafeNameLabel.text = testCafe.cafeName
            cell.howManyLikeLabel.text = "\(testCafe.likeNum)명의 밀키들이 유니버스에 추가했어요"
            cell.locationLabel.text = testCafe.address
            cell.openTimeLabel.text = testCafe.openTime
            cell.telNumBtn.setTitle(testCafe.telNum, for: .normal)
            cell.webPageBtn.setTitle(testCafe.webPage, for: .normal)
            cell.selectionStyle = .none // 셀 선택 불가능하게
            
            return cell
        }
        
        else if indexPath.section == 1 { // 밀키의 꿀팁
            guard let cell: CafeHoneyCell = tableView.dequeueReusableCell(withIdentifier: "CafeHoneyCell", for: indexPath) as? CafeHoneyCell else{
                return UITableViewCell()
            }
            
            // 꿀팁 -> 받아온 숫자에 해당하는 라벨 색 변경 (나중에는 이미지 변경으로 바꿀듯?)
            for i in testCafe.honeyTip {
                (cell.viewWithTag(i) as? UILabel)?.textColor = UIColor(named: "Milky")
            }
            
            cell.selectionStyle = .none // 셀 선택 불가능하게
            return cell
        }
        
        else { // 카페 메뉴
            guard let cell: CafeMenuCell = tableView.dequeueReusableCell(withIdentifier: "CafeMenuCell", for: indexPath) as? CafeMenuCell else{
                return UITableViewCell()
            }
            
            cell.cafeMenuNameLabel.text = testCafe.menus[indexPath.row].menuName
            cell.categoryLabel.text = ""
            // 메뉴 하단에 선택지 표시
            for i in testCafe.menus[indexPath.row].selection {
                cell.categoryLabel.text! += (cafeMenu[i-1] + "  ")
                
            }
            
            cell.howMuchLabel.text = testCafe.menus[indexPath.row].price
            cell.selectionStyle = .none // 셀 선택 불가능하게
            return cell
        }
        
        
    }
}

extension DetailCafeMenuVC {
    
    // 노티 옵저버들
    func notiGather() {
        NotificationCenter.default.addObserver(self, selector: #selector(webPageOpen), name: Notification.Name("webPage"), object: nil)
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
    
    // 일단 더미로 넣어놓은 데이터 ,,,
    func cafeInit() {
        testCafe = Cafe(cafeName: "혜리의 17학번이\n뭘잘못했는디카페",
                        likeNum: 324,
                        address: "서울시 종로구 2-12(1층)",
                        openTime: "영업시간: 월-금 9:30 - 21:00\n토,일 9:30 - 20:00",
                        telNum: "090-2931-2304",
                        webPage: "www.lattehyeri.com",
                        honeyTip: [2,5],
                        menus: [
                            Menu(menuName: "혜리쓰소이빈라떼", selection: [3], price: "4,000원"),
                            Menu(menuName: "마다이어트하려면이거마셔라떼", selection: [1,2,3,4], price: "3,800원"),
                            Menu(menuName: "모카모카는행복해", selection: [1,2,4], price: "4,500원")
                        ])
        
    }
    
    // 셀에서 webPage버튼 누르면 여기서 실행 ... cell에서는 실행이 안되더라 흑흑
    // cell은 present를 할 수 없어서 그런듯
    @objc func webPageOpen() {
        
        guard let url = URL(string: "https://blog.naver.com/sso_0022") else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
        
    }
}
