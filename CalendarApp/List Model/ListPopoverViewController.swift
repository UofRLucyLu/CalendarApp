//
//  ListPopoverViewController.swift
//  CalendarApp
//
//  Created by apple on 12/1/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

protocol ListPopoverViewControllerDelegate: class {
    //method that pass the selection here back to the main view
    func passAdding(_ text : String)
}

class ListPopoverViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    weak var delegate: ListPopoverViewControllerDelegate?
    
    @IBAction func addAction(_ sender: Any) {
        delegate?.passAdding(textField.text!)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
