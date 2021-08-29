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
    
    private var inoculationLabel = UILabel().then {
        $0.text = "코로나19 백신 접종 여부 미접종"
    }
    
    private var loadButton = UIButton().then {
        $0.setTitle("🔄 접종 정보 불러오기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.backgroundColor = UIColor.mainYellow.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    // MARK: - Local Variables
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var counter = 0
    var timer = Timer()
    
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
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Custom Methods

extension QRViewController {
    func configUI() {
        view.backgroundColor = .white
    }
    
    func setConstraints() {
        view.addSubviews([cancelButton, titleLabel, subTitleLabel, backView])
        backView.addSubviews([numberLabel, qrImageView, inoculationLabel, loadButton])
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.trailing.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        qrImageView.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        inoculationLabel.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        loadButton.snp.makeConstraints { make in
            make.top.equalTo(inoculationLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setQRImageView() {
        let qrImage = generateQRCode(from: "Initial QR Code")
        qrImageView.image = qrImage
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            let nextQRImage = self.generateQRCode(from: "New QR Code")
//            self.qrImageView.image = nextQRImage
//        }
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
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
        
//        let data = Data(string.utf8)
//        filter.setValue(data, forKey: "inputMessage")
//        if let qrCodeImage = filter.outputImage {
//            if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
//                return UIImage(cgImage: qrCodeCGImage)
//            }
//        }
//        return UIImage(systemName: "xmark") ?? UIImage()
    }
    
    @objc
    func timerAction() {
        counter += 1
        switch counter{
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
            counter = 0
            timer.invalidate()
        default :
            print("Error")
        }
    }
}

extension QRViewController {
    func setAction() {
        let action = UIAction { _ in
            self.dismiss(animated: true, completion: nil)
        }
        cancelButton.addAction(action, for: .touchUpInside)
    }
}
