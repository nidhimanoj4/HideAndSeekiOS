//
//  JoinGameViewController.swift
//  Hide-And-Seek
//
//  Created by Makena Low on 7/29/17.
//  Copyright © 2017 Nidhi Manoj. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase
import CoreLocation

class JoinGameViewController: UIViewController, CLLocationManagerDelegate {
    let ref = Database.database().reference()
    var locationManager:CLLocationManager!
    
    @IBOutlet weak var enteredCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let currentUser = Auth.auth().currentUser {
            // Initialize the user in firebase with location
            self.ref.child("users").child(currentUser.uid).setValue(["name":currentUser.displayName])
            determineMyCurrentLocation()
            let userRef = self.ref.child("users/\(currentUser.uid)")
            userRef.observe(.value, with: { snapshot in
                print(snapshot.value ?? "Snapshot not found")
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func joinGameButtonClicked(_ sender: UIButton) {
        if let currentUser = Auth.auth().currentUser {
            let enteredGameCode = enteredCodeTextField.text ?? ""
            self.ref.child("games/\(enteredGameCode)/players").childByAutoId().setValue(currentUser.uid)
            self.ref.child("users/\(currentUser.uid)/current_game").setValue(enteredGameCode)
            self.ref.child("games/\(enteredGameCode)/status").observe(.value, with: { snapshot in
                print((snapshot.value as? String ?? ""))
                if ((snapshot.value as? String ?? "") == "active"){
                    self.ref.removeAllObservers()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "HiderViewController")
                    self.present(controller, animated: true, completion: nil)
                }
            })
            // Initialize the tableView and the code at the top
            
            
        }
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        // Calling stopUpdatingLocation() will stop listening for location updates.
        // Do not call this function because we want the function to be called every time when user location changes.
        // manager.stopUpdatingLocation()
//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
        if let currentUser = Auth.auth().currentUser {
            // Set the current user's location in Firebase
            self.ref.child("users/\(currentUser.uid)/latitude").setValue(userLocation.coordinate.latitude)
            self.ref.child("users/\(currentUser.uid)/longitude").setValue(userLocation.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
}
