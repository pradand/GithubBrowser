//
//  DetailsModels.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 09/08/20.
//  Copyright (c) 2020 Andre. All rights reserved.
//

import UIKit

enum Details {
    enum Model {
        struct ItemModel {
            let avatar: String?
            let username: String?
            let repo: String?
            let watchersCount: Int?
            let forksCount: Int?
            let starsCount: Int?
        }

        struct ViewModel {
            let avatar: String?
            let avatarPlaceholder: UIImage
            let username: String?
            let repo: String?
            let watchersTitle: String?
            let watchersCount: String?
            let forksTitle: String?
            let forksCount: String?
            let starsImage: UIImage?
            let starsCount: String?

            init(avatar: String? = nil,
                 avatarPlaceholder: UIImage = Constants.Images.github.literal,
                 username: String? = nil,
                 repo: String?,
                 watchersTitle: String? = nil,
                 watchersCount: String? = nil,
                 forksTitle: String? = nil,
                 forksCount: String? = nil,
                 starsImage: UIImage? = nil,
                 starsCount: String? = nil) {
                self.avatar = avatar
                self.avatarPlaceholder = avatarPlaceholder
                self.username = username
                self.repo = repo
                self.watchersTitle = watchersTitle
                self.watchersCount = watchersCount
                self.forksTitle = forksTitle
                self.forksCount = forksCount
                self.starsImage = starsImage
                self.starsCount = starsCount
            }
        }
    }
}
