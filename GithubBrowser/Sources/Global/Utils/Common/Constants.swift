//
//  Constants.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import UIKit

struct Constants {

    enum EndPoint {
        case apiURLBase
        case repositories

        var literal: String {
            switch self {
            case .apiURLBase:
                return "https://api.github.com/search/"
            case .repositories:
                return "repositories?"
            }
        }
    }

    enum Images {
        case github
        case star
        case upArrow
        case downArrow

        var literal: UIImage {
            switch self {
            case .github:
                return UIImage(named: "github") ?? UIImage()
            case .star:
                return UIImage(named: "star") ?? UIImage()
            case .upArrow:
                return UIImage(named: "upArrow") ?? UIImage()
            case .downArrow:
                return UIImage(named: "downArrow") ?? UIImage()
            }
        }
    }

    enum Colors {
        case customDarkGray
        case customDarkBlue

        var literal: UIColor {
            switch self {
            case .customDarkGray:
                return UIColor(named: "Custom Dark Gray") ?? UIColor.darkGray
            case .customDarkBlue:
                return UIColor(named: "Custom Dark Blue") ?? UIColor.darkGray
            }
        }
    }
}
