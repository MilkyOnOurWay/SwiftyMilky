//
//  CafeReportMainVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/02.
//

import UIKit
import XLPagerTabStrip

class CafeReportMainVC: UIViewController, IndicatorInfoProvider {
    var tabName: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // ReportTabBar로 신호를 보낸다.
    @IBAction func btnClicked(_ sender: Any) {
        
        print("Cafe - Search buttonClicked")
        NotificationCenter.default.post(name: Notification.Name("tapSearch"), object: nil)
        
    }
    
}



// MARK: - Function
extension CafeReportMainVC {
    
    /// 상단 탭바 관련
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(tabName)")
    }
}
