//
//  UITabbar+Extension.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/28.
//

import UIKit.UITabBar

extension UITabBar {
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().layer.borderWidth = 0.0

    }
}
