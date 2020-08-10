//
//  HomeModels.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright (c) 2020 Andre. All rights reserved.
//

import UIKit

enum Home {
    
    // MARK: Use cases
    
    enum Model {
        struct Request {
            let page: Int
            let itemsPerPage: Int
            let query: String = "language:swift"
            let sort: String = "stars"
        }

        struct ViewModel {
            let listTableViewModel: ListTableView.Model.ViewModel
            let navigationControllerTitle: String
        }
    }
}
