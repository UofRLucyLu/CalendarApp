//
//  ViewController.swift
//  CalendarApp
//
//  Created by apple on 11/25/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var weekdaysLabel: [UILabel]!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarCollection: UICollectionView!
    
    //for the labels before table view
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //arraies that control the static range of calendar
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
    
    let weekdays = [
        NSLocalizedString("str_mon", comment: ""),
        NSLocalizedString("str_tue", comment: ""),
        NSLocalizedString("str_wed", comment: ""),
        NSLocalizedString("str_thu", comment: ""),
        NSLocalizedString("str_fri", comment: ""),
        NSLocalizedString("str_sat", comment: ""),
        NSLocalizedString("str_sun", comment: "")
    ]
    
    //emoji array for weather
    
    //due to leap year, need to alter the 2nd entry
    var daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    //local property will be access
    //the current month displayed on screen
    var currentMonth = String()
    
    //local var such that it properly formates the month display
    var dayCounter = Int()
    var emptyBox = Int()
    var nextEmptyBox = Int()
    var prevEmptyBox = 0
    var direction = 0   //0 represents current month, -1 previous, 1 next
    var positionIndex = 0   //translate above to index of position
    
    //table view stuff, will change later
    var eventLibrary : EventLibrary?    //pass it from app delegate
    var eventDocument : EventDocument?
    
    //list view stuff
    var listLibrary : ListLibrary?
    
    //weather
    var forcast : [Weather]?
    
    //core location
    var locMangaer : CLLocationManager?
    var location = ""
    
    //segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            let controller = segue.destination as! EventViewController
            controller.eventLib = eventLibrary  //parse in the library
        }
        else if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! EventDetailViewController
                controller.eventLib = eventLibrary
                controller.eventDoc = eventDocument
                controller.event = eventDocument?.events[indexPath.row]
            }
        }
        else if segue.identifier == "listSegue" {
            if let cell = sender as? DateCollectionViewCell{
                let key = "\(cell.dateLabel.text ?? "") \(month) \(year)"
                let controller = segue.destination as! ListTableViewController
                if listLibrary?.listDocs[key] == nil{
                    listLibrary?.listDocs[key] = ListDocument()
                }
                print(key)
                if listLibrary?.listDocs[key] == nil{
                }
                controller.listDocument = listLibrary?.listDocs[key]
            }
        }
    }
    
    @IBAction func ifSwipe(_ gestureRecognizer : UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            if gestureRecognizer.direction == .right{
                self.prev()
            }
            else if gestureRecognizer.direction == .left{
                self.next()
            }
        }
    }
    
    func prev(){
        //as below
        if month - 1 == 0{
            if (year - 1)%4 == 0{   //if a leap year
                daysInMonths[1] = 29    //change the entry
            }
            else{
                daysInMonths[1] = 28    //otherwise normal
            }
        }
        
        direction = -1  //when this button pressed, return to previous month hence -1 direction
        updatePos()    //update all the empty boxes for the collection view to load
        
        switch (month - 1){
        case 0:   //if january
            month = 12  //set it to decemeber in previous year
            year = year - 1 //update the year
            break
            
        default:    //otherwise
            month = month - 1
        }
        
        //updatePos()
        
        currentMonth = monthes[month - 1]
        monthLabel.text = "\(currentMonth) \(year)" //set the label, including both month and year
        
        //also reaccess the events for this month and year
        let key = "\(month) \(year)"
        if eventLibrary?.eventDocs[key] == nil {
            eventLibrary?.eventDocs[key] = EventDocument()
        }
        eventDocument = (eventLibrary?.eventDocs[key])!
        
        calendarCollection.reloadData()
        tableView.reloadData()
    }
    
    @IBAction func prevMonth(_ sender: UIButton) {
        self.prev()
    }
    
    func next(){
        //check if leap year
        if (month - 1) == 11{
            if (year + 1)%4 == 0{   //if a leap year
                daysInMonths[1] = 29    //change the entry
            }
            else{
                daysInMonths[1] = 28    //otherwise normal
            }
        }
        
        //before updating value of month, get the position for next month
        direction = 1
        updatePos()
        
        switch (month - 1){
        case 11:   //if december
            month = 1 //set it to january in next year
            year = year + 1 //update the year
            break
            
        default:    //otherwise
            month = month + 1
        }
        
        currentMonth = monthes[month - 1]
        monthLabel.text = "\(currentMonth) \(year)" //set the label, including both month and year
        
        let key = "\(month) \(year)"
        if eventLibrary?.eventDocs[key] == nil {
            eventLibrary?.eventDocs[key] = EventDocument()
        }
        eventDocument = (eventLibrary?.eventDocs[key])!
        
        calendarCollection.reloadData()
        tableView.reloadData()
    }
    
    @IBAction func nextMonth(_ sender: UIButton) {
        self.next()
    }
    
    //function that get the start day position
    func updatePos() {
        
        switch direction{
        case 0:
            //using today's day and weekday's difference to figure out the weekday for the first day this month
            emptyBox = weekday - 2  //as Sunday = 1, Mon = 2 etc
            if emptyBox < 0{ //in this case we are in Sunday
                emptyBox = 6    //which will later be set as 0
            }
            dayCounter = day - 1
            
            while dayCounter > 0{
                emptyBox = emptyBox - 1
                dayCounter = dayCounter - 1
                if emptyBox == 0{
                    emptyBox = 7
                }
            }
            if emptyBox == 7{
                emptyBox = 0
            }
            positionIndex = emptyBox
            
            break
            
        case 1...:
            //the number of empty box in next month is calculated as below
            nextEmptyBox = (positionIndex + daysInMonths[month - 1]) % 7
            
           // print("Current month is \(month - 1) and days in next month is \(daysInMonths[month - 1])")
            
            if nextEmptyBox == 7{
                nextEmptyBox = 0
            }
            positionIndex = nextEmptyBox
            break
            
        case -1:
            if month != 1{
                //print("Current month is \(month - 1) and days in previous month is \(daysInMonths[month - 2])")
                //simple math
                //the empty box in previous month is the complement of the empty box of this month
                prevEmptyBox = (7 - ((daysInMonths[month - 2] - positionIndex) % 7))
            }
            else{
                //when current month is January, one wants days in  December
                //print("Current month is \(month - 1) and days in previous month is \(daysInMonths[11])")
                prevEmptyBox = (7 - ((daysInMonths[11] - positionIndex) % 7))
            }
            
            if prevEmptyBox == 7{
                prevEmptyBox = 0
            }
            positionIndex = prevEmptyBox
            break
            
        default:
            fatalError()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the swipe recognizer
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.ifSwipe(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        if eventLibrary == nil{
            eventLibrary = EventLibrary()
        }
        
        //construct or get the event document
        let key = "\(month) \(year)"
        if eventLibrary?.eventDocs[key] == nil{
            //add the empty document to the library
            eventLibrary?.eventDocs[key] = EventDocument()
            eventDocument = eventLibrary?.eventDocs[key]
        }
        else{
            eventDocument = eventLibrary?.eventDocs[key]
        }

        //get the string for current month
        currentMonth = monthes[month - 1]
        monthLabel.text = "\(currentMonth) \(year)" //set the label, including both month and year
        //initialize weekday labels
        for i in 0..<7 {
            weekdaysLabel[i].text = weekdays[i]
        }
        
        //update labels in table view
        eventLabel.text = NSLocalizedString("str_events", comment: "")
    
        //get the empty box
        direction = 0
        updatePos()
        
        locMangaer = CLLocationManager()
        locMangaer?.delegate = self
        locMangaer?.desiredAccuracy = kCLLocationAccuracyKilometer    //do not require to be that accureate
        locMangaer?.distanceFilter = 1000
        checkLocationPermission()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //if not getting any location, hide the label
        if location == ""{
            self.temperatureLabel.isHidden = true
            self.weatherImage.isHidden = true
        }
        else{
            Weather.forecast(withLocation: location) { (results:[Weather]) in
                self.forcast = results
                OperationQueue.main.addOperation {
                    //self.location = "\(self.locMangaer?.location?.coordinate.latitude),\(self.locMangaer?.location?.coordinate.longitude)"
                    self.temperatureLabel.text = "\(Int(self.forcast![0].temperature)) °F"
                    self.weatherImage.image = UIImage.init(named: "\(self.forcast![0].icon)")
                    self.locMangaer?.stopUpdatingLocation() //once get the weather, stop updating
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: " + error.localizedDescription)
    }
    
    func missingPermissionsAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: NSLocalizedString("str_ok", comment: ""), style: .cancel)
        let settingsAction = UIAlertAction(title: NSLocalizedString("str_settings", comment: ""), style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        
        alert.addAction(okAction)
        alert.addAction(settingsAction)
        present(alert, animated: true)
    }
    
    //alert for check lcoation
    func checkLocationPermission(){
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            missingPermissionsAlert(title: NSLocalizedString("str_CLNoService", comment: ""),
                                    message: NSLocalizedString("str_CLDeniedPerm", comment: ""))
        case .restricted:
            missingPermissionsAlert(title: NSLocalizedString("str_CLNoService", comment: ""),
                                    message: NSLocalizedString("str_CLBlocked", comment: ""))
        default:
            locMangaer?.requestWhenInUseAuthorization()
            locMangaer?.startUpdatingLocation()
            location = "\(locMangaer?.location?.coordinate.latitude ?? 0),\(locMangaer?.location?.coordinate.longitude ?? 0)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let key = "\(month) \(year)"
        eventDocument = eventLibrary?.eventDocs[key]
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return the number of day in each month in order to determine number of cells
        //also attach the empty box
        switch direction{
        case 0:
            return daysInMonths[month - 1] + emptyBox
            
        case 1...:
            return daysInMonths[month - 1] + nextEmptyBox
            
        case -1:
            return daysInMonths[month - 1] + prevEmptyBox
            
        default:
            fatalError()
        }
        
        return daysInMonths[month - 1];
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear    //set alpha = 0 for each cel
        //reset the text color and visibility
        cell.isHidden = false
        cell.dateLabel.textColor = UIColor.black
        
        //label substract the empty slot
        switch direction{
        case 0:
            cell.dateLabel.text = "\(indexPath.row + 1 - emptyBox)"
            break
            
        case 1...:
            cell.dateLabel.text = "\(indexPath.row + 1 - nextEmptyBox)"
            break
            
        case -1:
            cell.dateLabel.text = "\(indexPath.row + 1 - prevEmptyBox)"
            break
            
        default:
            fatalError()
        }
        
        
        //hide the empty box
        if Int(cell.dateLabel.text!)! <= 0{
            cell.isHidden = true
        }
        
        //set the weekend to gray color
        switch indexPath.row {
        case 5, 6, 12, 13, 19, 20, 26, 27, 33, 34:
            if Int(cell.dateLabel.text!)! > 0{  //if not hidden
                cell.dateLabel.textColor = UIColor.lightGray
            }
            break
            
        default:
            break
        }
        
        //this part highlight the current day
        if year == calendar.component(.year, from: date) && month == calendar.component(.month, from: date) && day == Int(cell.dateLabel.text!)!{
            cell.backgroundColor =  UIColor.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (eventDocument?.events.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event", for: indexPath) as! EventTableViewCell
        cell.nameLabel.text = (eventDocument?.events[indexPath.row].eventName)! //set related properties
        cell.timeLabel.text = "\(currentMonth) \((eventDocument?.events[indexPath.row].eventDay)!) \((eventDocument?.events[indexPath.row].eventTime)!)"
        cell.locationLabel.text = (eventDocument?.events[indexPath.row].eventLoc)!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

