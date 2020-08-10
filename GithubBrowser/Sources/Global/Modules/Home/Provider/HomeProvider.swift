//
//  HomeProvider.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import Foundation

class HomeProvider: RequestProvider {
    var endPoint: Constants.EndPoint = .repositories
    var httpMethod: HTTPMethod = .get
    var requestData: Home.Model.Request
    var failOnNoReachability: Bool {
        return false
    }
    
    init(_ requestData: Home.Model.Request) {
        self.requestData = requestData
    }

    func urlParameters() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "q", value: requestData.query),
            URLQueryItem(name: "page", value: "\(requestData.page)"),
            URLQueryItem(name: "per_page", value: "\(requestData.itemsPerPage)"),
            URLQueryItem(name: "sort", value: requestData.sort)
        ]
    }
}
