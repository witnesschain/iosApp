//
//  UserInfoViewController.swift
//  WitnessChain
//
//  Created by Dhruv Gupta on 4/11/18.
//  Copyright © 2018 Kevin  Sadhu. All rights reserved.
//

import Foundation
import Firebase

class UserInfoViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    let user = Auth.auth().currentUser
    @IBOutlet weak var PublicKeyField: UITextField!
    
    @IBOutlet weak var PrivateKeyField: UITextField!
    
    @IBOutlet weak var AddressField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // set public key field, private key field, address field to something default
        
        // TODO: ACTUALLY POPULATE THESE FIELDS WITH REAL STUFF
        
        PublicKeyField.text = "something random"
        
        PrivateKeyField.text = "something more random"
        
        AddressField.text = "1201 Mass Ave"
        
    }
    
    @IBAction func submit(_ sender: Any) {
        // set value for firebase
        // permission = 1 is user, 0 is admin, 2 is police
        
        // TODO: CHECK IF VALUES NOT NULL
        
        ref.child("users").child(user!.uid).setValue([
            "publickey": PublicKeyField.text!,
            "privatekey": PrivateKeyField.text!,
            "address": AddressField.text!,
            "permission": 1
            ])
        self.performSegue(withIdentifier: "userinfotoscroll", sender: nil)
        
    }
}
