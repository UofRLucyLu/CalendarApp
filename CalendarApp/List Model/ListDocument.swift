//
//  ListDocument.swift
//  CalendarApp
//
//  Created by apple on 11/30/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
import UIKit

class ListDocument: Codable {
    
    var lists = [ListItems]()
    
    func addItem(item : ListItems){
        lists.append(item)
    }
    
    func removeItem(index: Int){
        lists.remove(at: index)
    }
    
}
