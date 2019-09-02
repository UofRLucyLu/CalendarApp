//
//  CalendarItem.swift
//  CalendarApp
//
//  Created by apple on 11/28/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

//get all the components needed for a calendar presented
let date = Date()
let calendar = Calendar.current

let day = 2
//calendar.component(.day, from: date)
let weekday = 1
//calendar.component(.weekday, from: date)

//this will be changed once we click buttons, but initialized value will always be current
var month = calendar.component(.month, from: date)
var year = calendar.component(.year, from: date)
