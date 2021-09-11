//
//  LogInViewModel.swift
//  KakaoQR
//
//  Created by soyeon on 2021/09/11.
//

import Foundation
import UIKit

public class LoginViewModel {
    @objc
    func presentMainVC(_ view: UIViewController) {
        let vc = MainVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        view.present(vc, animated: true, completion: nil)
    }
}

