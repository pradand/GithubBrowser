//
//  HomeWorker.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright (c) 2020 Andre. All rights reserved.
//

import UIKit

class HomeWorker {
    
    private let serviceProvider: ServiceProvider
    var provider: RequestProvider?

    init(serviceProvider: ServiceProvider = ServiceProvider.shared) {
        self.serviceProvider = serviceProvider
    }

    func requestData(_ requestData: Home.Model.Request, completion: @escaping (githubCompletion)) {
        let serviceProvider: ServiceProvider = ServiceProvider.shared
        let provider = HomeProvider(requestData)

        serviceProvider.fetch(of: Github.Model.Response.self, requestProvider: provider) { (response) in
            completion(response)
        }
    }

}
