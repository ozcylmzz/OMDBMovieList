//
//  DefaultAlertController.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import UIKit

class DefaultAlertController: UIViewController {
    
    @IBOutlet weak var alertImageView: UIImageView! {
        didSet {
            alertImageView.isAccessibilityElement = false
        }
    }
    @IBOutlet weak var alertLabel: UILabel! {
        didSet {
            alertLabel.isAccessibilityElement = true
        }
    }
    @IBOutlet weak var alertDetailLabel: UILabel? {
        didSet {
            alertDetailLabel?.isAccessibilityElement = true
        }
    }
    
    var alertContent: AlertContentConfig?
    var didImageTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = alertContent?.alertImage {
            alertImageView.image = image
        } else {
            alertImageView.isHidden = true
        }
        alertLabel.text = alertContent?.alertTitleText
        alertDetailLabel?.text = alertContent?.alertDetailText
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        alertImageView.addGestureRecognizer(tap)
        alertImageView.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        didImageTapped?()
    }
}

extension DefaultAlertController {
    override open func accessibilityPerformEscape() -> Bool {
        if let alertController = self.view.findViewController() as? DefaultAlertController {
            alertController.dismiss(animated: true, completion: nil)
        }
        return true
    }
}
