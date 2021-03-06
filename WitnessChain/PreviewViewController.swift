//
//  PreviewViewController.swift
//  WitnessChain
//
//  Created by Kevin  Sadhu on 4/2/18.
//  Copyright © 2018 Kevin  Sadhu. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import Alamofire
import SwiftLocation

class PreviewViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var photo: UIImageView!
    var image: [UIImage?] = []
    var edited_images: [UIImage?] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let storage = Storage.storage()
    
    let user = Auth.auth().currentUser
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("------")
        print (self.image)
        print (photo.image)
        print(self.edited_images)
        print ("------")
        photo.image = self.image.last!
        
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Locator.requestAuthorizationIfNeeded()
    }
    
    @IBAction func dismissButton_TouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "dismisspreview", sender: nil)
    }
    
    @IBAction func editImagePress(_ sender: Any) {
        performSegue(withIdentifier: "editImage", sender: nil)
    }
    
    @IBAction func nextPhotoButton(_ sender: Any) {
        performSegue(withIdentifier: "nextPhoto_Segue", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "nextPhoto_Segue" {
            let cameraVC = segue.destination as! CameraViewController
            print (self.image)
            print (cameraVC.image)
            cameraVC.image = self.image
            cameraVC.edited_images = self.edited_images
        } else if segue.identifier == "editImage" {
            let drawVC = segue.destination as! DrawingViewController
            print (self.image)
            print (drawVC.image)
            drawVC.image = self.image
            drawVC.edited_images = self.edited_images
        }
    }
    
    @IBAction func uploadButton_TouchUpInside(_ sender: Any) {
        
        let curtime:Int = Int(NSDate().timeIntervalSince1970*10000)

        let progressHUD = ProgressHUD(text: "Uploading")
        self.view.addSubview(progressHUD)
        
        SwiftLocation.Locator.currentPosition(accuracy: .city, timeout: nil, onSuccess: { userLocation in
        
            print("Have user's location: \(userLocation) and time \(curtime)")
    
            var images : [String] = []
            var blurred_images : [String] = []
            var imgname : String = ""
            var ct : Int = 0
            var picture : UIImage
            let range = self.image.count + self.edited_images.count - 1
            for i in 0...range {
                let imageName:String = String("\(curtime)-\(i).jpg")
                let storageRef = self.storage.reference().child("evidence").child(imageName)
                if i < self.image.count{
                    picture = self.image[i]!
                }
                else{
                    picture = self.edited_images[i - self.image.count]!
                }
                if let uploadData = UIImageJPEGRepresentation(picture, 0.75) {
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print("error")
                            print(error!)
                            return
                        }
                        ct += 1
                        let strPic:String = (metadata?.downloadURL()?.absoluteString)!
                    
                        imgname = (metadata?.name)!
                        
                        let idx = imgname.index(imgname.endIndex, offsetBy: -4)
                        let imgshort = String(imgname[..<idx])
                        self.ref.child("users").child(self.user!.uid).child("evidences").child(imgshort).setValue(imgname)
                    
                        print(metadata!)
                        //self.imagePath = (metadata?.downloadURL()?.absoluteString)!
                        //self.sendMessageOnServer()
                        print("\n\n ===download url : \(strPic)")
                    
                        print("\n\n ===image name : \(imgname)")
                        
                        if i < self.image.count{
                            images.append(imgname)
                        }
                        else{
                            blurred_images.append(imgname)
                        }
                        
                        print(ct)
                        print(range)
                        
                        if ct == range {
                            print("ello")
                            let url = URL(string: self.appDelegate.baseUrl + "/new")!
                            let parameters : [String:Any] = ["clear_images": images,
                                                             "blurred_images": blurred_images,
                                                             "latitude": Int(userLocation.coordinate.latitude*100000000),
                                                             "longitude": Int(userLocation.coordinate.longitude*100000000),
                                                             "price": "5000000000000000000", // 5 ether, in wei
                                                             "description": "parking",
                                                             "creator_address": "0x821aEa9a577a9b44299B9c15c88cf3087F3b5544",
                                                             "receiver_address": "0x0d1d4e623D10F9FBA5Db95830F7d3839406C6AF2",
                                                             "violation_type": 1
                            ]
                            
                            
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
                                    let alertController = UIAlertController(title: "WitnessChain", message:
                                        "Image uploaded to Server: :)", preferredStyle: UIAlertControllerStyle.alert)
                                    alertController.addAction(UIAlertAction(title: "Great!", style: UIAlertActionStyle.destructive, handler: {
                                        action in                                    self.navigationController?.popViewController(animated: true)
                                        
                                        self.dismiss(animated: true, completion: nil)
                                    }))
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                    
                                    progressHUD.hide()
                                }
                            }
                            
                        }
                        
                        })
                }
            }
        }) { (err, last) -> (Void) in
            print("Failed to get location: \(err)")
            
        }
    }
    
    @IBAction func saveButton_TouchUpInside(_ sender: Any) {
        
        UIImageWriteToSavedPhotosAlbum(image.last!!, nil, nil, nil)
        
        let alertController = UIAlertController(title: "WitnessChain", message:
            "Image evidence saved to Camera Roll", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

