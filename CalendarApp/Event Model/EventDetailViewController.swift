//
//  EventDetailViewController.swift
//  CalendarApp
//
//  Created by apple on 11/30/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    //parse in document from segue
    var eventLib : EventLibrary!
    var eventDoc : EventDocument!
    var event : EventItems!
    
    //all gui stuff
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var desText: UILabel!
    
    //priority image view
    @IBOutlet weak var priorityImage: UIImageView!
    
    let monthes = [
        NSLocalizedString("str_jan", comment: ""),
        NSLocalizedString("str_feb", comment: ""),
        NSLocalizedString("str_mar", comment: ""),
        NSLocalizedString("str_apr", comment: ""),
        NSLocalizedString("str_may", comment: ""),
        NSLocalizedString("str_jun", comment: ""),
        NSLocalizedString("str_jul", comment: ""),
        NSLocalizedString("str_aug", comment: ""),
        NSLocalizedString("str_sep", comment: ""),
        NSLocalizedString("str_oct", comment: ""),
        NSLocalizedString("str_nov", comment: ""),
        NSLocalizedString("str_dec", comment: "")
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let controller = segue.destination as! EventViewController
            controller.eventLib = eventLib  //parse in the library
            controller.event = event    //pass the event to event
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = event.eventName
        locLabel.text = event.eventLoc
        timeLabel.text = "\(monthes[Int(event.eventMonth)! - 1]) \(event.eventDay) \(event.eventTime)"
        desText.text = event.eventDes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func returnButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func deletionAlert(title: String, completion: @escaping (UIAlertAction) -> Void) {
        
        let alertMsg = NSLocalizedString("str_deleteWarning", comment: "")
        let alert = UIAlertController(title: "",
                                      message: alertMsg,
                                      preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("str_delete", comment: ""),
                                         style: .destructive, handler: completion)
        let cancelAction = UIAlertAction(title: NSLocalizedString("str_cancel", comment: ""),
                                         style: .cancel, handler:nil)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        deletionAlert(title: event.eventName) { _ in
            self.eventDoc.removeEvent(self.event.index)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
    }
}
