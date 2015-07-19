//
//  SharingHandler.swift
//  ReactionLine
//
//  Credit to http://www.appcoda.com/ios-programming-101-integrate-twitter-and-facebook-sharing-in-ios-6/ for information on how to use the SLComposeViewController.
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
    func postToTwitter(#stringToPost: String) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
        
            var twitterViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterViewController.setInitialText(stringToPost)
            
            // The `completionHandler` block is called when the `twitterViewController` is closed. In this scenario, the `completionHandler` checks to see if a post was successfully made, or if the user exited out of the view without making a tweet.
            twitterViewController.completionHandler = {
                (result:SLComposeViewControllerResult) in
                if result == .Done {
                    println("Sharing Handler: User posted to Twitter")
                    Mixpanel.sharedInstance().track("User Posted To Twitter")
                }
                else {
                    println("Sharing Handler: User did not post to Twitter")
                }
            }
            
            CCDirector.sharedDirector().presentViewController(twitterViewController, animated: true, completion: nil)
        }
    }
    
    /**
    Opens the native iOS share screen for posting to Facebook.
    
    **Note:** A known caveat with the native iOS "share sheet" for Facebook is that you are no longer able to "pre-fill" the content of the box. If you want to be able to do this, you'll need to integrate the Facebook SDK, which is an entirely different ballgame of its own.
    
    Actually, even if you wanted to do that, Facebook recently changed their Platform Policy such that "pre-filling" the user message parameter with any content that the user didn't enter themselves (even if they are able to edit or delete that content before posting) is against their rules, so you technically aren't allowed to do that anyways.
    */
    func postToFacebook(#urlToPost: String) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            
            var facebookViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            // THIS DOES NOT WORK (SEE ABOVE!): facebookViewController.setInitialText("Testing facebook integration!")
            facebookViewController.addURL(NSURL(string: urlToPost))
            
            // The `completionHandler` block is called when the `facebookViewController` is closed. In this scenario, the `completionHandler` checks to see if a post was successfully made, or if the user exited out of the view without making a tweet.
            facebookViewController.completionHandler = {
                (result:SLComposeViewControllerResult) in
                if result == .Done {
                    println("Sharing Handler: User posted to Facebook")
                    Mixpanel.sharedInstance().track("User Posted To Facebook")
                }
                else {
                    println("Sharing Handler: User did not post to Facebook")
                }
            }
            
            CCDirector.sharedDirector().presentViewController(facebookViewController, animated: true, completion: nil)
        }
    }
}