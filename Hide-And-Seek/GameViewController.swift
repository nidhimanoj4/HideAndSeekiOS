//
//  StartNewGameViewController.swift
//  Hide-And-Seek
//
//  Created by Makena Low on 7/29/17.
//  Copyright © 2017 Nidhi Manoj. All rights reserved.
//
import UIKit
import Foundation
import Firebase
import FirebaseDatabase

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let ref = Database.database().reference()
    var data: [String] = []
    var newestUser : String = ""
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var playerList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerList.dataSource = self
        playerList.delegate = self
        
        if let currentUser = Auth.auth().currentUser {
            let gameID = randomString(length: 8)
            let gameRef = self.ref.child("games/\(gameID)")
            
            gameRef.setValue([]) //Clear any previous value
            gameRef.child("players").childByAutoId().setValue(currentUser.uid)
            
            self.codeLabel.text = gameID
            
            gameRef.child("players").observe(.childAdded, with: { snapshot in
                var userid : String = snapshot.value as! String
                self.ref.child("users").child(userid).observeSingleEvent(of: .value, with: { (user_snapshot) in
                    self.data.append(user_snapshot.childSnapshot(forPath: "name").value as! String)
                    self.playerList.reloadData()
                })
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.Greylock-Hide-And-Seek.playerCell", for: indexPath) as! PlayerListTableViewCell
        cell.playerNameLabel.text = self.data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyz0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
