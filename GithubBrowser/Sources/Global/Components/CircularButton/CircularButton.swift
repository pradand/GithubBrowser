//
//  CircularButton.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 09/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import UIKit

protocol CircularButtonDelegate: class {
    func didTapButton()
}

class CircularButton: UIView {

    private lazy var iconImageViewConstraint: Layout.Constraint = Layout.Constraint()
    private lazy var iconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.isUserInteractionEnabled = true
        return image
    }()

    weak var delegate: CircularButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Constants.Colors.customDarkBlue.literal
        setupViews()
        addTapGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = Constants.Colors.customDarkBlue.literal
        setupViews()
        addTapGestureRecognizer()
    }

    private func setupViews() {
        clipsToBounds = true
        layer.cornerRadius = frame.height / 2
        layer.shadowOffset = CGSize(width: 1, height: -1)
        layer.shadowOpacity = 0.1
        addViews()
        addViewsConstraints()
    }

    private func addViews() {
        addSubview(iconImageView)
    }
    
    private func addViewsConstraints() {
        addIconImageViewConstraints()
    }

    private func addIconImageViewConstraints() {
        iconImageView.heightAnchor.constraint(equalToConstant: frame.height * 0.5).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: frame.height * 0.5).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
        iconImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    public func setup(backgroundColor: UIColor = Constants.Colors.customDarkBlue.literal, icon: UIImage, iconTintColor: UIColor = .white) {
        self.backgroundColor = backgroundColor
        self.iconImageView.image = icon
        self.iconImageView.tintColor = iconTintColor
    }

    @objc func didTapButton() {
        delegate?.didTapButton()
    }
}
