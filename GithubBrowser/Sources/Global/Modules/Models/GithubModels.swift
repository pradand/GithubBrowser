//
//  GithubModels.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright (c) 2020 Andre. All rights reserved.
//

import UIKit

enum Github {
    enum Model {
        struct Response: Codable {
            let totalCount: Int
            let incompleteResults: Bool
            let items: [Item]
        }

        struct Item: Codable {
            let name: String?
            let owner: Owner
            let stargazersCount: Int?
            let watchersCount: Int?
            let forksCount: Int?
        }

        struct Owner: Codable {
            let id: Int?
            let login: String?
            let avatarUrl: String?
        }

    }
}
