//
//  ListTableViewCell.swift
//  CalendarApp
//
//  Created by apple on 11/30/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

protocol CheckBox {
    func checkBox()
}

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!

    var list : ListItems?
    var check = false
    
    var delegate: CheckBox?
    
    @IBAction func checkBox(_ sender: Any) {
        //swap the image
        if check {
            checkButton.setBackgroundImage(#imageLiteral(resourceName: "uncheckBox"), for: .normal)
        }
        else {
            checkButton.setBackgroundImage(#imageLiteral(resourceName: "checkBox"), for: .normal)
        }
        //update the check
        check = !check  //reverse the boolean
        list?.check = check
        delegate?.checkBox()
    }
    
    func update(){
        if !check {
            checkButton.setBackgroundImage(#imageLiteral(resourceName: "uncheckBox"), for: .normal)
        }
        else {
            checkButton.setBackgroundImage(#imageLiteral(resourceName: "checkBox"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
