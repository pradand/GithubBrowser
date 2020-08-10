//
//  HomeRouter.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright (c) 2020 Andre. All rights reserved.
//

import UIKit

@objc protocol HomeRoutingLogic {
    func routeToBottomModule()
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {
    
    // MARK: Architecture Objects
    
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
    
    // MARK: Routing
    
    func routeToBottomModule() {
        viewController?.bottomModule?.displayCard()
    }

}
