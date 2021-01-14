//
//  CafeReportMainVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/02.
//

import UIKit
import XLPagerTabStrip
import Lottie

class CafeReportMainVC: UIViewController, IndicatorInfoProvider {
    
    
    @IBOutlet var bottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reportEndBtn: UIButton!
    @IBOutlet weak var reportImageView: UIImageView!

    var tabName: String = ""

    let cafeMenu = ["디카페인","두유","저지방우유","무지방우유"]

    var dummyData = Cafepost(cafeName: nil,
                             cafeAddress: nil,
                             longitude: 0,
                             latitude: 0,
                             honeyTip: [],
                             menu: [])
   
    var editIndex: Int?
    var nickName: String?

    // MARK: - 검색한 결과값(카페이름, 주소)를 여기다가 넣어줄거에요
    var resultCafeName: String?
    var resultCafeAddress: String?
    var latitude: String = ""
    var longitude: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAuto()
        delegateFunc()
        cellResister()
        notiGather()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 데이터 로딩 중 Lottie 화면
    
    let loadingView = AnimationView(name: "loadingLottie")
    
    private func showLoadingLottie() {
        print("start")
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        loadingView.center = self.view.center
        loadingView.contentMode = .scaleAspectFill
        loadingView.loopMode = .loop
        self.view.addSubview(loadingView)
        
        loadingView.play()
    }
    
    private func stopLottieAnimation() {
        print("end")
        loadingView.stop()
        loadingView.removeFromSuperview()
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
    
    func notiGather() {
        NotificationCenter.default.addObserver(self, selector: #selector(addressPlus(_:)), name: Notification.Name("addressPlus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(menuPlus(_:)), name: Notification.Name("menuPlus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeBeforeMenu), name: Notification.Name("remove"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetEveryInfo), name: Notification.Name("cafeReset"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(honeyTipAdd(_:)), name: Notification.Name("honeyTips"), object: nil)
    }


    // 프로토콜 상속
    func delegateFunc() {
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    // 버튼 오토
    
    func setAuto() {
        let margins = view.layoutMarginsGuide
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0.0).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0.0).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0.0).isActive = true
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
    
    //검색뷰에서 주소를 받아온다
    @objc func addressPlus(_ noti: NSNotification) {
        let getCafeData: [String] = noti.object as! [String]
        dummyData.cafeName = getCafeData[0]
        dummyData.cafeAddress = getCafeData[1]
        dummyData.longitude = Double(getCafeData[2])!
        dummyData.latitude = Double(getCafeData[3])!
        
        tableView.reloadSections(IndexSet(0...0), with: .automatic)
        checkReportOK()
        
        
        //닉네임가져오기
        let ad = UIApplication.shared.delegate as? AppDelegate
        nickName = (ad?.userNickNameInHere)! // 받은 입력을 다음 뷰로 넘겨준다

    }
    
    @objc func honeyTipAdd(_ noti: NSNotification) {
        let honeyData = noti.object as! [Int]
        var tempData = [Int]()
        for i in 0..<honeyData.count {
            if honeyData[i] == 1 {
                tempData.append(i+1)
            }
        }
        
        dummyData.honeyTip = tempData
    }
    
    

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

        guard let nvc = UIStoryboard(name: "AddSearch", bundle: nil).instantiateViewController(identifier: "AddSearchResultVC") as? AddSearchResultVC else {
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
        showLoadingLottie()
        
        ReportCafeService.shared.ReportCafe(cafepost: dummyData) { [self] responseData in
            switch responseData {
            case .success(let res):
                print("success")
                print(res)
                let storyboard = UIStoryboard(name: "CafeReportMain", bundle: nil)
                
                if let popVC = storyboard.instantiateViewController(withIdentifier: "cafePopUpVC") as? cafePopUpVC {
                    popVC.modalPresentationStyle = .overFullScreen
                    popVC.modalTransitionStyle = .crossDissolve
                    popVC.nickName = "\(nickName!)님 덕분에\n밀키웨이가 한층 밝아졌어요!"
                    self.present(popVC, animated: true, completion: {
                    })
                }
                
            case .requestErr(_):
                print("request error")
            case .pathErr:
                print(".pathErr")
            case .serverErr:
                print(".serverErr")
            case .networkFail:
                print("failure")
                print("에러(error.localizedDescription)")
            }
            stopLottieAnimation()

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
