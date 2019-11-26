//
//  LoginVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 26/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class LoginVC : UIViewController {
    
    private let segueID = "goToDailyCals"
    private let signUpIndex = 1
    private let signInIndex = 0
    private var isSignInSelected = false
    
    @IBOutlet weak var tfName:  UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPw:    UITextField!
    @IBOutlet weak var tfPw2:   UITextField!
    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideTextFields(ifSignInSelected: true)
    }

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        hideTextFields(ifSignInSelected: (segment.selectedSegmentIndex == signInIndex))
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    private func hideTextFields(ifSignInSelected isSignInSelected : Bool) {
        tfName.isHidden = isSignInSelected
        tfPw2.isHidden = isSignInSelected
    }
}
