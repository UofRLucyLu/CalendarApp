//
//  DateCollectionViewCell.swift
//  CalendarApp
//
//  Created by apple on 11/28/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    
    //so that the backgroud part is circle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
}
