//
//  Date.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import Foundation

extension Date {
    func toString(_ format: String = "dd-MM-yyyy HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self as Date)
    }
}
