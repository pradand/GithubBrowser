//
//  BottomTopView.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 09/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import UIKit

class BottomTopView: UIView {

    private lazy var containerViewConstraint: Layout.Constraint = Layout.Constraint()
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var iconImageViewConstraint: Layout.Constraint = Layout.Constraint(topAnchor: 16, bottomAnchor: -15, width: 24, height: 24)
    private lazy var iconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.image = Constants.Images.downArrow.literal
        image.isUserInteractionEnabled = true
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = Constants.Colors.customDarkBlue.literal
        setupViews()
    }

    private func setupViews() {
        iconImageView.tintColor = .red
        clipsToBounds = true
        layer.cornerRadius = frame.height / 2
        addViews()
        addViewsConstraints()
    }

    private func addViews() {
        addSubview(containerView)
        containerView.addSubview(iconImageView)
    }
    
    private func addViewsConstraints() {
        addContainerViewConstraints()
        addIconImageViewConstraints()
    }

    private func addContainerViewConstraints() {
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: containerViewConstraint.leadingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: containerViewConstraint.bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: containerViewConstraint.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: containerViewConstraint.topAnchor).isActive = true
    }

    private func addIconImageViewConstraints() {
        let height = iconImageView.heightAnchor.constraint(equalToConstant: iconImageViewConstraint.height)
        let width = iconImageView.widthAnchor.constraint(equalToConstant: iconImageViewConstraint.width)

        let top = iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: iconImageViewConstraint.topAnchor)
        top.priority = .defaultHigh

        let bottom = iconImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: iconImageViewConstraint.bottomAnchor)
        bottom.priority = .defaultHigh

        let centerY = iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        let centerX = iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)

        NSLayoutConstraint.activate([height, width, top, bottom, centerY, centerX])
    }

}
