//
//  AdMobManager.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 28/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import Foundation
import GoogleMobileAds

class AdMob {
    
    static let shared = AdMob()
    private init() {}
    
    //test IDs
    private let bannerID = "ca-app-pub-3940256099942544/2934735716"
    private let interstitialID = "ca-app-pub-3940256099942544/4411468910"
    
    //production IDs
//    private let bannerID = "your id here"
//    private let interstitialID = "your id here"

    func set(banner : GADBannerView, inVC vc: UIViewController) {
        banner.adUnitID = bannerID
        banner.rootViewController = vc
        banner.load(GADRequest())
    }
    
    
    // NOT USED AT THE MOMENT
//    private var interstitialAd : GADInterstitial!
//    
//    func requestInterstitialAd() {
//        interstitialAd = GADInterstitial(adUnitID: interstitialID)
//        let request = GADRequest()
//        interstitialAd.load(request)
//    }
//    
//    func showInterstitialAd(inVC vc : UIViewController) {
//        if interstitialAd.isReady {
//            interstitialAd.present(fromRootViewController: vc)
//            requestInterstitialAd()
//        } else {
//            print("Ad wasn't ready")
//        }
//    }
}

