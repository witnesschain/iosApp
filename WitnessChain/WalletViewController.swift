//
//  WalletViewController.swift
//  WitnessChain
//
//  Created by Dhruv Gupta on 4/11/18.
//  Copyright © 2018 Kevin  Sadhu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI

class WalletViewController: UIViewController {

    let user = Auth.auth().currentUser

    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userEmail.text = user?.email
        
    }
    
    @IBAction func logout(sender: Any?){
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "walletlogout", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
