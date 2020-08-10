//
//  HomeViewController.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright (c) 2020 Andre. All rights reserved.
//

import UIKit

protocol HomeDisplayLogic: class {
    func displayScreenValues(_ viewModel: Home.Model.ViewModel?)
    func displayBottomModule(viewModel: Details.Model.ViewModel)
    func animateScreen(_ isLoading: Bool)
}

class HomeViewController: ListTableViewController {
    
    // MARK: Architecture Objects
    
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?

    var bottomModule: BottomModule?
    lazy var bottomCardView: CardView = {
        let bottomCardView = CardView()
        return bottomCardView
    }()

    // MARK: ViewController lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupDelegate()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDelegate()
        setup()
    }

    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing

    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationControllerAttributes()
        interactor?.loadScreenValues()
    }

    private func setupDelegate() {
        delegate = self
    }

    private func setNavigationControllerAttributes() {
        navigationController?.navigationBar.barTintColor = .silver
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.red]
    }

}

extension HomeViewController: HomeDisplayLogic {
    func displayScreenValues(_ viewModel: Home.Model.ViewModel?) {
        self.title = viewModel?.navigationControllerTitle
        setViewModel(viewModel?.listTableViewModel)
    }

    func displayBottomModule(viewModel: Details.Model.ViewModel) {
        bottomModule = BottomModule(with: bottomCardView)
        bottomCardView.setup(viewModel)
        router?.routeToBottomModule()
    }
}

extension HomeViewController: ListTableViewDelegate {
    func didPullToRefresh() {
        interactor?.loadScreenValues()
    }

    func didCallScrollViewDidScroll(_ scrollView: UIScrollView) {
        interactor?.scrollViewDidScroll(scrollView)
    }
    
    func didTapCircularButton() {
        setTableViewContentOffset(position: IndexPath(row: 0, section: 0))
    }

    func didSelectTableViewRowAt(item: ListTableView.Model.Item) {
        interactor?.didSelectTableViewRowAt(item: item)
    }
}
