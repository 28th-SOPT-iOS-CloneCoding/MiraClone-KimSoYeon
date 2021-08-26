//
//  MainViewController.swift
//  KakaoQRWidget
//
//  Created by soyeon on 2021/08/26.
//

import UIKit
import SnapKit
import Then

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var guideLabel = UILabel().then {
        $0.text = "👋🏻 Shake It 👋🏻"
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let vc = QRViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainViewController {
    func configUI() {
        view.backgroundColor = .white
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
