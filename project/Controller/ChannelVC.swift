//
//  ChannelVC.swift
//  project
//
//  Created by Laksh on 15/03/18.
//  Copyright © 2018 Laksh. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    //Outlets
    
    @IBOutlet weak var subscriptionBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    

}
