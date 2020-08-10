//
//  String.swift
//  GithubBrowser
//
//  Created by Andre & Bianca on 07/08/20.
//  Copyright © 2020 Andre. All rights reserved.
//

import UIKit

extension String {

    func formatBrazilianDate() -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.locale = Locale.init(identifier: "pt_BR")
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputDateFormatter.date(from: self) else { return "-" }
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale.init(identifier: "pt_BR")

        outputDateFormatter.dateFormat = "dd/MM/yyyy"
        return outputDateFormatter.string(from: date)
    }

    func dateFromISO8601() -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        formatter.formatOptions = [.withDay, .withMonth, .withYear, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

        guard let date = formatter.date(from: self) else { return Date() }
        return date
    }

}
