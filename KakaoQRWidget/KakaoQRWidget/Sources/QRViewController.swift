//
//  ViewController.swift
//  KakaoQRWidget
//
//  Created by soyeon on 2021/08/26.
//

import UIKit
import SnapKit
import Then

class QRViewController: UIViewController {
    
    // MARK: - Properties
    
    private var qrImageView = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }

    // MARK: - Local Variables
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setQRImageView()
    }
}

// MARK: - Custom Methods

extension QRViewController {
    func configUI() {
        view.backgroundColor = .white
        
        view.addSubview(qrImageView)
        qrImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(200)
        }
    }
    
    func setQRImageView() {
        let qrImage = generateQRCode(from: "Initial QR Code")
        qrImageView.image = qrImage
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let nextQRImage = self.generateQRCode(from: "New QR Code")
            self.qrImageView.image = nextQRImage
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
}
