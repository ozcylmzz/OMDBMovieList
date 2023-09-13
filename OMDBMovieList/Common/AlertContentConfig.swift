//
//  AlertContentConfig.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import Foundation
import UIKit

struct AlertContentConfig {
    var alertImage: UIImage?
    var alertTitleText = ""
    var alertDetailText = ""
    var boldSubstring: String?
    var alertConfirmButtonTitle = ""
    var alertCancelButtonTitle = ""
    
    init(alertTitleText: String, alertDetailText: String) {
        self.alertTitleText = alertTitleText
        self.alertDetailText = alertDetailText
    }
    
    init(alertImage: UIImage?, alertTitleText: String, alertDetailText: String) {
        self.alertImage = alertImage
        self.alertTitleText = alertTitleText
        self.alertDetailText = alertDetailText
    }
    
    init(alertImage: UIImage, alertTitleText: String, alertConfirmButtonTitle: String) {
        self.alertImage = alertImage
        self.alertTitleText = alertTitleText
        self.alertConfirmButtonTitle = alertConfirmButtonTitle
    }
    
    init(alertImage: UIImage, alertTitleText: String, alertDetailText: String? = nil, alertConfirmButtonTitle: String, alertCancelButtonTitle: String) {
        self.alertImage = alertImage
        self.alertTitleText = alertTitleText
        self.alertDetailText = alertDetailText ?? ""
        self.alertCancelButtonTitle = alertCancelButtonTitle
        self.alertConfirmButtonTitle = alertConfirmButtonTitle
    }
    
    init(alertImage: UIImage, alertText: String) {
        self.alertImage = alertImage
        self.alertDetailText = alertText
    }
    
    init(alertImage: UIImage, alertTitleText: String, alertDetailText: String) {
        self.alertImage = alertImage
        self.alertTitleText = alertTitleText
        self.alertDetailText = alertDetailText
    }
    
    init(alertTitleText: String, alertDetailText: String, alertConfirmButtonTitle: String) {
        self.alertTitleText = alertTitleText
        self.alertDetailText = alertDetailText
        self.alertConfirmButtonTitle = alertConfirmButtonTitle
    }
    
    init(alertImage: UIImage, alertTitleText: String, alertDetailText: String, boldSubstring: String?, alertConfirmButtonTitle: String, alertCancelButtonTitle: String) {
        self.alertImage = alertImage
        self.alertTitleText = alertTitleText
        self.alertDetailText = alertDetailText
        self.boldSubstring = boldSubstring
        self.alertCancelButtonTitle = alertCancelButtonTitle
        self.alertConfirmButtonTitle = alertConfirmButtonTitle
    }
}
