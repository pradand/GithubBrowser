//
//  BottomModule.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 09/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import UIKit

protocol BottomModuleDelegate: class {
    func didDismissBottomModule()
}

class BottomModule: UIView {
    private lazy var cardViewBottomConstraint: NSLayoutConstraint = cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor)

        private let appWindow = UIApplication.shared.keyWindow!
        private let animationSpeed: TimeInterval = 0.35
        private var cardViewHeight: CGFloat = 0.0
        private var lastLocationTouched = CGPoint(x: 0, y: 0)
        private var stackView = UIStackView()
        weak var delegate: BottomModuleDelegate?
        private var mainView: UIView!
        var viewControllerForDismiss: UIViewController?
        var action: EmptyClosure?
        private var bottomSafeArea: CGFloat {
            if #available(iOS 11.0, *) {
                let bottomPadding = appWindow.safeAreaInsets.bottom
                return bottomPadding
            }
            
            return 0.0
        }
        
        lazy var backgroundMaskView: UIView = {
            let backgroundMaskView = UIView()
            backgroundMaskView.backgroundColor = .black
            backgroundMaskView.alpha = 0.75
            backgroundMaskView.frame = appWindow.frame
            backgroundMaskView.isUserInteractionEnabled = true
            return backgroundMaskView
        }()
        
        lazy var cardView: UIView = {
            let cardView = UIView()
            cardView.backgroundColor = .white
            cardView.clipsToBounds = true
            cardView.layer.cornerRadius = 24.0
            cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOffset = CGSize(width: 1, height: 1)
            cardView.layer.masksToBounds = false
            cardView.layer.shadowOpacity = 0.1
            cardView.translatesAutoresizingMaskIntoConstraints = false
            return cardView
        }()
        
        lazy var topView: BottomTopView = {
            let topView = BottomTopView()
            topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            return topView
        }()
        
        lazy var bottomView: UIView = {
            let bottomView = UIView()
            bottomView.translatesAutoresizingMaskIntoConstraints = false
            bottomView.backgroundColor = .white
            return bottomView
        }()
        
        public init(with mainView: UIView) {
            super.init(frame: CGRect.zero)
            self.mainView = mainView
        }
        
        public init(with mainView: UIView, action: @escaping EmptyClosure) {
            super.init(frame: CGRect.zero)
            self.mainView = mainView
            self.action = action
        }

        @objc func onDidEnterTransactionFlow(_ notification: Notification) {
            DispatchQueue.main.async { [weak self] in
                self?.dismissCard()
            }
        }
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        public func displayCard() {
            setupAppWindow()
            setupCardView()
            setupSwipeGestureToClose()
            setupTapGestureToClose()
            
            cardViewBottomConstraint.constant = 0.0 - bottomSafeArea
            UIView.animate(withDuration:animationSpeed, animations: { [weak self] in
                self?.layoutIfNeeded()
            })
        }
        
        public func dismissCard(completion: (()->())? = nil) {
            cardViewBottomConstraint.constant = cardViewHeight
            UIView.animate(withDuration: animationSpeed, animations: { [weak self] in
                self?.layoutIfNeeded()
                self?.delegate?.didDismissBottomModule()
                self?.action?()
                completion?()
            }) { (_) in
                self.removeSubviews()
            }
        }

        @objc func tapDismissCard() {
            dismissCard()
        }

        private func removeSubviews() {
            self.cardView.subviews.forEach({ (subview) in
                if subview is UIStackView {
                    subview.removeFromSuperview()
                }
            })
            self.cardView.removeFromSuperview()
            self.removeFromSuperview()
        }

        override func removeFromSuperview() {
            super.removeFromSuperview()
        }
        
        private func setupAppWindow() {
            self.translatesAutoresizingMaskIntoConstraints = false
            appWindow.addSubview(self)
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: appWindow.topAnchor),
                self.bottomAnchor.constraint(equalTo: appWindow.bottomAnchor),
                self.leftAnchor.constraint(equalTo: appWindow.leftAnchor),
                self.rightAnchor.constraint(equalTo: appWindow.rightAnchor)
            ])
        }
        
        private func setupCardView() {
            stackView = UIStackView(arrangedSubviews: [topView, mainView])
            stackView.axis = .vertical
            stackView.spacing = 23
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            self.alpha = 1.0
            self.addSubview(backgroundMaskView)
            self.addSubview(cardView)
            self.addSubview(bottomView)
            cardView.addSubview(stackView)
            
            cardViewBottomConstraint = cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            NSLayoutConstraint.activate([
                cardView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
                cardView.leftAnchor.constraint(equalTo: self.leftAnchor),
                cardView.rightAnchor.constraint(equalTo: self.rightAnchor),
                cardViewBottomConstraint
            ])

            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(greaterThanOrEqualTo: cardView.topAnchor),
                stackView.leftAnchor.constraint(equalTo: cardView.leftAnchor),
                stackView.rightAnchor.constraint(equalTo: cardView.rightAnchor),
                stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
                ])
            
            layoutIfNeeded()
            
            NSLayoutConstraint.activate([
                bottomView.leftAnchor.constraint(equalTo: self.leftAnchor),
                bottomView.rightAnchor.constraint(equalTo: self.rightAnchor),
                bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                bottomView.heightAnchor.constraint(equalToConstant: bottomSafeArea)
            ])
            
            layoutIfNeeded()

            cardViewHeight = cardView.bounds.height + bottomSafeArea
            cardViewBottomConstraint.constant = cardViewHeight
            self.alpha = 1.0
        }

        private func setupTapGestureToClose() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDismissCard))
            topView.isUserInteractionEnabled = true
            topView.addGestureRecognizer(tapGesture)
        }
        
        private func setupSwipeGestureToClose() {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(detectPanGesture))
            topView.isUserInteractionEnabled = true
            topView.addGestureRecognizer(panGesture)
        }
        
        @objc private func detectPanGesture(_ recognizer: UIPanGestureRecognizer) {
            if recognizer.state == .began || recognizer.state == .changed {
                let translation = recognizer.translation(in: self)
                
                if translation.y >= 0.0 {
                    self.cardView.center = CGPoint(x: (UIScreen.main.bounds.width/2), y: (lastLocationTouched.y + translation.y))
                }
            }
            
            if recognizer.state == .ended { self.dismissCard() }
        }
        
        public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            lastLocationTouched = self.cardView.center
        }
    }
