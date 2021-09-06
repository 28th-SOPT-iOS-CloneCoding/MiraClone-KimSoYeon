//
//  MainViewModel.swift
//  KakaoQR
//
//  Created by soyeon on 2021/09/07.
//

import Foundation
import UIKit

public class MainViewModel {
    
    let isShakeAvailable = Observable(true)

    func setShakeAvailable(to available: Bool) {
        self.isShakeAvailable.value = available
    }
    
    @objc
    func presentToQRCodeVC(_ view: UIViewController) {
        let vc = QRViewVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        view.present(vc, animated: true, completion: nil)
    }
}
