//
//  Fonts.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 09/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import UIKit

enum Fonts {

    enum appleSDGothicNeo: String {
        case thin = "AppleSDGothicNeo-Thin"
        case light = "AppleSDGothicNeo-Light"
        case regular = "AppleSDGothicNeo-Regular"
        case medium = "AppleSDGothicNeo-Medium"
        case semiBold = "AppleSDGothicNeo-SemiBold"
        case bold = "AppleSDGothicNeo-Bold"

        public func size(_ ofSize: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
        }
    }

    enum futura: String {
        case bold = "Futura-Bold"

        public func size(_ ofSize: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
        }
    }

}
