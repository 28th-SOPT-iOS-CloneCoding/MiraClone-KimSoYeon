//
//  UIColor+.swift
//  KakaoQR
//
//  Created by soyeon on 2021/08/30.
//

import UIKit

extension UIColor {
  @nonobjc class var mainYellow: UIColor {
    return UIColor(red: 255.0 / 255.0, green: 232.0 / 255.0, blue: 18.0 / 255.0, alpha: 1.0)
  }
}

extension UIColor {
    static var bgColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .darkGray
                } else {
                    return .white
                }
            }
        } else {
            return .white
        }
    }
}

