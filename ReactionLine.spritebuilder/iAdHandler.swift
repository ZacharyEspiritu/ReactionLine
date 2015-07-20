//
//  iAdInteractor.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import iAd

enum BannerPosition {
    case Top, Bottom
}

class iAdHandler: NSObject, ADBannerViewDelegate {
    
    // MARK: Variables
    
    let view = CCDirector.sharedDirector().parentViewController!.view // Returns a UIView
    
    var adBannerView = ADBannerView(frame: CGRect.zeroRect)
    var bannerPosition: BannerPosition = .Top
    
    
    // MARK: Singleton
    
    class var sharedInstance : iAdHandler {
        struct Static {
            static let instance : iAdHandler = iAdHandler()
        }
        return Static.instance
    }
    
    
    // MARK: Functions
    
    func loadAds(#bannerPosition: BannerPosition) {
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
    
    func moveAdsToNewPosition(#bannerPosition: BannerPosition) {
        self.bannerPosition = bannerPosition
    }
    
    func displayAds() {
        if adBannerView.bannerLoaded {
            adBannerView.hidden = false
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
            println("Did not display ads because banner isn't loaded yet!")
        }
    }
    
    func hideAds() {
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
            }
        }
    }
    
    
    // MARK: Functions Inherited From Delegate
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        println("Successfully loaded banner!")
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        println("Was not able to load a banner with error: \(error)")
        adBannerView.hidden = true
    }
    
    
    // MARK: Convenience Functions
    
    /**
    When called, delays the running of code included in the `closure` parameter.
    
    :param: delay  how long, in milliseconds, to wait until the program should run the code in the closure statement
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