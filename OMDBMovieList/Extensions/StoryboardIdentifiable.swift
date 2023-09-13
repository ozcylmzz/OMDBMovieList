//
//  StoryboardIdentifiable.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String { return String(describing: self) }
}

extension StoryboardIdentifiable where Self: UIView {
    static var storyboardIdentifier: String { return String(describing: self) }
}

extension UIViewController: StoryboardIdentifiable {}
extension UITableViewCell: StoryboardIdentifiable {}
extension UICollectionReusableView: StoryboardIdentifiable {}
extension UITableViewHeaderFooterView: StoryboardIdentifiable {}

extension UIStoryboard {
    
    func instantiateViewController<T: UIViewController>(withIdentifier identifier: String = T.storyboardIdentifier) -> T {
        guard let controller = self.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("There is no view controller with \(identifier) identifier")
        }
        
        return controller
    }
    
    func instantiateViewController<T: RawRepresentable>(withIdentifier identifier: T) -> UIViewController where T.RawValue == String {
        return instantiateViewController(withIdentifier: identifier.rawValue)
    }
}

