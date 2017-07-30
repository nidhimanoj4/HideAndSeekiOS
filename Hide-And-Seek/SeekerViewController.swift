//
//  SeekerViewController.swift
//  Hide-And-Seek
//
//  Created by Makena Low on 7/29/17.
//  Copyright © 2017 Nidhi Manoj. All rights reserved.
//

import UIKit

class SeekerViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    let formatter = DateFormatter()
    let userCleander = Calendar.current;
    let requestedComponent : Set<Calendar.Component> = [
        Calendar.Component.hour,
        Calendar.Component.minute,
        Calendar.Component.second
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timePrinter), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timeCalculator(dateFormat: String, endTime: String, startTime: Date = Date()) -> DateComponents {
        formatter.dateFormat = dateFormat
        let _startTime = startTime
        let _endTime = formatter.date(from: endTime)
        
        let timeDifference = userCleander.dateComponents(requestedComponent, from: _startTime, to: _endTime!)
        return timeDifference
    }
    
    func timePrinter() -> Void {
        let time = timeCalculator(dateFormat: "MM/dd/yyyy hh:mm:ss a", endTime: "07/30/2017 04:30:00 a")
        timeLabel.text = "\(time.minute!) Minutes \(time.second!) Seconds"
    }
    
}
