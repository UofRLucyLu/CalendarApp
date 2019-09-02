//
//  EventItems.swift
//  CalendarApp
//
//  Created by apple on 11/29/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
import UIKit

class EventItems: Codable {
    
    //the name, time and lcoation for the event
    var eventName: String
    var eventMonth = ""
    var eventDay = ""
    var eventTime = ""
    var eventLoc = ""
    
    //other purpose var
    var eventHour = 0
    var eventMinute = 0
    
    //index
    var index = 0
    
    //store the description
    var eventDes = ""
    
    //add image represents prioirity and add extra features to identify priority
    
    // designated initializer
    init(name: String, index : Int) {
        self.eventName = name
        self.index = index
    }
    
    //if anything filled in for hour and minute
    func setTime(month: String, day: String, hour: String, min: String){
        eventMonth = month
        eventDay = day
        
        //given the above data, combine
        eventTime = "\(hour) : \(min)"
        
        //pass the int value
        eventHour = Int(hour)!
        eventMinute = Int(min)!
    }
    
    func setLoc(loc: String){
        eventLoc = loc
    }
    
    func setDes(des: String){
        eventDes = des
    }
}
