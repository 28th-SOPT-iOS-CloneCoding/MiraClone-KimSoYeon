//
//  QRViewModel.swift
//  KakaoQR
//
//  Created by soyeon on 2021/09/13.
//

import Foundation
import UIKit

public class QRViewModel {
    
    let qrcodeMsg = Observable("Initial QR Code Image View.")
    let timerText = Observable(5)
    
    var changeCount = 0
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    func setTimerText() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc
    func timerAction() {
        if self.timerText.value == 0 {
            self.changeCount += 1
            self.timerText.value = 5
            self.qrcodeMsg.value = "https://github.com/pcsoyeon"
        } else {
            self.timerText.value -= 1
        }
        
        if changeCount == 2 {
            NotificationCenter.default.post(name: NSNotification.Name("ResetNotification"), object: nil, userInfo: nil)
        }
    }
    
    func dismissToMainVC(_ view: UIViewController) {
        view.dismiss(animated: true, completion: nil)
    }
}
