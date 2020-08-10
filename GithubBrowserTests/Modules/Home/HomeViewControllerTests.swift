//
//  HomeViewControllerTests.swift
//  GithubBrowserTests
//
//  Created by Andre & Bianca on 10/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

@testable import GithubBrowser
import XCTest

class HomeViewControllerTests: XCTestCase {

    var sut: HomeViewController?
    var window: UIWindow?

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupHomeViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    func setupHomeViewController() {
        sut = HomeViewController()
    }

    func loadView() {
        guard let window = self.window, let sut = self.sut else { return }
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    class HomeBusinessLogicSpy: HomeBusinessLogic {
        var loadScreenValuesCalled = false
        var scrollViewDidScrollCalled = false
        var didSelectTableViewRowAtCalled = false

        func loadScreenValues() {
            loadScreenValuesCalled = true
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            scrollViewDidScrollCalled = true
        }
        
        func didSelectTableViewRowAt(item: ListTableView.Model.Item) {
            didSelectTableViewRowAtCalled = true
        }
    }

    // MARK: Tests

    func testHomeWhenViewIsLoaded() {
        let spy = HomeBusinessLogicSpy()
        sut?.interactor = spy
        loadView()

        XCTAssertTrue(spy.loadScreenValuesCalled, "viewDidLoad() should ask the interactor to loadScreenValues")
    }

    func testScrollViewDidScroll() {
        let spy = HomeBusinessLogicSpy()
        sut?.interactor = spy
        loadView()
        let scrollView = UIScrollView()
    
        sut?.scrollViewDidScroll(scrollView)
        XCTAssertTrue(spy.scrollViewDidScrollCalled, "scrollViewDidScroll() should be called by interactor")
    }

    func testDidSelectTableViewRowAt() {
        let spy = HomeBusinessLogicSpy()
        sut?.interactor = spy
        loadView()
        let item = ListTableView.Model.Item(id: 1, avatar: nil, placeholderImage: UIImage(), repoName: nil, stars: nil, userName: nil)
        sut?.didSelectTableViewRowAt(item: item)

        XCTAssertTrue(spy.didSelectTableViewRowAtCalled, "didSelectTableViewRowAt() should be called by interactor")
    }
}
