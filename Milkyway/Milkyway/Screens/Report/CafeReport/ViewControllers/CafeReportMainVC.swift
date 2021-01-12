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
    @IBOutlet weak var reportEndBtn: UIButton!
    @IBOutlet weak var reportImageView: UIImageView!

    var tabName: String = ""

    let cafeMenu = ["디카페인","두유","저지방우유","무지방우유"]

    var dummyData = Cafepost(cafeName: "",
                             cafeAddress: "",
                             cafeMapX: 126.8995926,
                             cafeMapY: 37.55638504,
                             honeyTip: [],
                             menu: [])
   
    var editIndex: Int?

    // MARK: - 검색한 결과값(카페이름, 주소)를 여기다가 넣어줄거에요
    var resultCafeName: String?
    var resultCafeAddress: String?
    var latitude: String?
    var longitude: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegateFunc()
        cellResister()
        notiGather()
        getCafe()
        
        print("카페\(resultCafeName)")
        print("카페주소\(resultCafeAddress)")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            return dummyData.menu.count
        }
        else {
            return 1
        }
    }


    // section 행의 높이 -> 나중에는 이렇게 말고 ...
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
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
            if dummyData.cafeName == nil && dummyData.cafeAddress == nil { // 검색 전
                guard let cell: CafeNameSearchCell = tableView.dequeueReusableCell(withIdentifier: "CafeNameSearchCell" , for: indexPath) as? CafeNameSearchCell else{
                    return UITableViewCell()

                }
                cell.searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)

                return cell

            }

            else { // 검색해서 값이 있을 경우
                guard let cell: CafeNameResultCell = tableView.dequeueReusableCell(withIdentifier: "CafeNameResultCell" , for: indexPath) as? CafeNameResultCell else{
                    return UITableViewCell()
                }

                cell.cafeNameLabel.text = dummyData.cafeName
                cell.cafeAddressLabel.text = dummyData.cafeAddress

                cell.searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
                return cell
            }

        }

        else if indexPath.section == 1 { // cafe 메뉴
            guard let cell: CafeMenusCell = tableView.dequeueReusableCell(withIdentifier: "CafeMenusCell", for: indexPath) as? CafeMenusCell else{
                return UITableViewCell()
            }

            cell.menuNameLabel.text = dummyData.menu[indexPath.row].menuName
            cell.menuSelectionLabel.text = ""
            // 메뉴 하단에 선택지 표시
            for i in dummyData.menu[indexPath.row].category {
                cell.menuSelectionLabel.text! += (cafeMenu[i-1] + "  ")

            }

            cell.menuPriceLabel.text = dummyData.menu[indexPath.row].price + " 원"
            cell.selectionStyle = .none // 셀 선택 불가능하게


            // 수정/삭제 버튼 눌렸을 때
            cell.deleteModifyBtnAction = { [unowned self] in
                let menu = self.dummyData.menu[indexPath.row].menuName
                let actionSheet = UIAlertController(title: "메뉴를 수정 및 삭제합니다", message: "\(menu)", preferredStyle: .actionSheet)

                actionSheet.addAction(UIAlertAction(title: "수정", style: .default, handler: { result in
                    editIndex = indexPath.row
                    NotificationCenter.default.post(name: Notification.Name("gotomenuEdit"), object: dummyData.menu[indexPath.row])


                }))
                actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { result in
                    dummyData.menu.remove(at: indexPath.row)
                    tableView.reloadSections(IndexSet(1...1), with: .fade)
                    checkReportOK()

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

    func getCafe(){
        
        dummyData.cafeName = resultCafeName
        dummyData.cafeAddress = resultCafeAddress
        
        
    }
    func notiGather() {
        NotificationCenter.default.addObserver(self, selector: #selector(menuPlus(_:)), name: Notification.Name("menuPlus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeBeforeMenu), name: Notification.Name("remove"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetEveryInfo), name: Notification.Name("cafeReset"), object: nil)
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

    // 제보완료 가능한지 ?
    func checkReportOK() {

        if dummyData.menu.count > 0 {
            reportImageView.image = UIImage(named: "btnReport")
            reportEndBtn.isUserInteractionEnabled = true
        }
        else {
            reportImageView.image = UIImage(named: "btnReportOff")
            reportEndBtn.isUserInteractionEnabled = false
        }

    }

    /// 노티관련

    // 메뉴가 추가되면 실행된다.
    // noti로 받아온 메뉴를 cafeMenus에 추가해주고, 테이블뷰 메뉴 섹션을 reload 해준다.
    @objc func menuPlus(_ noti: NSNotification) {
        dummyData.menu.append(noti.object as! Menu) // 옵셔널 처리 나중에는 해줘야함...
        tableView.reloadSections(IndexSet(1...1), with: .automatic)
        checkReportOK()

    }

    // 메뉴 수정 버튼을 누르고 입력 완료를 누르면 이전에 있던 정보는 삭제해줘야한다 !!!
    @objc func removeBeforeMenu() {
        dummyData.menu.remove(at: editIndex!)
        tableView.reloadSections(IndexSet(1...1), with: .fade)
    }


    // 제보를 완료하면 내용물을 전부 없애버려야한다 (서버통신 위치를 잘 잡아야할듯)
    @objc func resetEveryInfo() {
        dummyData.cafeName = nil
        dummyData.cafeAddress = nil
        dummyData.honeyTip = []
        dummyData.menu = []
        checkReportOK()
        tableView.reloadData()
    }

    @objc func searchButtonDidTap(){

        guard let nvc = UIStoryboard(name: "AddSearch", bundle: nil).instantiateViewController(identifier: "AddSearchVC") as? AddSearchVC else {
            return
        }
        self.navigationController?.pushViewController(nvc, animated: true)

    }


    @IBAction func resetBtnClicked(_ sender: Any) {
        resetEveryInfo()
        NotificationCenter.default.post(name: Notification.Name("removeHoneyTips"), object: nil)
        ToastView.showIn(viewController: self, message: "입력했던 정보가 초기화되었습니다.", fromBottom: 10)
    }


    @IBAction func reportCompleteClicked(_ sender: Any) {

        ReportCafeService.shared.ReportCafe(cafepost: dummyData) { responseData in
            switch responseData {
            case .success(let res):
                print("success")
                print(res)
            case .requestErr(_):
                print("request error")
            case .pathErr:
                print(".pathErr")
            case .serverErr:
                print(".serverErr")
            case .networkFail:
                print("failure")
            }


        }

    }
}




// MARK: - Function
extension CafeReportMainVC {

    /// 상단 탭바 관련
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(tabName)")
    }

}
