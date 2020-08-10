//
//  LaunchScreenRouter.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 09/08/20.
//  Copyright (c) 2020 Andre. All rights reserved.
//

import UIKit

@objc protocol LaunchScreenRoutingLogic {
    func routeToHome()
}

class LaunchScreenRouter: NSObject, LaunchScreenRoutingLogic {
    
    // MARK: Architecture Objects
    
    weak var viewController: LaunchScreenViewController?
    
    // MARK: Routing
    
    func routeToHome() {
        let destination = HomeViewController()
        let navigationController = UINavigationController(rootViewController: destination)
        let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController = navigationController
    }

}
