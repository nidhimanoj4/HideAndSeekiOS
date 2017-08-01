//
//  SeekerViewController.swift
//  Hide-And-Seek
//
//  Created by Makena Low on 7/29/17.
//  Copyright © 2017 Nidhi Manoj. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import CoreLocation

class SeekerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    var users : [String] = []
    var names : [String: String] = [:]
    var lats : [String: Float] = [:]
    var longs : [String: Float] = [:]
    var distances : [String: Int] = [:]
    var gameID : String = ""
    let ref = Database.database().reference()
    let convFactor = 3280.4 as Float
    var locationManager:CLLocationManager!

    @IBOutlet weak var timeLabel: UILabel!

    let formatter = DateFormatter()
    let userCalendar = Calendar.current;
    let requestedComponent : Set<Calendar.Component> = [
    Calendar.Component.hour,
    Calendar.Component.minute,
    Calendar.Component.second
    ]


    @IBOutlet weak var playerList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playerList.dataSource = self
        playerList.delegate = self
        if let currentUser = Auth.auth().currentUser {
            self.ref.removeAllObservers()
            self.ref.child("users/\(currentUser.uid)").observeSingleEvent(of: .value, with: { (user_snapshot) in
                self.gameID = user_snapshot.childSnapshot(forPath: "current_game").value as? String ?? ""
                self.ref.child("games/\(self.gameID)").observeSingleEvent(of: .value, with: { (game_snapshot) in
                    print(game_snapshot)
                    if let players = game_snapshot.childSnapshot(forPath: "players").children.allObjects as? [DataSnapshot] {
                        print(players)
                        var user : String = ""
                        for player in players {
                            user = player.value as? String ?? ""
                            if (user != currentUser.uid){
                                self.users.append(user)
                                self.ref.child("users/\(user)").observe(.value, with: { (user_snapshot) in
                                    self.names[user] = user_snapshot.childSnapshot(forPath: "name").value as? String ?? ""
                                    self.lats[user] = user_snapshot.childSnapshot(forPath: "latitude").value as? Float ?? 0
                                    self.longs[user] = user_snapshot.childSnapshot(forPath: "longitude").value as? Float ?? 0
                                    self.playerList.reloadData()
                                })
                            }
                        }
                    }
                })
            })
            
            determineMyCurrentLocation()
        }
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timePrinter), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.playerList.dequeueReusableCell(withIdentifier: "distcell", for: indexPath) as! DistTableViewCell
        cell.nameLabel.text = self.names[users[indexPath.row]]
        if (self.distances[users[indexPath.row]] != nil){
            cell.distanceLabel.text = "\(self.distances[users[indexPath.row]]!)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
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
            for user in self.users {
                if (self.lats[user] != nil && self.longs[user] != nil){
                    self.distances[user] = Int(floor(sqrt(pow((Float(userLocation.coordinate.latitude)-self.lats[user]!),2)+pow((Float(userLocation.coordinate.longitude)-self.longs[user]!),2))*self.convFactor))
                }
            }
            self.playerList.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    func timeCalculator(dateFormat: String, endTime: String, startTime: Date = Date()) -> DateComponents {
        formatter.dateFormat = dateFormat
        let _startTime = startTime
        let _endTime = formatter.date(from: endTime)
        
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: _startTime, to: _endTime!)
        return timeDifference
    }
    
    func timePrinter() -> Void {
        let time = timeCalculator(dateFormat: "MM/dd/yyyy hh:mm:ss a", endTime: "07/30/2017 12:00:00 p")
        timeLabel.text = "\(time.minute!) Minutes \(time.second!) Seconds" // FIX ME
    }
}
