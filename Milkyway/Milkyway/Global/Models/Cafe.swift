//
//  Cafe.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/04.
//

import UIKit

struct Cafe {
    var cafeName: String = ""
    var likeNum: Int = 0
    var address: String = ""
    var openTime: String = ""
    var telNum: String = ""
    var webPage: String = ""
    
    var honeyTip = [Int]()
    var menus = [Menu]()
    
}


struct Menu {
    var menuName: String = ""
    var selection = [Int]()
    var price = ""
}
