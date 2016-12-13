//
//  BackgroundPrivacy.swift
//  ELMaestro
//
//  Created by Brandon Sneed on 6/2/16.
//  Copyright © 2016 WalmartLabs. All rights reserved.
//

import Foundation
import UIKit

/// Configure if Opt-In or Opt-Out behavior is desired for determining privacy status on background.
@objc
public enum BackgroundPrivacyOptions: Int {
    /// When used, VCs conform to BackgroundPrivacy protocol for the privacy view to be shown.
    case optIn
    /// When used, VCs that don't conform to BackgroundPrivacy will activate the privacy view.
    case optOut
}

/// Protocol for working with the background privacy feature.  See the BackgroundPrivacyOptions enum.
@objc
public protocol BackgroundPrivacy {
    /**
    This is typically not needed, however in the case of a VC that subclasses another
    it could be beneficial to have a different behavior in the subclass.
    */
    @objc optional func shouldShowPrivacyView() -> Bool
}


// MARK: Privacy extensions for ApplicationSupervisor

extension ApplicationSupervisor {
    /**
    Returns a white UIView the size of the screen to use a privacy view.
    */
    public static func defaultPrivacyView() -> UIView {
        let view = UIView(frame: UIScreen.main.applicationFrame)
        view.backgroundColor = UIColor.white
        return view
    }
    
    internal func showPrivacyView() {
        // get the navigator's selected vc.
        let activeVC = navigator?.selectedViewController
        // if it's a nav controller, get that too.
        let activeNav = activeVC as? UINavigationController
        // if we have a nav controller, see if we can get it's visible VC.
        let navVisibleVC: UIViewController? = activeNav?.visibleViewController
        
        var workingVC: UIViewController
        
        if navVisibleVC != nil {
            workingVC = navVisibleVC!
        } else {
            workingVC = activeVC!
        }
        
        switch backgroundPrivacyOptions {
        case .optIn:
            // we have the workingVC, does it conform to BackgroundPrivacy?
            // yes.. then show it.
            if (workingVC is BackgroundPrivacy) == true {
                var shouldShow = true
                // a superclass might conform to it, so see if it has implemented
                // the optional protocol method.
                guard let workingVC = workingVC as? BackgroundPrivacy else {
                    break
                }
                
                if let overrideShow = workingVC.shouldShowPrivacyView?() {
                    shouldShow = overrideShow
                }
                
                if shouldShow {
                    _showPrivacyView()
                }
            }
            break
            
        case .optOut:
            // we have a workingVC, does it conform to BackgroundPrivacy?
            // no.. then show it.
            if (workingVC is BackgroundPrivacy) == false {
                _showPrivacyView()
            } else if (workingVC is BackgroundPrivacy) == true {
                // a superclass might conform to it, so see if it has implemented
                // the optional protocol method.
                guard let workingVC = workingVC as? BackgroundPrivacy else {
                    break
                }
                if workingVC.shouldShowPrivacyView?() == true {
                    _showPrivacyView()
                }
            }
            break
        }
    }
    
    fileprivate func _showPrivacyView() {
        let window = UIApplication.shared.keyWindow
        window?.addSubview(backgroundPrivacyView)
        window?.bringSubview(toFront: backgroundPrivacyView)
    }
    
    internal func hidePrivacyView() {
        backgroundPrivacyView.removeFromSuperview()
    }
}

