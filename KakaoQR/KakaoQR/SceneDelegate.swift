//
//  SceneDelegate.swift
//  KakaoQR
//
//  Created by soyeon on 2021/08/30.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var visualEffectView = UIVisualEffectView()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let rootVC = LoginVC()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        self.visualEffectView.removeFromSuperview()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
        // background ?????? ??? blur ??????
        if !self.visualEffectView.isDescendant(of: self.window!) {
            let blurEffect = UIBlurEffect(style: .light)
            self.visualEffectView = UIVisualEffectView(effect: blurEffect)
            self.visualEffectView.frame = (self.window?.bounds)!
            self.window?.addSubview(self.visualEffectView)
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let rootVC = LoginVC()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        // background ?????? ??? blur ??????
        self.visualEffectView.removeFromSuperview()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        
        if let currentVC = UIApplication.topViewController() as? QRViewVC {
            currentVC.dismiss(animated: false, completion: nil)
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            print(url)
            
            let urlString = url.absoluteString
            let component = urlString.components(separatedBy: "=")
            
            print(component)
            
            if component.count > 1, let product = component.last {
                print(product)
                
                // qr ?????? ??????
//                pushToQR()
                guard let windowScene = (scene as? UIWindowScene) else { return }
                
                window = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window?.windowScene = windowScene
                
                let rootVC = LoginVC()
                rootVC.useWidget = true
                window?.rootViewController = rootVC
                window?.makeKeyAndVisible()
            } else {
                guard let windowScene = (scene as? UIWindowScene) else { return }
                
                window = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window?.windowScene = windowScene
                
                let rootVC = LoginVC()
                window?.rootViewController = rootVC
                window?.makeKeyAndVisible()
            }
        }
    }
    
    func pushToQR() {
        let qrVC = QRViewVC()
        let rootVC = self.window?.rootViewController
        qrVC.modalPresentationStyle = .fullScreen
        qrVC.modalTransitionStyle = .coverVertical
        rootVC?.present(qrVC, animated: true, completion: nil)
    }
        
}

