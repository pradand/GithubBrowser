//
//  ListTableViewModels.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright (c) 2020 Andre. All rights reserved.
//

import UIKit

enum ListTableView {
    enum Model {
        struct ViewModel {
            let items: [Item]?
        }

        struct Item {
            let id: Int?
            let avatar: String?
            let placeholderImage: UIImage
            let repoName: String?
            let stars: String?
            let userName: String?

            init(id: Int? = nil, avatar: String? = nil, placeholderImage: UIImage = Constants.Images.github.literal, repoName: String? = nil, stars: String? = nil, userName: String? = nil) {
                self.id = id
                self.avatar = avatar
                self.placeholderImage = placeholderImage
                self.repoName = repoName
                self.stars = stars
                self.userName = userName
            }
        }
    }
}
