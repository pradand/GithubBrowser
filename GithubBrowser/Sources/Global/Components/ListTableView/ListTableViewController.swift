//
//  ListTableViewController.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import UIKit

protocol ListTableViewDelegate: class {
    func didTapCircularButton()
    func didCallScrollViewDidScroll(_ scrollView: UIScrollView)
    func didPullToRefresh()
    func didSelectTableViewRowAt(item: ListTableView.Model.Item)
}

class ListTableViewController: UIViewController {

    fileprivate lazy var listTableViewConstraints: Layout.Constraint = Layout.Constraint(bottomAnchor: 10)
    lazy var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = true
        tableView.isScrollEnabled = true
        tableView.alwaysBounceVertical = true
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: String(describing: ListTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    fileprivate lazy var circularButtonConstraint: Layout.Constraint = Layout.Constraint(bottomAnchor: -2, width: 50, height: 50)
    fileprivate lazy var circularButton: CircularButton = {
        let button = CircularButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setup(backgroundColor: .clear, icon: Constants.Images.upArrow.literal, iconTintColor: .black)
        button.delegate = self
        return button
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.gray
        return activityIndicator
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()

    private var tableViewModel: [ListTableView.Model.Item]? {
        didSet {
            self.listTableView.reloadData()
            self.finishedRefreshing()
        }
    }

    weak var delegate: ListTableViewDelegate?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        toggleCircularButtonView(false)
        setupRefreshControl()
    }

    fileprivate func setupViews() {
        view.backgroundColor = .white
        addViews()
        addViewsConstraints()
    }

    fileprivate func addViews() {
        view.addSubview(listTableView)
        view.addSubview(circularButton)
        view.addSubview(activityIndicator)
    }
    
    fileprivate func addViewsConstraints() {
        addListTableViewConstraints()
        addCircularButtonConstraints()
    }

    fileprivate func addListTableViewConstraints() {
        listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: listTableViewConstraints.leadingAnchor).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: listTableViewConstraints.bottomAnchor).isActive = true
        listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: listTableViewConstraints.trailingAnchor).isActive = true
        listTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: listTableViewConstraints.topAnchor).isActive = true
    }

    fileprivate func addCircularButtonConstraints() {
        circularButton.heightAnchor.constraint(equalToConstant: circularButtonConstraint.height).isActive = true
        circularButton.widthAnchor.constraint(equalToConstant: circularButtonConstraint.width).isActive = true
        circularButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: circularButtonConstraint.bottomAnchor).isActive = true
        circularButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupRefreshControl() {
        guard #available(iOS 10.0, *) else {
            listTableView.addSubview(refreshControl)
            return
        }
        listTableView.refreshControl = refreshControl
    }

    @objc fileprivate func pullToRefresh() {
        delegate?.didPullToRefresh()
    }

    public func animateScreen(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    fileprivate func toggleCircularButtonView(_ isVisible: Bool) {
        guard isVisible else {
            circularButton.alpha = 0
            return
        }

        UIView.animate(withDuration: 0.8) { [weak self] in
            self?.circularButton.alpha = 1
        }
        
    }
    
    @objc public func finishedRefreshing() {
        refreshControl.endRefreshing()
    }

    public func setTableViewContentOffset(position: IndexPath) {
        listTableView.scrollToRow(at: position, at: .top, animated: true)
    }

    public func setLoading(_ isLoading: Bool) {
        listTableView.allowsSelection = !isLoading
    }

    public func setViewModel(_ viewModel: ListTableView.Model.ViewModel?) {
        tableViewModel = viewModel?.items
    }
}

extension ListTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = tableViewModel?[indexPath.row] else { return }
        delegate?.didSelectTableViewRowAt(item: selectedItem)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didCallScrollViewDidScroll(scrollView)
        if scrollView.contentOffset.y > 200 {
            toggleCircularButtonView(true)
        } else if scrollView.contentOffset.y < 50 {
            toggleCircularButtonView(false)
        }
    }
}

extension ListTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListTableViewCell.self), for: indexPath) as? ListTableViewCell, let viewModel = tableViewModel?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.setup(viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel?.count ?? 0
    }
}

extension ListTableViewController: CircularButtonDelegate {
    func didTapButton() {
        delegate?.didTapCircularButton()
    }
}
