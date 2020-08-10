//
//  LaunchScreenViewController.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 09/08/20.
//  Copyright (c) 2020 Andre. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    // MARK: Architecture Objects

    var router: (NSObjectProtocol & LaunchScreenRoutingLogic)?
    
    // MARK: - Outlets
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: ViewController lifecycle

    init() {
        super.init(nibName: String(describing: LaunchScreenViewController.self), bundle: nil)
        setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: String(describing: LaunchScreenViewController.self), bundle: nil)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let router = LaunchScreenRouter()
    
        viewController.router = router
        router.viewController = viewController
    }

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImageView.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIcon()
    }

    private func animateIcon() {
        UIView.animate(withDuration: 5, animations: { [weak self] in
            self?.iconImageView.alpha = 1
        }) { (isSuccess: Bool) in
            guard isSuccess else { return }
            UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.iconImageView.frame.origin.y = strongSelf.view.bounds.height
                strongSelf.view.layoutIfNeeded()
                strongSelf.iconImageView.alpha = 0
                }, completion: { (_) in
                    self.router?.routeToHome()
            })
        }
    }

}
