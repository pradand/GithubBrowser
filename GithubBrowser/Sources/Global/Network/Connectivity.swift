//
//  Connectivity.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import Alamofire

class Connectivity {
    class var isConnected: Bool {
        return NetworkReachabilityManager()!.isReachable
    }

    class var useSafeCachePolicy: URLRequest.CachePolicy {
        return Connectivity.isConnected ? .reloadRevalidatingCacheData : .returnCacheDataDontLoad
    }
}
