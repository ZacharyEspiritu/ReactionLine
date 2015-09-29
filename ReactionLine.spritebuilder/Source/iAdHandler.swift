//
//  iAdHandler.swift
//
//  Created by Zachary Espiritu on 7/19/15.
//  Copyright (c) 2015 Zachary Espiritu.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import iAd

enum BannerPosition {
    case Top, Bottom
}

class iAdHandler: NSObject {
    
    // MARK: Variables
    
    let view = CCDirector.sharedDirector().parentViewController!.view // Returns a UIView of the cocos2d parent view controller.
    
    var adBannerView = ADBannerView(frame: CGRect.zero)
    var bannerPosition: BannerPosition = .Top
    var isBannerDisplaying: Bool = false
    
    var interstitial = ADInterstitialAd()
    var interstitialAdView: UIView = UIView()
    var interstitialIndexingNumber: Int = 0
    var isInterstitialDisplaying: Bool = false
    var isInterstitialLoaded: Bool = false
    
    var closeButton: UIButton!
    
    
    // MARK: Singleton
    
    class var sharedInstance : iAdHandler {
        struct Static {
            static let instance : iAdHandler = iAdHandler()
        }
        return Static.instance
    }
    
    
    // MARK: Banner Ad Functions
    
    /**
    Sets the position of the soon-to-be banner ad and attempts to load a new ad from the iAd network.
    
    - parameter bannerPosition:  the `BannerPosition` at which the ad should be positioned initially
    */
    func loadAds(bannerPosition bannerPosition: BannerPosition) {
        self.bannerPosition = bannerPosition
        
        if bannerPosition == .Top {
            adBannerView.center = CGPoint(x: adBannerView.center.x, y: -(adBannerView.frame.size.height / 2))
        }
        else {
            adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height + (adBannerView.frame.size.height / 2))
        }
        
        adBannerView.delegate = self
        adBannerView.hidden = true
        adBannerView.backgroundColor = UIColor.clearColor()
        view.addSubview(adBannerView)
    }
    
    /**
    Repositions the `adBannerView` to the designated `bannerPosition`.
    
    - parameter bannerPosition:  the `BannerPosition` at which the ad should be positioned
    */
    func setBannerPosition(bannerPosition bannerPosition: BannerPosition) {
        self.bannerPosition = bannerPosition
    }
    /**
    Displays the `adBannerView` with a short animation for polish.
    
    If a banner ad has not been successfully loaded, nothing will happen.
    */
    func displayBannerAd() {
        if adBannerView.bannerLoaded {
            adBannerView.hidden = false
            isBannerDisplaying = true
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                if self.bannerPosition == .Top {
                    self.adBannerView.center = CGPoint(x: self.adBannerView.center.x, y: (self.adBannerView.frame.size.height / 2))
                }
                else {
                    self.adBannerView.center = CGPoint(x: self.adBannerView.center.x, y: self.view.bounds.size.height - (self.adBannerView.frame.size.height / 2))
                }
            })
        }
        else {
            print("Did not display ads because banner isn't loaded yet!")
        }
    }
    
    /**
    Hides the `adBannerView` with a short animation for polish.
    
    If a banner ad has not been successfully loaded, nothing will happen.
    */
    func hideBannerAd() {
        if adBannerView.bannerLoaded {
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                if self.bannerPosition == .Top {
                    self.adBannerView.center = CGPoint(x: self.adBannerView.center.x, y: -(self.adBannerView.frame.size.height / 2))
                }
                else {
                    self.adBannerView.center = CGPoint(x: self.adBannerView.center.x, y: self.view.bounds.size.height + (self.adBannerView.frame.size.height / 2))
                }
            })
            delay(0.5) {
                self.adBannerView.hidden = true
                self.isBannerDisplaying = false
            }
        }
    }
    
    
    // MARK: Interstitial Functions
    
    /**
    Attempts to load an interstitial ad.
    */
    func loadInterstitialAd() {
        interstitial.delegate = self
    }
    
    /**
    Displays the `interstitial`.
    
    If an interstitial has not been successfully loaded, nothing will happen.
    */
    func displayInterstitialAd() {
        
        if interstitial.loaded {
    
            view.addSubview(interstitialAdView)
            interstitial.presentInView(interstitialAdView)
            UIViewController.prepareInterstitialAds()
            
            closeButton = UIButton(frame: CGRect(x: 15, y: 15, width: 25, height: 25))
            closeButton.setBackgroundImage(UIImage(named: "close"), forState: UIControlState.Normal)
            closeButton.addTarget(self, action: Selector("close"), forControlEvents: UIControlEvents.TouchDown)
            self.view.addSubview(closeButton)
            
            isInterstitialDisplaying = true
            
            self.interstitialAdView.center = CGPoint(x: self.interstitialAdView.center.x, y: (self.view.bounds.size.height * 1.5))
            self.closeButton.hidden = true
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                self.interstitialAdView.center = CGPoint(x: self.interstitialAdView.center.x, y: (self.view.bounds.size.height / 2))
                self.closeButton.hidden = false
            })
            
            print("Interstitial displaying!")
        }
        else {
            print("Interstitial not loaded yet!")
        }
        
    }

    /**
    Checks to see if an interstitial should be displayed in this round based on the `interstitialIndexingNumber`.
    */
    func checkIfInterstitialAdShouldBeDisplayed() {
        if interstitial.loaded {
            switch interstitialIndexingNumber % 3 {
            case 0:
                print("Interstitial should be displayed now!")
                displayInterstitialAd()
            default:
                print("Interstitial should not be displayed yet!")
                break
            }
            interstitialIndexingNumber++
        }
        else {
            print("Interstitial isn't loaded yet!")
        }
    }
    
    
    func close() {
        if isInterstitialDisplaying {
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                self.interstitialAdView.center = CGPoint(x: self.interstitialAdView.center.x, y: (self.view.bounds.size.height * 1.5))
                self.closeButton.center = CGPoint(x: -15, y: self.closeButton.center.y)
            })
            delay(0.5) {
                self.interstitialAdView.removeFromSuperview()
                self.closeButton.removeFromSuperview()
                self.isInterstitialDisplaying = false
                self.interstitial = ADInterstitialAd()
                self.interstitial.delegate = self
            }
        }
    }
    
    // MARK: Convenience Functions
    
    /**
    When called, delays the running of code included in the `closure` parameter.
    
    - parameter delay:  how long, in milliseconds, to wait until the program should run the code in the closure statement
    */
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

