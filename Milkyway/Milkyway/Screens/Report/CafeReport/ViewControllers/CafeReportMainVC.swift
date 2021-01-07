//
//  CafeReportMainVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/02.
//

import UIKit
import XLPagerTabStrip

class CafeReportMainVC: UIViewController, IndicatorInfoProvider {
    @IBOutlet weak var tableView: UITableView!
    var tabName: String = ""
    
    let cafeMenu = ["디카페인","두유","저지방우유","무지방우유"]
    
    var cafeMenus = [CafeMenu]()
    var cafeInfo: CafeInfo?
    var editIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegateFunc()
        cellResister()
        notiGather()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func resetBtnClicked(_ sender: Any) {
        cafeInfo = nil
        cafeMenus = []
        NotificationCenter.default.post(name: Notification.Name("removeHoneyTips"), object: nil)
        ToastView.showIn(viewController: self, message: "입력했던 정보가 초기화되었습니다.", fromBottom: 10)
        tableView.reloadData()
    }
    
    
    
    
}

extension CafeReportMainVC: UITableViewDelegate {
    
}

extension CafeReportMainVC: UITableViewDataSource {
    
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
            return cafeMenus.count
        }
        else {
            return 1
        }
    }
    
    
    // section 행의 높이 -> 나중에는 이렇게 말고 ...
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        }
        else if indexPath.section == 1 {
            return 90
        }
        else {
            return 250
        }
    }
    
    // cell 그려주기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 { // cafe 명
            if cafeInfo == nil { // 검색 전
                guard let cell: CafeNameSearchCell = tableView.dequeueReusableCell(withIdentifier: "CafeNameSearchCell" , for: indexPath) as? CafeNameSearchCell else{
                    return UITableViewCell()
                }
                return cell
                
            }
            
            else { // 검색해서 값이 있을 경우
                guard let cell: CafeNameResultCell = tableView.dequeueReusableCell(withIdentifier: "CafeNameResultCell" , for: indexPath) as? CafeNameResultCell else{
                    return UITableViewCell()
                }
                
                
                return cell
            }
            
        }
        
        else if indexPath.section == 1 { // cafe 메뉴
            guard let cell: CafeMenusCell = tableView.dequeueReusableCell(withIdentifier: "CafeMenusCell", for: indexPath) as? CafeMenusCell else{
                return UITableViewCell()
            }
            
            cell.menuNameLabel.text = cafeMenus[indexPath.row].menu
            cell.menuSelectionLabel.text = ""
            // 메뉴 하단에 선택지 표시
            for i in cafeMenus[indexPath.row].selection {
                cell.menuSelectionLabel.text! += (cafeMenu[i-1] + "  ")
                
            }
            
            cell.menuPriceLabel.text = cafeMenus[indexPath.row].price + " 원"
            cell.selectionStyle = .none // 셀 선택 불가능하게
            
            cell.deleteModifyBtnAction = { [unowned self] in
                let menu = self.cafeMenus[indexPath.row].menu
                let actionSheet = UIAlertController(title: "메뉴를 수정 및 삭제합니다", message: "\(menu)", preferredStyle: .actionSheet)
                
                actionSheet.addAction(UIAlertAction(title: "수정", style: .default, handler: { result in
                    editIndex = indexPath.row
                    NotificationCenter.default.post(name: Notification.Name("gotomenuEdit"), object: cafeMenus[indexPath.row])
                    
                }))
                actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { result in
                    cafeMenus.remove(at: indexPath.row)
                    tableView.reloadSections(IndexSet(1...1), with: .fade)
                    
                }))
                actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                
                self.present(actionSheet, animated: true, completion: nil)

              
                }
            
            
            return cell
            
        }
        
        else { // 밀키의 꿀팁
            guard let cell: HoneyTipCell = tableView.dequeueReusableCell(withIdentifier: "HoneyTipCell", for: indexPath) as? HoneyTipCell else{
                return UITableViewCell()
            }
            
            return cell
        }
        
        
    }
}

extension CafeReportMainVC {
    
    func notiGather() {
        NotificationCenter.default.addObserver(self, selector: #selector(menuPlus(_:)), name: Notification.Name("menuPlus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeBeforeMenu), name: Notification.Name("remove"), object: nil)
    }
    
    
    // 프로토콜 상속
    func delegateFunc() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    // 셀 등록
    func cellResister() {
        
        // 셀 리소스 파일 가져오기
        let CafeNameSearchCellNib = UINib(nibName: "CafeNameSearchCell", bundle: nil)
        let CafeNameResultCellNib = UINib(nibName: "CafeNameResultCell", bundle: nil)
        let CafeMenusCellNib = UINib(nibName: "CafeMenusCell", bundle: nil)
        let HoneyTipCellNib = UINib(nibName: "HoneyTipCell", bundle: nil)
        
        
        // 셀에 리소스 등록
        self.tableView.register(CafeNameSearchCellNib, forCellReuseIdentifier: "CafeNameSearchCell")
        self.tableView.register(CafeNameResultCellNib, forCellReuseIdentifier: "CafeNameResultCell")
        self.tableView.register(CafeMenusCellNib, forCellReuseIdentifier: "CafeMenusCell")
        self.tableView.register(HoneyTipCellNib, forCellReuseIdentifier: "HoneyTipCell")
    }
    
    @objc func menuPlus(_ noti: NSNotification) {
        cafeMenus.append(noti.object as! CafeMenu) // 옵셔널 처리 나중에는 해줘야함...
        tableView.reloadSections(IndexSet(1...1), with: .automatic)
        
    }
    
    @objc func removeBeforeMenu() {
        cafeMenus.remove(at: editIndex!)
        tableView.reloadSections(IndexSet(1...1), with: .fade)
    }
    
    
    
}




// MARK: - Function
extension CafeReportMainVC {
    
    /// 상단 탭바 관련
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(tabName)")
    }
    
}
