//
//  MainViewController.swift
//  Hide-And-Seek
//
//  Created by Neena Dugar on 29/07/2017.
//  Copyright © 2017 Nidhi Manoj. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import Firebase
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    let ref = Database.database().reference()
    var locationManager:CLLocationManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let currentUser = Auth.auth().currentUser {
            nameLabel.text = currentUser.displayName
            self.ref.child("users").child(currentUser.uid).setValue(["name":currentUser.displayName])
            determineMyCurrentLocation()
            let userRef = self.ref.child("users/\(currentUser.uid)")
            userRef.observe(.value, with: { snapshot in
                print(snapshot.value)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func determineMyCurrentLocation() {
        print("asking for location...")
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
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        if let currentUser = Auth.auth().currentUser {
            self.ref.child("users/\(currentUser.uid)/latitude").setValue(userLocation.coordinate.latitude)
            self.ref.child("users/\(currentUser.uid)/longitude").setValue(userLocation.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
