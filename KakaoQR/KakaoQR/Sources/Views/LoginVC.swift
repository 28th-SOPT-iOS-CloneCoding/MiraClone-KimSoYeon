//
//  PasswordVC.swift
//  KakaoQR
//
//  Created by soyeon on 2021/09/11.
//

import UIKit
import SnapKit
import Then
import LocalAuthentication

enum BiometryType {
    case faceId
    case touchId
    case none
}

class LoginVC: UIViewController {
    
    // MARK: - Properties
    
    private let loginVM = LoginViewModel()
    
    private var faceImageView = UIImageView().then {
        $0.image = UIImage(named: "faceId")
    }
    
    // MARK:- Local Variables
    
    let authContext: LAContext = LAContext()
    var error: NSError?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        auth()
    }
}

extension LoginVC {
    func configUI() {
        view.backgroundColor = .white
    }
    
    func setConstraints() {
        view.addSubview(faceImageView)
        
        faceImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(90)
        }
    }
    
    func getBiometryType() -> BiometryType {
        switch authContext.biometryType {
        case .faceID:
            return .faceId
        case .touchID:
            return .touchId
        default:
            return .none
        }
    }
    
    func auth() {
        guard authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print("바이오 인증 불가 장치")
            return
        }
        
        let type = self.getBiometryType()
        if type == .faceId {
            authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "FaceID", reply: { success, error in
                if success {
                    print("얼굴 인증 성공")
                    
                    // 화면 전환
                    DispatchQueue.main.async {
                        self.loginVM.presentToMainVC(self)
                    }
                }
                else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    print("취소")
                }
            })
        } else if type == .touchId {
            authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "홈 버튼에 손가락을 올려주세요.", reply: { success, error in
                if success {
                    print("지문 인증 성공")
                }
                else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    print("취소")
                }
            })
        }
    }
}
