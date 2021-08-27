//
//  UIView+.swift
//  KakaoQRWidget
//
//  Created by soyeon on 2021/08/27.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
