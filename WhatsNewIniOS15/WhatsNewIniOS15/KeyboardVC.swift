//
//  KeyboardVC.swift
//  WhatsNewIniOS15
//
//  Created by soyeon on 2021/10/22.
//

import UIKit

class KeyboardVC: UIViewController {
    
    // MARK: - UI
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        
        return field
    }()
    
    private lazy var backgroundView: UIVisualEffectView = {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        
        effectView.layer.cornerRadius = 8
        effectView.layer.cornerCurve = .continuous
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.clipsToBounds = true
        
        return effectView
    }()
    
    // MARK: - Properties
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        backgroundView.contentView.addSubview(textField)
        
        textField.delegate = self
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: backgroundView.contentView.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: backgroundView.contentView.trailingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: backgroundView.contentView.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: backgroundView.contentView.bottomAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            view.keyboardLayoutGuide.topAnchor.constraint(
                equalTo: backgroundView.bottomAnchor,
                constant: 8
            )
        ])

    }
    
}

extension KeyboardVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
