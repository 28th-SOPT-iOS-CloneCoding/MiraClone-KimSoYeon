//
//  ViewController.swift
//  KakaoQRWidget
//
//  Created by soyeon on 2021/08/26.
//

import UIKit
import SnapKit
import Then
import CoreImage.CIFilterBuiltins

class QRViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancelButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .black
    }
    
    private var titleLabel = UILabel().then {
        $0.text = "입장을 위한 QR x C♾V"
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    private var subTitleLabel = UILabel().then {
        $0.text = "이용하려는 시설에 QR코드로 체크인하거나 수기명부에\n휴대전화번호 대신 개인안심번호를 기재하세요."
        $0.numberOfLines = 2
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textAlignment = .center
    }
    
    private var backView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.layer.applyShadow()
    }
    
    private var numberLabel = UILabel().then {
        $0.text = "개인안심번호"
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private var qrImageView = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private var blockView = UIView().then {
        $0.backgroundColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.8)
        $0.isHidden = true
    }
    
    private var resetButton = UIButton().then {
        $0.setTitle("🔄", for: .normal)
        $0.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    private var timerLabel = UILabel().then {
        $0.text = "남은 시간 3초"
        $0.textColor = .red
    }
    
    private var inoculationLabel = UILabel().then {
        $0.text = "코로나19 백신 접종 여부 미접종"
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    
    private var loadButton = UIButton().then {
        $0.setTitle("🔄 접종 정보 불러오기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        $0.layer.backgroundColor = UIColor.mainYellow.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    // MARK: - Local Variables
    
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    private var qrTimer = Timer()
    private var qrImageCount = 0
    
    private var timer = Timer()
    private var currentTimeCount = 3
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setConstraints()
        setQRImageView()
        setAction()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTakeScreenShot(notification:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    @objc
    func didTakeScreenShot(notification: Notification) {
        let alert = UIAlertController(title: "⚡ 경고 ⚡", message: "이 화면은 스트린 캡처가 안됩니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "쳇.", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Custom Methods

extension QRViewController {
    func configUI() {
        view.backgroundColor = .white
    }
    
    func setConstraints() {
        view.addSubviews([cancelButton, titleLabel, subTitleLabel, backView])
        backView.addSubviews([numberLabel, qrImageView, blockView, timerLabel, inoculationLabel, loadButton])
        blockView.addSubview(resetButton)
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.trailing.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(400)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        qrImageView.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        blockView.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        resetButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        inoculationLabel.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        loadButton.snp.makeConstraints { make in
            make.top.equalTo(inoculationLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    func setQRImageView() {
        qrImageView.image = generateQRCode(from: "Initial QR Code")
        
        qrTimer.invalidate()
        qrTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(qrTimerAction), userInfo: nil, repeats: true)
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
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
    
    @objc
    func qrTimerAction() {
        qrImageCount += 1
        switch qrImageCount {
        case 1 :
            qrImageView.image = generateQRCode(from: "This is first change.")
        case 2 :
            qrImageView.image = generateQRCode(from: "And this is second change.")
        case 3 :
            qrImageView.image = generateQRCode(from: "Also, this is third change.")
        case 4 :
            qrImageView.image = generateQRCode(from: "Then, this is last change.")
        case 5 :
            qrImageView.image = generateQRCode(from: "Nope, this is really last change.")
        case 6 :
            qrImageCount = 0
            qrTimer.invalidate()
            
            timer.invalidate()
            timerLabel.text = "인증 유효시간 초과"
            timerLabel.textColor = .darkGray
            
            blockView.isHidden = false
        default :
            print("Error")
        }
    }
    
    @objc
    func timerAction() {
        currentTimeCount -= 1
        timerLabel.text = "남은 시간 \(currentTimeCount)초"
        if currentTimeCount == 0 {
            currentTimeCount = 4
        }
    }
}

extension QRViewController {
    func setAction() {
        let dismissAction = UIAction { _ in
            self.dismiss(animated: true, completion: nil)
        }
        cancelButton.addAction(dismissAction, for: .touchUpInside)
        
        let resetAction = UIAction { _ in
            self.blockView.isHidden = true
            
            self.currentTimeCount = 3
            self.timerLabel.text = "남은 시간 3초"
            self.timerLabel.textColor = .red
            
            self.setQRImageView()
        }
        resetButton.addAction(resetAction, for: .touchUpInside)
    }
}
