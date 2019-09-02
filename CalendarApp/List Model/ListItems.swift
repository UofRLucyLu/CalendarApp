//
//  ListItems.swift
//  CalendarApp
//
//  Created by apple on 11/30/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
import UIKit

class ListItems: Codable {
    
    var title : String
    var check : Bool
    var index : Int
    
    // designated initializer
    init(title: String, check: Bool, index: Int) {
        self.title = title
        self.check = check
        self.index = index
    }
    
    convenience init(title: String, index: Int){
        self.init(title: title, check: false, index: index)
    }
}
