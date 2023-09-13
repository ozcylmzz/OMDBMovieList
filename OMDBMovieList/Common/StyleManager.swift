//
//  StyleManager.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import Foundation
import UIKit

class StyleManager {
    struct colors {
        static let background = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static let navigationBarTitleColor = UIColor(named: navigationBarTitleColorString)
        static let inactiveGray = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        static let appForegroundColor = UIColor(named: generalColor) ?? .red
    }
}
