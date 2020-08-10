//
//  HomeInteractor.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright (c) 2020 Andre. All rights reserved.
//

import UIKit

protocol HomeBusinessLogic {
    func loadScreenValues()
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func didSelectTableViewRowAt(item: ListTableView.Model.Item)
}

protocol HomeDataStore {}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    
    // MARK: Architecture Objects
    
    var presenter: HomePresentationLogic?
    let worker: HomeWorker
    private var response: Github.Model.Response?
    private var isFetchingMore: Bool = false
    private var currentPage: Int = 0
    private lazy var itemsPerPage: Int = 40
    private var nextPage: Int {
        return (currentPage + 1)
    }
    private let contenteOffsetForInfinityScroll: CGFloat = 2.0

    // MARK: - DataStore Objects
    
    // MARK: Init
    init(worker: HomeWorker = HomeWorker()) {
        self.worker = worker
    }
    
    // MARK: Functions

    func loadScreenValues() {
        requestRepositories()
    }

    private func requestRepositories() {
        presenter?.animateScreen(true)
        let request = Home.Model.Request(page: nextPage, itemsPerPage: itemsPerPage)

        worker.requestData(request) { [weak self] (response) in
            switch response {
            case .success(let success):
                DispatchQueue.main.async { [weak self] in
                    self?.handleSuccess(success)
                }
            case .failure(let failure):
                DispatchQueue.main.async { [weak self] in
                    self?.handleError(failure)
                }
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let totalPages = self.response?.totalCount ?? 1 / itemsPerPage

        guard offSetY > contentHeight - scrollView.frame.size.height * contenteOffsetForInfinityScroll && !isFetchingMore && (nextPage <= totalPages) else { return }
        isFetchingMore = true
        requestRepositories()
    }

    func didSelectTableViewRowAt(item: ListTableView.Model.Item) {
        guard let item = self.response?.items.filter({
            return ($0.name?.lowercased() == item.repoName?.lowercased()) && ($0.owner.login?.lowercased() == item.userName?.lowercased())
        }).first else { return }

        let model = Details.Model.ItemModel(avatar: item.owner.avatarUrl,
                                            username: item.owner.login,
                                            repo: item.name,
                                            watchersCount: item.watchersCount,
                                            forksCount: item.forksCount,
                                            starsCount: item.stargazersCount)
            
        presenter?.presentBottomModule(model)
    }

    private func handleSuccess(_ response: Github.Model.Response) {
        let items = getItems(response.items)
        self.response = Github.Model.Response(totalCount: response.totalCount, incompleteResults: response.incompleteResults, items: items)
        isFetchingMore = false
        currentPage = nextPage
        presenter?.presentScreenValues(self.response)
        presenter?.animateScreen(false)
    }

    private func handleError(_ error: Error) {
        isFetchingMore = false
        presenter?.animateScreen(false)
    }

    private func getItems(_ items: [Github.Model.Item]) -> [Github.Model.Item] {
        guard let currentItems = self.response?.items else {
            return items
        }
        return (currentItems + items)
    }

}