extension iAdHandler: ADInterstitialAdDelegate {
    
    /**
    Called whenever a interstitial successfully loads.
    */
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
        interstitialAdView = UIView()
        interstitialAdView.frame = self.view.bounds
        isInterstitialLoaded = true
        
        print("Succesfully loaded interstitital!")
    }
    
    /**
    Called whenever the interstitial's action finishes; e.g.: the user has already clicked on the ad and decides to exit out or the ad campaign finishes.
    */
    func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.interstitialAdView.center = CGPoint(x: self.interstitialAdView.center.x, y: (self.view.bounds.size.height * 1.5))
            self.closeButton.center = CGPoint(x: -15, y: self.closeButton.center.y)
        })
        delay(0.5) {
            self.interstitialAdView.removeFromSuperview()
            self.closeButton.removeFromSuperview()
            self.isInterstitialDisplaying = false
            self.isInterstitialLoaded = false
            self.interstitial = ADInterstitialAd()
            self.interstitial.delegate = self
        }
    }
    
    /**
    Called whenever an interstitial ad is about to be displayed.
    */
    func interstitialAdActionShouldBegin(interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    /**
    Called whenever an interstitial ad unloads automatically.
    */
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
        if isInterstitialDisplaying {
            interstitialAdView.removeFromSuperview()
            closeButton.removeFromSuperview()
            isInterstitialDisplaying = false
        }
        isInterstitialLoaded = false
        interstitial = ADInterstitialAd()
        interstitial.delegate = self
        
        print("Interstitial unloaded")
    }
    
    /**
    Called when a interstitial was unable to be loaded.
    */
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        print("Was not able to load an interstitial with error: \(error)")
        if !isInterstitialLoaded {
            interstitial = ADInterstitialAd()
            interstitial.delegate = self
        }
    }
}

extension iAdHandler: ADBannerViewDelegate {
    
    /**
    Called whenever a banner ad successfully loads.
    */
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        print("Successfully loaded banner!")
    }
    
    /**
    Called when a banner ad was unable to be loaded.
    */
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        print("Was not able to load a banner with error: \(error)")
    }
}