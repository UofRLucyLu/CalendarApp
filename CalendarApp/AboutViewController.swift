//
//  AboutViewController.swift
//  CalendarApp
//
//  Created by apple on 11/30/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var verLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var copyright: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var name: UILabel!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = Bundle.main.displayName
        version.text = Bundle.main.version
        copyright.text = Bundle.main.copyright
        
        num.text = defaults.integer(forKey: dNumLaunches).description
        
        
        verLabel.text = NSLocalizedString("str_version", comment: "")
        nameLabel.text = NSLocalizedString("str_app", comment: "")
        numLabel.text = NSLocalizedString("str_num", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
