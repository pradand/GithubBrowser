//
//  UIImageView.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 09/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import UIKit
import SkeletonView

extension UIImageView {

    private func dispatch(image: UIImage?) {
        guard let image = image else { return }

        DispatchQueue.main.async { [weak self] in
            self?.alpha = 0.8
            UIView.animate(withDuration: 0.4, delay: 0.2, options: .allowUserInteraction, animations: { [weak self] in
                self?.alpha = 1.0
            })
            self?.image = image
            self?.hideSkeleton()
        }
    }

    private func startSkeleton() {
        self.isSkeletonable = true
        self.showAnimatedGradientSkeleton()
    }

    private func addPercentEncodingToURL(imagePath: String) -> URL? {
        guard let stringEncoded = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: stringEncoded) else { return nil }
        return url
    }

    public func downloadFrom(path: String? = nil, placeholder: UIImage? = nil) {
        self.image = nil
        startSkeleton()

        guard let imagePath = path, let url = addPercentEncodingToURL(imagePath: imagePath) else {
            dispatch(image: placeholder)
            return
        }

        if let imageCached = imageCache.object(forKey: "\(url)" as NSString) as? UIImage {
            dispatch(image: imageCached)
            return
        }

        ServiceProvider.shared.dataTask(with: url, sessionConfiguration: ServiceProvider.shared.setSessionConfigurationTimeoutLimit(30)) { [weak self] (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                    self?.dispatch(image: placeholder)
                    return
            }

            imageCache.setObject(image, forKey: "\(url)" as NSString)
            self?.dispatch(image: image)
        }
    }
}
