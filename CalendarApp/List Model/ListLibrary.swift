//
//  ListLibrary.swift
//  CalendarApp
//
//  Created by apple on 11/30/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
import UIKit

class ListLibrary: Codable {
    
    //no default initialization
    
    //all events
    var listDocs = [String : ListDocument]()
    
    func addDocs(day: Int, month: Int, year: Int, listDoc: ListDocument) {
        let key = "\(day) \(month) \(year)"
        listDocs[key] = listDoc   //put event document with the associated key
    }
    
}
