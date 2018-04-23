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
    
    var PrivateKeyLabel: String!
    let user = Auth.auth().currentUser
    @IBOutlet weak var PublicKeyField: UITextField!
    
    var AddressField: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // set public key field, private key field, address field to something default
        
        // TODO: ACTUALLY POPULATE THESE FIELDS WITH REAL STUFF
        let url = URL(string: self.appDelegate.baseUrl + "/address")! // calling the address function from the API
        let pubKey = self.PublicKeyField.text
        let parameters = ["password": pubKey]
        
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value as? [String: Any]{
                print("JSON: \(json)") // serialized json response
                self.PublicKeyField.text = pubKey
                let keyObj = json["keyObject"] as? [String: Any]
                self.AddressField = keyObj!["address"] as! String
                self.PrivateKeyLabel = json["privateKey"] as! String
                
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                //                                self.dismiss(animated: true, completion: nil) // dismiss the image preview somehow
            }
        }
        
        
    }
    
    @IBAction func submit(_ sender: Any) {
        // set value for firebase
        // permission = 1 is user, 0 is admin, 2 is police
        
        // TODO: CHECK IF VALUES NOT NULL
        
        ref.child("users").child(user!.uid).setValue([
            "publickey": PublicKeyField.text!,
            "privatekey": PrivateKeyLabel!,
            "address": AddressField!,
            "permission": 1
            ])
        self.performSegue(withIdentifier: "userinfotoscroll", sender: nil)
        
    }
}
