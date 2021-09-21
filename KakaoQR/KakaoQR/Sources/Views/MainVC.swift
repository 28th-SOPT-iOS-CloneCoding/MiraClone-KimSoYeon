//
//  MainVC.swift
//  KakaoQR
//
//  Created by soyeon on 2021/08/30.
//

import UIKit
import SnapKit
import Then
import LocalAuthentication

class MainVC: UIViewController {
    
    // MARK: - Properties
    
    private var guideLabel = UILabel().then {
        $0.text = "👋🏻 Shake It 👋🏻"
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    // MARK: - Local Variables
    
    var useWidget = false
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setConstraints()
        
        if useWidget {
            DispatchQueue.main.async {
                self.presentQR()
            }
        }
        
        becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            presentQR()
        }
    }
}

extension MainVC {
    func configUI() {
        view.backgroundColor = .white
    }
    
    func setConstraints() {
        view.addSubview(guideLabel)
        
        guideLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func presentQR() {
        let vc = QRViewVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
}
