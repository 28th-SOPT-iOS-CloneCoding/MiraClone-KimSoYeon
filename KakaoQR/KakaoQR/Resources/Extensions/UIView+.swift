//
//  UIView+.swift
//  KakaoQR
//
//  Created by soyeon on 2021/08/30.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
