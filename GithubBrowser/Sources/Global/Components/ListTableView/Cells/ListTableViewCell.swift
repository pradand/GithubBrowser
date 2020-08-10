//
//  ListTableViewCell.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    private lazy var iconImageViewConstraint: Layout.Constraint = Layout.Constraint(topAnchor: 25, leadingAnchor: 30, trailingAnchor: -15, bottomAnchor: -25, width: 35, height: 35)
    private lazy var vStackViewContainerConstraint: Layout.Constraint = Layout.Constraint(trailingAnchor: -25)
    private lazy var starImageViewConstraint: Layout.Constraint = Layout.Constraint(topAnchor: 5, trailingAnchor: -5, width: 18, height: 18)
    private lazy var starLabelConstraint: Layout.Constraint = Layout.Constraint(trailingAnchor: -10)

    private lazy var iconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 13
        return image
    }()

    private lazy var vStackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    private lazy var repoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = Fonts.appleSDGothicNeo.semiBold.size(12)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.setContentHuggingPriority(.init(rawValue: 250), for: .horizontal)
        label.setContentHuggingPriority(.init(rawValue: 250), for: .vertical)
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.customDarkGray.literal
        label.textAlignment = .left
        label.font = Fonts.appleSDGothicNeo.regular.size(10)
        return label
    }()

    private lazy var starImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = false
        image.image = Constants.Images.star.literal
        return image
    }()

    private lazy var starLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.customDarkGray.literal
        label.textAlignment = .center
        label.font = Fonts.futura.bold.size(9)
        label.setContentHuggingPriority(.init(rawValue: 252), for: .horizontal)
        label.setContentHuggingPriority(.init(rawValue: 251), for: .vertical)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        addViews()
        addViewsConstraints()
    }

    private func addViews() {
        addSubview(iconImageView)
        addSubview(vStackViewContainer)
        vStackViewContainer.addArrangedSubviews(views: [repoLabel, nameLabel])
        addSubview(starImageView)
        addSubview(starLabel)
    }
    
    private func addViewsConstraints() {
        addIconImageViewConstraints()
        addVStackViewContainerConstraints()
        addStarImageViewConstraints()
        addStarLabelConstraints()
    }

    private func addIconImageViewConstraints() {
        iconImageView.heightAnchor.constraint(equalToConstant: iconImageViewConstraint.height).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: iconImageViewConstraint.width).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: iconImageViewConstraint.leadingAnchor).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: iconImageViewConstraint.bottomAnchor).isActive = true
        iconImageView.trailingAnchor.constraint(equalTo: vStackViewContainer.leadingAnchor, constant: iconImageViewConstraint.trailingAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: iconImageViewConstraint.topAnchor).isActive = true
    }

    private func addVStackViewContainerConstraints() {
        vStackViewContainer.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor).isActive = true
        vStackViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: vStackViewContainerConstraint.trailingAnchor).isActive = true
    }

    private func addStarImageViewConstraints() {
        starImageView.heightAnchor.constraint(equalToConstant: starImageViewConstraint.height).isActive = true
        starImageView.widthAnchor.constraint(equalToConstant: starImageViewConstraint.width).isActive = true
        starImageView.topAnchor.constraint(equalTo: topAnchor, constant: starImageViewConstraint.topAnchor).isActive = true
        starImageView.trailingAnchor.constraint(equalTo: starLabel.leadingAnchor, constant: starImageViewConstraint.trailingAnchor).isActive = true
    }

    private func addStarLabelConstraints() {
        starLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor).isActive = true
        starLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: starLabelConstraint.trailingAnchor).isActive = true
    }

    public func setup(_ viewModel: ListTableView.Model.Item?) {
        setIconImageView(viewModel)
        setNameLabel(viewModel?.userName)
        setStarsLabel(viewModel?.stars)
        setRepoLabel(viewModel?.repoName)
    }

    private func setIconImageView(_ viewModel: ListTableView.Model.Item?) {
        guard let placeholder = viewModel?.placeholderImage else { return }
        iconImageView.downloadFrom(path: viewModel?.avatar, placeholder: placeholder)
    }

    private func setNameLabel(_ name: String?) {
        guard let text = name else { return }
        nameLabel.text = text
    }

    private func setStarsLabel(_ stars: String?) {
        guard let text = stars else { return }
        starLabel.text = text
        starLabel.sizeToFit()
    }

    private func setRepoLabel(_ name: String?) {
        guard let text = name else { return }
        repoLabel.text = text
    }
}
