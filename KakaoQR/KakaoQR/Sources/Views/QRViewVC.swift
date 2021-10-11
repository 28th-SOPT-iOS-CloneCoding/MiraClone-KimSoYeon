//
//  QRViewVC.swift
//  KakaoQR
//
//  Created by soyeon on 2021/08/30.
//

import UIKit
import SnapKit
import Then
import CoreImage.CIFilterBuiltins

class QRViewVC: UIViewController {
    
    // MARK: - Properties
    
//    private let qrVM = QRViewModel()
    
    private var closeButton = UIButton()
    
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    
    private var backView = UIView()
    
    private var numberLabel = UILabel()
    
    private var qrImageView = UIImageView()
    private var blockView = UIView()
    
    private var resetButton = UIButton()
    private var timerLabel = UILabel()
    
    private var inoculationLabel = UILabel()
    
    private var loadButton = UIButton()
    
    // MARK: - Local Variables
    
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    private var qrImageTimer = Timer()
    private var qrImageCount = 0
    
    private var timer = Timer()
    private var currentTimeCount = 5
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setConstraints()
//        setBinding()
        setNotification()
        
        setQRImageView()
        setAction()
    }
}

// MARK: - Custom Methods

extension QRViewVC {
    func configUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor(named: "textColor")
        closeButton.setPreferredSymbolConfiguration(.init(pointSize: 20, weight: .regular), forImageIn: .normal)
        closeButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
        
        titleLabel.text = "입장을 위한 QR x C♾V"
        titleLabel.textColor = UIColor(named: "textColor")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        subTitleLabel.text = "이용하려는 시설에 QR코드로 체크인하거나 수기명부에\n휴대전화번호 대신 개인안심번호를 기재하세요."
        subTitleLabel.numberOfLines = 2
        subTitleLabel.textColor = UIColor(named: "textColor")
        subTitleLabel.font = UIFont.systemFont(ofSize: 13)
        subTitleLabel.textAlignment = .center
        
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 15
        backView.layer.masksToBounds = true
        backView.layer.applyShadow()
        
        numberLabel.text = "개인안심번호 12가34나"
        numberLabel.textColor = .gray
        numberLabel.font = UIFont.systemFont(ofSize: 14)
        let attributedStr = NSMutableAttributedString(string: numberLabel.text!)
        attributedStr.addAttribute(.foregroundColor, value: UIColor.black, range: (numberLabel.text! as NSString).range(of: "12가34나"))
        attributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 15), range: (numberLabel.text! as NSString).range(of: "12가34나"))
        numberLabel.attributedText = attributedStr
        
        qrImageView.layer.cornerRadius = 10
        qrImageView.layer.masksToBounds = true
        
        blockView.backgroundColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.8)
        blockView.isHidden = true
        
        resetButton.setTitle("🔄", for: .normal)
        resetButton.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        timerLabel.text = "남은 시간 5초"
        timerLabel.textColor = .black
        let targetString1 = timerLabel.text?.components(separatedBy: " ").last ?? ""
        timerLabel.asFontColor(targetStringList: [targetString1], font: .systemFont(ofSize: 16), color: .red)
        
        inoculationLabel.text = "코로나19 백신 접종 여부 미접종"
        inoculationLabel.textColor = .darkGray
        inoculationLabel.font = UIFont.systemFont(ofSize: 13)
        
        loadButton.setTitle("🔄 접종 정보 불러오기", for: .normal)
        loadButton.setTitleColor(.black, for: .normal)
        loadButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        loadButton.layer.backgroundColor = UIColor.mainYellow.cgColor
        loadButton.layer.cornerRadius = 10
        loadButton.layer.masksToBounds = true
    }
    
    func setConstraints() {
        view.addSubviews([closeButton, titleLabel, subTitleLabel, backView])
        backView.addSubviews([numberLabel, qrImageView, blockView, timerLabel, inoculationLabel, loadButton])
        blockView.addSubview(resetButton)
        
        closeButton.snp.makeConstraints { make in
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
//        qrVM.setTimerText()
        
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
    
    func setQRImageView() {
        qrImageView.image = generateQRCode(from: "Initial QR Code")

        qrImageTimer.invalidate()
        qrImageTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(qrTimerAction), userInfo: nil, repeats: true)

        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
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
            qrImageView.image = generateQRCode(from: "Then, this is last change.")
        case 4 :
            qrImageCount = 0
            qrImageTimer.invalidate()

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
        let targetString1 = timerLabel.text?.components(separatedBy: " ").last ?? ""
        timerLabel.asFontColor(targetStringList: [targetString1], font: .systemFont(ofSize: 16), color: .red)

        if currentTimeCount == 0 {
            currentTimeCount = 6
        }
    }
    
    func setAction() {
        let resetAction = UIAction { _ in
            self.blockView.isHidden = true

            self.currentTimeCount = 5
            self.timerLabel.text = "남은 시간 5초"
            self.timerLabel.textColor = .red

            self.setQRImageView()
        }
        resetButton.addAction(resetAction, for: .touchUpInside)
    }
}

// MARK: - Notification

extension QRViewVC {
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didTakeScreenShot(notification:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveResetNotification(_:)), name: NSNotification.Name("ResetNotification"), object: nil)
    }
    
    @objc
    func didTakeScreenShot(notification: Notification) {
        let alert = UIAlertController(title: "⚡ 경고 ⚡", message: "이 화면은 스트린 캡쳐가 안됩니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "쳇.", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    func didRecieveResetNotification(_ notification: Notification) {
        blockView.isHidden = false
        timerLabel.text = "인증 유효 시간 초과"
        timerLabel.textColor = .darkGray
    }
}


//extension QRViewVC {
//    func setBinding() {
//        qrVM.qrcodeMsg.bind { msg in
//            self.qrImageView.image = self.qrVM.generateQRCode(from: msg)
//        }
//
//        qrVM.timerText.bind { time in
//            let text = "남은 시간 \(time)초"
//            let attributeStrring = NSMutableAttributedString(string: text)
//            attributeStrring.addAttribute(.foregroundColor, value:  UIColor.red, range: NSRange.init(location: 6, length: String(time).count+1))
//            self.timerLabel.attributedText = attributeStrring
//        }
//    }
//}
