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
    
    @IBOutlet weak var tfName:  UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPw:    UITextField!
    @IBOutlet weak var tfPw2:   UITextField!
    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideShowTextFields()
    }

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        hideShowTextFields()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    private func hideShowTextFields() {
        let isSignInChosen = segment.selectedSegmentIndex == 0
        tfName.isHidden = isSignInChosen
        tfPw2.isHidden = isSignInChosen
    }
}

