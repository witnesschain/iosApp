//
//  ViewController.swift
//  WitnessChain
//
//  Created by Kevin  Sadhu on 4/1/18.
//  Copyright © 2018 Kevin  Sadhu. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class ViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
        let url = URL(string: "http://10.251.176.44:3000/basic_square")!
        
        let parameters = ["x": 14]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                let alertController = UIAlertController(title: "WitnessChain", message:
                    utf8Text, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)

            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    @IBAction func swipe_right(_ sender: UISwipeGestureRecognizer) {
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
    }
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices{
            if device.position == AVCaptureDevice.Position.back{
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
        }
        
        currentCamera = backCamera
    }
    
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format:[AVVideoCodecKey: AVVideoCodecType.jpeg])],completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            
            
        }catch{
            print(error)
        }
        
        
    }
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
        
    }
    func startRunningCaptureSession() {
        captureSession.startRunning()
        
    }

    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
       // performSegue(withIdentifier: "showPhoto_Segue", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showPhoto_Segue"{
            let previewVC = segue.destination as! PreviewViewController
            previewVC.image = self.image
        }
    }


}

extension ViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "showPhoto_Segue", sender: nil)
        }
    }
}

