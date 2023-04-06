//
//  SceneDelegate.swift
//  PRinPrinterScan
//
//  Created by JOJO on 2023/3/10.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var rootNav: UINavigationController?
    let VC = ViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        //
        SwiftyStoreKit.completeTransactions { purchases in
            debugPrint("purchases - \(purchases)")
        }
        
        //
        let aniVC = PRStartAnimationVC()
        let nav = UINavigationController.init(rootViewController: aniVC)
        nav.isNavigationBarHidden = true
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            gorun()
        }
        
        func gorun() {
            let currentVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
            var shouldShowSpl = true
            if let saveVersion = UserDefaults.standard.string(forKey: "saveVersion") {
                if saveVersion == currentVersion {
                    shouldShowSpl = false
                } else {
                    UserDefaults.standard.set(currentVersion, forKey: "saveVersion")
                }
            } else {
                UserDefaults.standard.set(currentVersion, forKey: "saveVersion")
            }
            if shouldShowSpl {
                let splashVC = PRPrinterSplashVC()
                let nav = UINavigationController.init(rootViewController: splashVC)
                nav.isNavigationBarHidden = true
                window?.rootViewController = nav
                window?.makeKeyAndVisible()
                splashVC.continueBlock = {
                    [weak self] in
                    guard let `self` = self else {return}
                    DispatchQueue.main.async {
                        self.setupViewController(connectionOptions.urlContexts.first?.url)
                    }
                }
            } else {
                setupViewController(connectionOptions.urlContexts.first?.url)
            }
        }
        
    }
    
    func setupViewController(_ url: URL? = nil) {
        let nav = UINavigationController.init(rootViewController: VC)
        nav.isNavigationBarHidden = true
        self.rootNav = nav
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        if let targetUrl = url {
            debugPrint("targetUrl - \(targetUrl)")
            let pageOptionVC = PRPrinterOptionsVC(contentUrl: targetUrl)
            if let nav = self.rootNav {
                nav.pushViewController(pageOptionVC, animated: true)
            }
        } else {
            
            PRPrinterStoreManager.default.isPurchased {[weak self] purchased in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    debugPrint("purchased - \(purchased)")
                    if !PRPrinterStoreManager.default.inSubscription {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                            [weak self] in
                            guard let `self` = self else {return}
                            let shopVC = PRPrinterStoreVC()
                            self.VC.present(shopVC, animated: true)
                            shopVC.pageDisappearBlock = {
                                [weak self] in
                                guard let `self` = self else {return}
                                DispatchQueue.main.async {
                                    SKStoreReviewController.requestReview()
                                    
                                }
                            }
                        }
                    } else {
                        SKStoreReviewController.requestReview()
                    }
                }
            }
            
            
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        debugPrint("openURLContexts")

        if let targetUrl = URLContexts.first?.url {
            debugPrint("targetUrl - \(targetUrl)")
            DispatchQueue.main.async {
                if let nav = self.rootNav {
                    let pageOptionVC = PRPrinterOptionsVC(contentUrl: targetUrl)
                    nav.pushViewController(pageOptionVC, animated: true)
                }
            }
        }
        
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
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

