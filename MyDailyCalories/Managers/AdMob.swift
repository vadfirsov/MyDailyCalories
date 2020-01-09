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
    
    //test IDs mockdata
//    private let bannerID = "ca-app-pub-3940256099942544/2934735716"
//    private let interstitialID = "ca-app-pub-3940256099942544/4411468910"
    
    //production IDs
    private let bannerID = "ca-app-pub-6578020008336008/2437993672"
    private let interstitialID = "ca-app-pub-6578020008336008/1667837487"

    func set(banner : GADBannerView, inVC vc: UIViewController) {
        banner.adUnitID = bannerID
        banner.rootViewController = vc
        banner.load(GADRequest())
    }
    
    // NOT USED AT THE MOMENT
    private var interstitialAd : GADInterstitial!

    func requestInterstitialAd() {
        interstitialAd = GADInterstitial(adUnitID: interstitialID)
        let request = GADRequest()
        interstitialAd.load(request)
    }
    
    func showInterstitialAd(inVC vc : UIViewController) {
        if interstitialAd.isReady {
            interstitialAd.present(fromRootViewController: vc)
        }
    }
}

