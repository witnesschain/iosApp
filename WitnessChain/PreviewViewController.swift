//
//  PreviewViewController.swift
//  WitnessChain
//
//  Created by Kevin  Sadhu on 4/2/18.
//  Copyright © 2018 Kevin  Sadhu. All rights reserved.
//

import UIKit
import Firebase

class PreviewViewController: UIViewController {
    @IBOutlet var photo: UIImageView!
    var image: UIImage!

    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelButton_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func uploadButton_TouchUpInside(_ sender: Any) {
        
        let imageName:String = String("image.png")
        
        let storageRef = storage.reference().child("evidence").child(imageName)
        if let uploadData = UIImagePNGRepresentation(image!) {
        
            storageRef.putData(uploadData, metadata: nil
                , completion: { (metadata, error) in
                    if error != nil {
                        print("error")
                        print(error)
                        return
                    }else{
                    }
                    
                    let strPic:String = (metadata?.downloadURL()?.absoluteString)!
                    
                    print(metadata!)
                    //self.imagePath = (metadata?.downloadURL()?.absoluteString)!
                    //self.sendMessageOnServer()
                    print("\n\n\n\n\n\n ===download url : \(strPic)")
                    
            })
            
        }
        
        let alertController = UIAlertController(title: "WitnessChain", message:
            "Image uploaded to Server", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
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
