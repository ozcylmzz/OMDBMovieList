//
//  UIStoryboard.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import UIKit.UIStoryboard
import UIKit

extension UIStoryboard {
    
    convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }
    
    static var common: UIStoryboard { return UIStoryboard(name: "Common") }
    static var main: UIStoryboard { return UIStoryboard(name: "Main") }
    static var movieDetailsViewController: UIStoryboard { return UIStoryboard(name: "MovieDetailsViewController") }
    
}
