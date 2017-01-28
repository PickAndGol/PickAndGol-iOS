//
//  UIStoryboard+Storyboard.swift
//  pickandgol_ios
//
//  Created by Edu González on 28/1/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum Storyboard: String {
        case main
        case timeline
        case map
        case newitem
        case notifications
        case user
        case login

        var filename: String {
            return rawValue.capitalized
        }
    }

    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }

    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {

        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }

        return viewController
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable { }
