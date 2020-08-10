//
//  HomePresenter.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright (c) 2020 Andre. All rights reserved.
//

import UIKit

protocol HomePresentationLogic {
    func presentScreenValues(_ response: Github.Model.Response?)
    func presentBottomModule(_ model: Details.Model.ItemModel)
    func animateScreen(_ isLoading: Bool)
}

class HomePresenter: HomePresentationLogic {
    
    // MARK: Architecture Objects
    
    weak var viewController: HomeDisplayLogic?
    
    // MARK: Functions
    
    func presentScreenValues(_ response: Github.Model.Response?) {
        let items = response?.items.map({ (item) -> ListTableView.Model.Item in
            return ListTableView.Model.Item(id: item.owner.id,
                                            avatar: item.owner.avatarUrl,
                                            repoName: item.name,
                                            stars: item.stargazersCount?.toString(),
                                            userName: item.owner.login?.capitalized)
        })

        let listTableViewModel = ListTableView.Model.ViewModel(items: items)
        let viewModel = Home.Model.ViewModel(listTableViewModel: listTableViewModel, navigationControllerTitle: HomeStrings.navigationControllerTitle)
        viewController?.displayScreenValues(viewModel)
    }

    func presentBottomModule(_ model: Details.Model.ItemModel) {
        let viewModel = Details.Model.ViewModel(avatar: model.avatar,
                                                username: model.username?.capitalized,
                                                repo: model.repo,
                                                watchersTitle: HomeStrings.watchersTitle,
                                                watchersCount: model.watchersCount?.toString(),
                                                forksTitle: HomeStrings.forksTitle,
                                                forksCount: model.forksCount?.toString(),
                                                starsImage: Constants.Images.star.literal,
                                                starsCount: model.starsCount?.toString())

        viewController?.displayBottomModule(viewModel: viewModel)
    }

    func animateScreen(_ isLoading: Bool) {
        viewController?.animateScreen(isLoading)
    }

}
