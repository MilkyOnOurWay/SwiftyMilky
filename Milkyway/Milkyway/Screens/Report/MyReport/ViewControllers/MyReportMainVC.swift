//
//  MyReportMainVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/02.
//

import UIKit
import XLPagerTabStrip

class MyReportMainVC: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet var myReportTableView: UITableView!
    var tabName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        registerDelegate()
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
    
    func registerDelegate() {
        myReportTableView.dataSource = self
    }
    func registerXib() {
        let topTVCellNib = UINib(nibName: "TopTVCell", bundle: nil)
        let inProgressTVCellNib = UINib(nibName: "InProgressTVCell", bundle: nil)
        let completedTVCellNib = UINib(nibName: "CompletedTVCell", bundle: nil)
        let canceledTVCellNib = UINib(nibName: "CanceledTVCell", bundle: nil)
        
        // 맨위 닉네임
        myReportTableView.register(topTVCellNib, forCellReuseIdentifier: "TopTVCell")
        // 취소된 제보
        myReportTableView.register(canceledTVCellNib, forCellReuseIdentifier: "CanceledTVCell")
        // 진행 중인 제보
        myReportTableView.register(inProgressTVCellNib, forCellReuseIdentifier: "InProgressTVCell")
        // 완료된 제보
        myReportTableView.register(completedTVCellNib, forCellReuseIdentifier: "CompletedTVCell")
    }
}

extension MyReportMainVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2{
            return 1
        } else {
            return 4 // 서버에서 받는대로
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 일단 이렇게 박아두기,,
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopTVCell.identifier) as? TopTVCell else {
                return UITableViewCell()
            }
            cell.setCell(nickName: "열매열매")
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CanceledTVCell.identifier) as? CanceledTVCell else {
                return UITableViewCell()
            }
            cell.setCell()
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InProgressTVCell.identifier) as? InProgressTVCell else {
                return UITableViewCell()
            }
            cell.setCell()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompletedTVCell.identifier) as? CompletedTVCell else {
                return UITableViewCell()
            }
            cell.setCardView()
            cell.setLabel()
            
            return cell
        }
        
    }
    
}
extension MyReportMainVC: UITableViewDelegate {
    
}
