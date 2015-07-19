//
//  SharingHandler.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit
import Social

class SharingHandler: UIViewController {
    
    // Making the SharingHandler a singleton:
    class var sharedInstance : SharingHandler {
        struct Static {
            static let instance : SharingHandler = SharingHandler()
        }
        return Static.instance
    }
    
    func postToTwitter() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            var twitterViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterViewController.setInitialText("Test tweet!")
            CCDirector.sharedDirector().presentViewController(twitterViewController, animated: true, completion: nil)
        }
    }
    
    func postToFacebook() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            var facebookViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookViewController.setInitialText("Test")
            CCDirector.sharedDirector().presentViewController(facebookViewController, animated: true, completion: nil)
        }
    }
    
}