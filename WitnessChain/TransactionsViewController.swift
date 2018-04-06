//
//  TransactionsViewController.swift
//  WitnessChain
//
//  Created by Dhruv Gupta on 4/5/18.
//  Copyright © 2018 Kevin  Sadhu. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class TransactionsViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var photo: UIImageView!
    var image: UIImage!
    var userLocation: CLLocation!
    
    let storage = Storage.storage()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
        
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1. status is not determined
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            let alertController = UIAlertController(title: "WitnessChain", message:
                "Location services were previously denied. Please enable location services for this app in Settings.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
            // 3. we do have authorization
        else {
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location
            print("Found user's location: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        
        print("error:: \(error.localizedDescription)")
        
    }
    
    
    @IBAction func dismissButton_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func uploadButton_TouchUpInside(_ sender: Any) {
        
        let curtime:Double = NSDate().timeIntervalSince1970
        
        // TODO: SHOW LOADING THING OR PROGRESS BAR UNTIL YOU HAVE LOCATION/WHILE UPLOAD IS HAPPENING
        
        print("Found user's location: \(userLocation) and time \(curtime)")
        
        let imageName:String = String("\(curtime).jpg")
        
        let storageRef = storage.reference().child("evidence").child(imageName)
        if let uploadData = UIImageJPEGRepresentation(image!, 0.75) {
            
            storageRef.putData(uploadData, metadata: nil
                , completion: { (metadata, error) in
                    if error != nil {
                        print("error")
                        print(error!)
                        return
                    }else{
                    }
                    
                    let strPic:String = (metadata?.downloadURL()?.absoluteString)!
                    
                    print(metadata!)
                    //self.imagePath = (metadata?.downloadURL()?.absoluteString)!
                    //self.sendMessageOnServer()
                    print("\n\n ===download url : \(strPic)")
                    
            })
            
        }
        
        let alertController = UIAlertController(title: "WitnessChain", message:
            "Image uploaded to Server", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveButton_TouchUpInside(_ sender: Any) {
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
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
