//
//  ViewController.swift
//  WhatsNewIniOS15
//
//  Created by soyeon on 2021/10/19.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - UI
    
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
    let pressButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    
    // MARK: - Properties
    
    private var flag = false {
        didSet {
            self.button.setNeedsUpdateConfiguration()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        setConstraints()
    }
    
    private func initUI() {
        view.addSubview(button)
        view.addSubview(pressButton)
        
        button.configuration = createConfig()
        button.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.subtitle = self.flag ? "You Clicked." : "Not Yet."
            config?.image = self.flag ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            config?.imagePadding = 10
            config?.imagePlacement = .leading
            button.configuration = config
        }
        
        pressButton.setTitle("눌러", for: .normal)
        pressButton.setTitleColor(.systemPink, for: .normal)
        pressButton.addAction(UIAction(handler: { action in
            self.flag.toggle()
        }), for: .touchUpInside)
    }
    
    private func setConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        pressButton.translatesAutoresizingMaskIntoConstraints = false
        pressButton.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10).isActive = true
        pressButton.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
    }
    
    // MARK: - Custom Methods
    
    private func createConfig() -> UIButton.Configuration {
        var config: UIButton.Configuration = .filled()
        config.baseBackgroundColor = .systemPink
        config.title = "New Version Of Button"
        config.titleAlignment = .center
        config.cornerStyle = .medium
        return config
    }
}

