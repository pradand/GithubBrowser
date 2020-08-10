//
//  Layout.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import UIKit

enum Layout {

    struct Constraint {
        var topAnchor: CGFloat
        var leadingAnchor: CGFloat
        var trailingAnchor: CGFloat
        var bottomAnchor: CGFloat
        var centerXAnchor: CGFloat
        var centerYAnchor: CGFloat
        var width: CGFloat
        var height: CGFloat

        init(topAnchor: CGFloat = 0.0,
             leadingAnchor: CGFloat = 0.0, trailingAnchor: CGFloat = 0.0,
             bottomAnchor: CGFloat = 0.0,
             centerXAnchor: CGFloat = 0.0, centerYAnchor: CGFloat = 0.0,
             width: CGFloat = 0.0, height: CGFloat = 0.0) {
            self.topAnchor = topAnchor
            self.leadingAnchor = leadingAnchor
            self.trailingAnchor = trailingAnchor
            self.bottomAnchor = bottomAnchor
            self.centerXAnchor = centerXAnchor
            self.centerYAnchor = centerYAnchor
            self.width = width
            self.height = height
        }
    }

}

