//
//  SharingHandler.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/19/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import UIKit
import Social

class SharingHandler: UIViewController {
    
    // MARK: Singleton
    
    class var sharedInstance : SharingHandler {
        struct Static {
            static let instance : SharingHandler = SharingHandler()
        }
        return Static.instance
    }
    
    
    // MARK: Sharing Functions
    
    /**
    Opens the native iOS share screen for posting to Twitter.
    */
    func postToTwitter() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            var twitterViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterViewController.setInitialText("Testing twitter integration!")
            CCDirector.sharedDirector().presentViewController(twitterViewController, animated: true, completion: nil)
        }
    }
    
    /**
    Opens the native iOS share screen for posting to Facebook.
    
    **Note:** A known caveat with the native iOS "share sheet" for Facebook is that you are no longer able to "pre-fill" the content of the box. If you want to be able to do this, you'll need to integrate the Facebook SDK, which is an entirely different ballgame of its own.
    */
    func postToFacebook() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            var facebookViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            // This does not work; see above: facebookViewController.setInitialText("Testing facebook integration!")
            CCDirector.sharedDirector().presentViewController(facebookViewController, animated: true, completion: nil)
        }
    }
}