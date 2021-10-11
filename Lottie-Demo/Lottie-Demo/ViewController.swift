//
//  ViewController.swift
//  Lottie-Demo
//
//  Created by soyeon on 2021/10/03.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    let thunderView: AnimationView = {
        let view = AnimationView(name: "icecream")
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        view.contentMode = .scaleAspectFit
        return view
    }()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAnimation()
    }
    
    func setAnimation() {
        view.addSubview(thunderView)
        thunderView.center = view.center
        
        dump(thunderView.animation?.endFrame)
        thunderView.play(fromFrame: 10, toFrame: 30)
    }
    
}

