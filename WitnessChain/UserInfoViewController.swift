//
//  UserInfoViewController.swift
//  WitnessChain
//
//  Created by Dhruv Gupta on 4/11/18.
//  Copyright © 2018 Kevin  Sadhu. All rights reserved.
//

import Foundation
import Firebase
import Alamofire


class UserInfoViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let user = Auth.auth().currentUser
    @IBOutlet weak var PublicKeyField: UITextField!
    
    @IBOutlet weak var PrivateKeyField: UITextField!
    
    @IBOutlet weak var AddressField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // set public key field, private key field, address field to something default
        
        // TODO: ACTUALLY POPULATE THESE FIELDS WITH REAL STUFF
        let url = URL(string: self.appDelegate.baseUrl + "/address")! // calling the address function from the API
        let parameters = ["password": "harshalkevin"]
        
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                //                                self.dismiss(animated: true, completion: nil) // dismiss the image preview somehow
            }
        }
        
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
