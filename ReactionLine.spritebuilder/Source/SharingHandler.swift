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
    
    // MARK: Constants
    
    let defaultURL: String = "https://itunes.apple.com/us/app/reaction-line-game-about-sorting/id1018598686?ls=1&mt=8"
    
    let mixpanel = Mixpanel.sharedInstance()
    
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
    
    The `defaultURL` set in at the top of `SharingHandler.swift` will be appended to the end of the post automatically.
    */
    func postToTwitter(stringToPost stringToPost: String, postWithScreenshot: Bool) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            
            mixpanel.track("Opened Twitter Sharing Dialog")
        
            let twitterViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterViewController.setInitialText(stringToPost + " \(defaultURL)")
            
            if postWithScreenshot {
                twitterViewController.addImage(takeScreenshot())
            }
            
            // The `completionHandler` block is called when the `twitterViewController` is closed. In this scenario, the `completionHandler` checks to see if a post was successfully made, or if the user exited out of the view without making a tweet.
            twitterViewController.completionHandler = {
                (result:SLComposeViewControllerResult) in
                if result == .Done {
                    print("Sharing Handler: User posted to Twitter")
                    self.mixpanel.track("User Posted To Twitter")
                }
                else {
                    print("Sharing Handler: User did not post to Twitter")
                }
            }
            
            CCDirector.sharedDirector().presentViewController(twitterViewController, animated: true, completion: nil)
        }
        else {
            let error = UIAlertView()
            error.title = "No Twitter Account Available"
            error.message = "You can add a Twitter account to share from in your Settings."
            error.addButtonWithTitle("OK")
            error.show()
        }
    }
    
    /**
    Opens the native iOS share screen for posting to Facebook.
    
    The `defaultURL` set in at the top of `SharingHandler.swift` will be appended to the end of the post automatically.
    
    **Note:** A known caveat with the native iOS "share sheet" for Facebook is that you are no longer able to "pre-fill" the content of the box. If you want to be able to do this, you'll need to integrate the Facebook SDK, which is an entirely different ballgame of its own.
    
    Actually, even if you wanted to do that, Facebook recently changed their Platform Policy such that "pre-filling" the user message parameter with any content that the user didn't enter themselves (even if they are able to edit or delete that content before posting) is against their rules, so you technically aren't allowed to do that anyways.
    */
    func postToFacebook(postWithScreenshot postWithScreenshot: Bool) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            
            mixpanel.track("Opened Facebook Sharing Dialog")
            
            let facebookViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            // THIS DOES NOT WORK (SEE ABOVE!): facebookViewController.setInitialText("Testing facebook integration!")
            facebookViewController.addURL(NSURL(string: defaultURL))
            
            if postWithScreenshot {
                facebookViewController.addImage(takeScreenshot())
            }
            
            // The `completionHandler` block is called when the `facebookViewController` is closed. In this scenario, the `completionHandler` checks to see if a post was successfully made, or if the user exited out of the view without making a tweet.
            facebookViewController.completionHandler = {
                (result:SLComposeViewControllerResult) in
                if result == .Done {
                    print("Sharing Handler: User posted to Facebook")
                    self.mixpanel.track("User Posted To Facebook")
                }
                else {
                    print("Sharing Handler: User did not post to Facebook")
                }
            }
            
            CCDirector.sharedDirector().presentViewController(facebookViewController, animated: true, completion: nil)
        }
        else {
            let error = UIAlertView()
            error.title = "No Facebook Account Available"
            error.message = "You can add a Facebook account to share from in your Settings."
            error.addButtonWithTitle("OK")
            error.show()
        }
    }
    
    /**
    Used to take a screenshot of the current cocos2d scene.
    
    - returns:  a screenshot in the form of a `UIImage`
    */
    func takeScreenshot() -> UIImage {
        CCDirector.sharedDirector().nextDeltaTimeZero = true
        
        let width = Int32(CCDirector.sharedDirector().viewSize().width)
        let height = Int32(CCDirector.sharedDirector().viewSize().height)
        let renderTexture: CCRenderTexture = CCRenderTexture(width: width, height: height)
    
        // pixelFormat:CCTexturePixelFormat_RGBA8888 depthStencilFormat:0
        renderTexture.begin()
        CCDirector.sharedDirector().runningScene.visit()
        renderTexture.end()
        
        return renderTexture.getUIImage()
    }
}