//
//  MyReportMainVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/02.
//

import UIKit
import XLPagerTabStrip

class MyReportMainVC: UIViewController, IndicatorInfoProvider {
    
    var tabName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
}

// MARK: - Function
extension MyReportMainVC {
    
    /// 상단 탭바 관련
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(tabName)")
    }
    
}
