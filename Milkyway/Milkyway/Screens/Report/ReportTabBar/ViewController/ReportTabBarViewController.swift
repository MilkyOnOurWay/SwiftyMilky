//
//  ReportTabBarViewController.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/02.
//

import UIKit
import XLPagerTabStrip

class ReportTabBarViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        
        notiGather()
        setupDefaultStyle()
        changeCheck()
        
        super.viewDidLoad()
        
    }

    
    /// 상단 탭바 부분
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let cafeReport = UIStoryboard.init(name: "CafeReportMain", bundle: nil).instantiateViewController(withIdentifier: "CafeReportMainVC") as! CafeReportMainVC
        cafeReport.tabName = "카페 제보"
        
        
        let myReport = UIStoryboard(name: "MyReportMain", bundle: nil).instantiateViewController(withIdentifier: "MyReportMainVC") as! MyReportMainVC
        myReport.tabName = "나의 제보"
        
        
        return [cafeReport, myReport]
    }
    

}



// MARK: - Function
extension ButtonBarPagerTabStripViewController {
    
    func notiGather() {
        NotificationCenter.default.addObserver(self, selector: #selector(menuView), name: Notification.Name("gotomenuAdd"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editMenu(_:)), name: Notification.Name("gotomenuEdit"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(movethetabBar), name: Notification.Name("tabBarMove"), object: nil)
        
    }
    
    
    /// 탭바 UI 설정하는 함수
    func setupDefaultStyle() {
        settings.style.selectedBarBackgroundColor = UIColor(named: "Milky")!
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = UIFont(name: "SF Pro Text Bold", size: 16.0)!
        settings.style.selectedBarHeight = 2.0
    }
    
    
    /// 상단 탭바 -> 선택에 따라 색상 변경
    func changeCheck() {
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = UIColor(named: "darkGrey")!
            newCell?.label.textColor = UIColor(named: "Milky")!
            
            
        }
    }
    
    
    /// 메뉴 추가하기 버튼 눌렸을 때 menuPlusVC로 넘어간다.
    
    @objc func menuView() {
        guard let menuVC = UIStoryboard(name: "MenuPlus", bundle: nil).instantiateViewController(withIdentifier:"MenuPlusVC") as? MenuPlusVC else {
            return
        }
        self.navigationController?.pushViewController(menuVC, animated: true) // menuPlus View 띄우기
        
    }
    
    @objc func editMenu(_ noti: NSNotification) {
        var cafeMenu = noti.object as! Menu
        guard let menuVC = UIStoryboard(name: "MenuPlus", bundle: nil).instantiateViewController(withIdentifier:"MenuPlusVC") as? MenuPlusVC else {
            return
        }
        // 수정할 때 , 삭제
        cafeMenu.price = (cafeMenu.price.components(separatedBy: ",").joined())
        menuVC.editCafeMenu = cafeMenu
        menuVC.areyouEdit = true

        self.navigationController?.pushViewController(menuVC, animated: true) // menuPlus View 띄우기
        
    }
    
    @objc func movethetabBar() {
        self.moveToViewController(at: 1)
    }
    
  
    
    /// 검색버튼 눌리면 searchVC로 연결
    @objc func searchBtnClicked() {
        print("searchPlease")
        
        guard let nvc = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier:"SearchVC") as? SearchVC else {
            return
        }
        
        self.navigationController?.pushViewController(nvc, animated: true) // 다음 뷰 띄우기
    }
    
    
}






