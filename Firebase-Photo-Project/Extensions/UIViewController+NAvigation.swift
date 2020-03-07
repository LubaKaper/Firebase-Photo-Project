//
//  UIViewController+NAvigation.swift
//  Firebase-Photo-Project
//
//  Created by Liubov Kaper  on 3/6/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit

extension UIViewController {
    
    private static func resetWindow(with rootViewController: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first,
            let sceneDelegate = scene.delegate as? SceneDelegate,
            let window = sceneDelegate.window else {
                fatalError("could not reset window rootViewController")
        }
        window.rootViewController = rootViewController
        
    }
    
    
    
    public static func showViewController(storyboardName: String, viewControllerID: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let newVC = storyboard.instantiateViewController(identifier: viewControllerID)
    
        resetWindow(with: newVC)
    }
    
    
}
