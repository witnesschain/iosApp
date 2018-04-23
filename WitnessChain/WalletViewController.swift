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
    var ref: DatabaseReference!
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var userPublicKey: UILabel!
    @IBOutlet weak var userPrivateKey: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        userEmail.text = user?.email
    self.ref.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.userAddress.text = value?["address"] as? String ?? ""
            self.userPublicKey.text = value?["publickey"] as? String ?? ""
            self.userPrivateKey.text = value?["privatekey"] as? String ?? ""
        }) { (error) in
            print(error.localizedDescription)
        }
        
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
