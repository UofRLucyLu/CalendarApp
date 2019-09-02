//
//  EventDocument.swift
//  CalendarApp
//
//  Created by apple on 11/29/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
import UIKit

class EventDocument: Codable {
    
    //all events
    var events = [EventItems]()
    
    //will be updated with a picker view
    func addEvent(_ event: EventItems) {
        events.append(event)
    }
    
    func removeEvent(_ index: Int){
        events.remove(at: index)
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
