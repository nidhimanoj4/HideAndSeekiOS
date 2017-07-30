//
//  CameraViewController.swift
//  Hide-And-Seek
//
//  Created by Makena Low on 7/29/17.
//  Copyright © 2017 Nidhi Manoj. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    //save photo to user's photos
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet var viewOfScreen: UIView!
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var frontCamera: Bool = false
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    
    @IBAction func flipCameraButtonClicked(_ sender: UIButton) {
        // Switch camera to frontal
        frontCamera = !frontCamera
        captureSession.beginConfiguration()
        let inputs = captureSession.inputs as! [AVCaptureInput]
        for oldInput: AVCaptureInput in inputs {
            captureSession.removeInput(oldInput)
        }
        frontCameraFunc(frontCamera)
        captureSession.commitConfiguration()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        frontCameraFunc(frontCamera)
        viewOfScreen.bringSubview(toFront: takePictureButton)
        viewOfScreen.bringSubview(toFront: flashButton)
        viewOfScreen.bringSubview(toFront: flipCameraButton)

        if captureDevice != nil {
            beginSession()
        }
    }
    
    func beginSession() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraView.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.cameraView.layer.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureSession.startRunning()
        stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func frontCameraFunc(_ front:Bool) {
        let devices = AVCaptureDevice.devices()
        do {
            try captureSession.removeInput(AVCaptureDeviceInput(device:captureDevice))
        } catch {
            print("error")
        }
        for device in devices! {
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                if front {
                    if (device as AnyObject).position == AVCaptureDevicePosition.front {
                        captureDevice = device as? AVCaptureDevice
                        do {
                            try captureSession.addInput(AVCaptureDeviceInput(device:captureDevice))
                        } catch {}
                        break;
                    }
                } else {
                    if (device as AnyObject).position == AVCaptureDevicePosition.back {
                        captureDevice = device as? AVCaptureDevice
                        do {
                            try captureSession.addInput(AVCaptureDeviceInput(device:captureDevice))
                        } catch {}
                        break;
                    }
                }
            }
        }
    }
    
    @IBAction func takePicture(_ sender: Any) {
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataSampleBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                let image = UIImage(data: imageData!)
                print("Image taken: \(image)")
                self.cameraView.backgroundColor = UIColor(patternImage: image!)
                let imageView = UIImageView(image: image)
                imageView.frame = self.cameraView.frame
                self.cameraView.addSubview(imageView)
            })
        }
    }
    
    
    
    @IBAction func activateFlash(_ sender: Any) {
        if captureDevice!.hasTorch {
            do {
                try captureDevice!.lockForConfiguration()
                captureDevice!.torchMode = captureDevice!.isTorchActive ? AVCaptureTorchMode.off : AVCaptureTorchMode.on
                captureDevice!.unlockForConfiguration()
            } catch {
                
            }
        }
    }
    
    

    @IBAction func takeAnotherButtonClicked(_ sender: Any) {
        viewDidLoad()
    }
    
    
    
    
    
    
    
    
//    @IBOutlet weak var overlayCamera: UIView!
//    @IBOutlet weak var capturedImage: UIImageView!
//    // MARK: Local Variables
//    var captureSession: AVCaptureSession?
//    var stillImageOutput: AVCaptureStillImageOutput?
//    var previewLayer: AVCaptureVideoPreviewLayer?
//    
//    // MARK: Overrides
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        previewLayer!.frame = overlayCamera.bounds
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.cameraDidTaped))
//        overlayCamera.addGestureRecognizer(tapGesture)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        super.viewWillAppear(animated)
//        
//        captureSession = AVCaptureSession()
//        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
//        
//        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//        
//        var error: NSError?
//        var input: AVCaptureDeviceInput!
//        do {
//            input = try AVCaptureDeviceInput(device: backCamera)
//        } catch let error1 as NSError {
//            error = error1
//            input = nil
//        }
//        
//        if error == nil && captureSession!.canAddInput(input) {
//            captureSession!.addInput(input)
//            
//            stillImageOutput = AVCaptureStillImageOutput()
//            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
//            if captureSession!.canAddOutput(stillImageOutput) {
//                captureSession!.addOutput(stillImageOutput)
//            
//                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
//                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
//                overlayCamera.layer.addSublayer(previewLayer!)
//                
//                captureSession!.startRunning()
//            }
//        }
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        super.viewWillDisappear(animated)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//    func cameraDidTaped() {
//        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
//            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
//            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
//                if (sampleBuffer != nil) {
//                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
//                    let dataProvider = CGDataProvider(data: imageData as! CFData)
//                    let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
//                    let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.right)
//                    self.capturedImage.image = image
//                }
//            })
//        }
//    }
    
    
    
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    
//    
//    imagePicker = UIImagePickerController()
//    imagePicker.delegate = self
//    imagePicker.sourceType = .Camera
//    imagePicker.showsCameraControls = false
//    imagePicker.cameraOverlayView = customViewTakePhoto()
//    
//    presentViewController(imagePicker, animated: true, completion: nil)
    
}
