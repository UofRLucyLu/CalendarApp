//
//  EventLibrary.swift
//  CalendarApp
//
//  Created by apple on 11/29/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
import UIKit

class EventLibrary: Codable {
    
    //no default initialization
    
    //all events
    var eventDocs = [String : EventDocument]()
    
    //will be updated with a picker view
    func addDocs(month: Int, year: Int, eventDoc: EventDocument) {
        let key = "\(month) \(year)"
        eventDocs[key] = eventDoc   //put event document with the associated key
    }
    
// to be updated once write the event type
//    func games(for genreType: GenreType) -> [Game] {
//
//        var genreGames = [Game]()
//        for game in games {
//            if game.genreType == genreType {
//                genreGames.append(game)
//            }
//        }
//        return genreGames
//    }
    
}
