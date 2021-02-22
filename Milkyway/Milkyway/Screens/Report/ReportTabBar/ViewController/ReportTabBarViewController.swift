//
//  ReportTabBarViewController.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/02.
//

import UIKit
import XLPagerTabStrip
import Lottie


class ReportTabBarViewController: ButtonBarPagerTabStripViewController, UIGestureRecognizerDelegate {
    
 
    override func viewDidLoad() {
        
        notiGather()
        setupDefaultStyle()
        changeCheck()
        
        // 로딩관련 노티
        NotificationCenter.default.addObserver(self, selector: #selector(showLoadingLottie), name: Notification.Name("startlottie"),object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopLottieAnimation), name: Notification.Name("stoplottie"),object: nil)
        
        
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }

    
    /// 상단 탭바 부분
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let cafeReport = UIStoryboard.init(name: "CafeReportMain", bundle: nil).instantiateViewController(withIdentifier: "CafeReportMainVC") as! CafeReportMainVC
        cafeReport.tabName = "카페 등록"
        
        
        let myReport = UIStoryboard(name: "MyReportMain", bundle: nil).instantiateViewController(withIdentifier: "MyReportMainVC") as! MyReportMainVC
        myReport.tabName = "나의 등록"
        
        
        return [cafeReport, myReport]
    }
    
    
    // MARK: - 데이터 로딩 중 Lottie 화면
    let loadingView = AnimationView(name: "loadingLottie")
    
    
    @objc private func showLoadingLottie() {
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
        settings.style.buttonBarItemFont = UIFont(name: "SF Pro Text Bold", size: 16.0) ?? .systemFont(ofSize: 16.0, weight: .bold)
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
        let cafeMenu = noti.object as! Menu
        guard let menuVC = UIStoryboard(name: "MenuPlus", bundle: nil).instantiateViewController(withIdentifier:"MenuPlusVC") as? MenuPlusVC else {
            return
        }
        // 수정할 때 , 삭제
        
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






