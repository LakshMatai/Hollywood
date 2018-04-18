//
//  SignInViewController.swift
//  project
//
//  Created by Laksh on 15/04/18.
//  Copyright © 2018 Laksh. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signInBtn: UIButton!
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newUserBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "newUserSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInBtn.layer.cornerRadius=5
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
