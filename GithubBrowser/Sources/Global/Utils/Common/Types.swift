//
//  Types.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 08/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import Foundation

typealias githubCompletion = (Result<Github.Model.Response, CustomError>) -> ()
typealias EmptyClosure = () -> Void
