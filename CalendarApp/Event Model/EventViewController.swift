//
//  EventViewController.swift
//  CalendarApp
//
//  Created by apple on 11/29/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate{

    @IBOutlet weak var pickerView: UIDatePicker!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var desText: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    //will pass in document and library whenever load data
    var eventLib : EventLibrary?
    var event : EventItems? //if editing mode, this already exists
    var edit = false    //check whether is editing the event
    var oldKey = "" //when editing, keep track of the old key
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //localizaed
        titleLabel.text = NSLocalizedString("str_title", comment: "")
        locLabel.text = NSLocalizedString("str_loc", comment: "")
        desLabel.text = NSLocalizedString("str_des", comment: "")
        timeLabel.text = NSLocalizedString("str_time", comment: "")
        
        if event == nil{
            edit = false
            titleText.placeholder = NSLocalizedString("str_title2", comment: "")
            locationText.placeholder = NSLocalizedString("str_loc2", comment: "")
            desText.placeholder = NSLocalizedString("str_des2", comment: "")
            doneButton.setTitle(NSLocalizedString("str_add", comment: ""), for: .normal)
        }
        else{
            edit = true
            
            titleText.text = (event?.eventName)!
            locationText.text = (event?.eventLoc)!
            desText.text = (event?.eventDes)!
            
            oldKey = (event?.eventTime)!
            
            //create date object
            var dateComponents = DateComponents()
            dateComponents.hour = event?.eventHour
            dateComponents.minute = event?.eventMinute
            let calendar = Calendar.current // user calendar
            let date = calendar.date(from: dateComponents)
            pickerView.date = date!  //set the picker view date
            doneButton.setTitle(NSLocalizedString("str_udpate", comment: ""), for: .normal)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //reload kind of
        self.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneAction(_ sender: UIButton) {
        let name = titleText.text!
        if name != "" {
            let loc = locationText.text!
            let des = desText.text!
            
            //get time
            let date = pickerView!.date
            
            let calendar = Calendar.current
            let min = calendar.component(.minute, from: date)
            let hour = calendar.component(.hour, from: date)
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            
            //add it to the document with specified month
            let key = "\(month) \(year)"
                
            print(key)
                
            //create the event item
            //add it to the end
            if eventLib!.eventDocs[key] == nil {    //whenever one is trying to add something
                eventLib!.eventDocs[key] = EventDocument()
            }
                
            let event = EventItems(name: name, index: (eventLib!.eventDocs[key]?.events.count)!)
                
            if loc == "" {
                event.setLoc(loc: "To Be Determined")
            }
            else{
                event.setLoc(loc: loc)
            }
                
            event.setDes(des: des)
            event.setTime(month: "\(month)", day: "\(day)", hour: "\(hour)", min: "\(min)")
            
            eventLib!.eventDocs[key]?.addEvent(event)
        }
        
        //once touch done button
        presentingViewController?.dismiss(animated: true, completion: nil)
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
