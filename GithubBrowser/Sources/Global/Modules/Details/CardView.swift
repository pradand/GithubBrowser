//
//  CardView.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 09/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import UIKit

class CardView: NibView {

    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var repoLabel: UILabel!
    @IBOutlet weak var watchersTitleLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: PaddingLabel!
    @IBOutlet weak var forksTitleLabel: UILabel!
    @IBOutlet weak var forksCountLabel: PaddingLabel!
    @IBOutlet weak var starsImageView: UIImageView!
    @IBOutlet weak var starsCountLabel: UILabel!

    public func setup(_ viewModel: Details.Model.ViewModel) {
        setupView()
        setAvatar(viewModel.avatar, placeholderImage: viewModel.avatarPlaceholder)
        setUsernameLabel(viewModel.username)
        setRepo(viewModel.repo)
        setWatchersTitleLabel(viewModel.watchersTitle)
        setWatchersContLabel(viewModel.watchersCount)
        setForksTitleLabel(viewModel.forksTitle)
        setForksContLabel(viewModel.forksCount)
        setStarsImageView()
        setStarsCountLabel(viewModel.starsCount)
    }

    private func setupView() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
    }

    private func setAvatar(_ url: String?, placeholderImage: UIImage?) {
        guard let placeholder = placeholderImage else { return }
        avatarImageView.downloadFrom(path: url, placeholder: placeholder)
    }

    private func setUsernameLabel(_ name: String?) {
        guard let text = name else { return }
        usernameLabel.text = text
    }

    private func setRepo(_ text: String?) {
        guard let text = text else { return }
        repoLabel.text = text
    }

    private func setWatchersTitleLabel(_ title: String?) {
        guard let text = title else { return }
        
        watchersTitleLabel.text = text
    }

    private func setWatchersContLabel(_ text: String?) {
        guard let text = text else { return }
        watchersCountLabel.clipsToBounds = true
        watchersCountLabel.layer.cornerRadius = 5
        watchersCountLabel.text = text
    }

    private func setForksTitleLabel(_ text: String?) {
        guard let text = text else { return }
        forksTitleLabel.text = text
    }
    
    private func setForksContLabel(_ text: String?) {
        guard let text = text else { return }
        forksCountLabel.clipsToBounds = true
        forksCountLabel.layer.cornerRadius = 5
        forksCountLabel.text = text
    }

    private func setStarsImageView() {
        starsImageView.image = Constants.Images.star.literal
    }

    private func setStarsCountLabel(_ text: String?) {
        guard let text = text else { return }
        starsCountLabel.text = text
    }
}
