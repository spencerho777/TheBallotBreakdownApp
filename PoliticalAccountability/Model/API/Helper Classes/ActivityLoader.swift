//
//  UIViewController Extensions.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 6/21/21.
//  Copyright © 2021 Spencer Ho's Hose. All rights reserved.
//  taken from: https://stackoverflow.com/questions/49929487/how-to-easily-display-an-activity-indicator-from-any-viewcontroller

import Foundation
import UIKit

extension UIViewController {
    // see ObjectAssociation<T> class below
    private static let association = ObjectAssociation<UIActivityIndicatorView>()

    var indicator: UIActivityIndicatorView {
        set { UIViewController.association[self] = newValue }
        get {
            if let indicator = UIViewController.association[self] {
                return indicator
            } else {
                let w = UIScreen.main.bounds.width
                let h = UIScreen.main.bounds.height
                UIViewController.association[self] = UIActivityIndicatorView.customIndicator(at: CGPoint(x: w/2, y:h/2))
                return UIViewController.association[self]!
            }
        }
    }

    // MARK: - Acitivity Indicator
    public func startIndicatingActivity() {
        DispatchQueue.main.async {
            self.view.addSubview(self.indicator)
            self.indicator.startAnimating()
            //UIApplication.shared.beginIgnoringInteractionEvents() // if desired
        }
    }

    public func stopIndicatingActivity() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            //UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}

// source: https://stackoverflow.com/questions/25426780/how-to-have-stored-properties-in-swift-the-same-way-i-had-on-objective-c
public final class ObjectAssociation<T: AnyObject> {

    private let policy: objc_AssociationPolicy

    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {

        self.policy = policy
    }

    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {

        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}

extension UIActivityIndicatorView {
    public static func customIndicator(at center: CGPoint) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        indicator.layer.cornerRadius = 10
        indicator.center = center
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.backgroundColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.6)
        return indicator
    }
}
