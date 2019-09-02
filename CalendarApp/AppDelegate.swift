//
//  AppDelegate.swift
//  CalendarApp
//
//  Created by apple on 11/25/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

// project id
let kAppGroupBundleID       = "test.CalendarApp"

/*
 * Default Items
 */
let dAppVersion             = "app_version"
let dNumLaunches            = "num_launches"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let defaults = UserDefaults.standard
    
    //data persistence
    var eventLibrary : EventLibrary!
    var eventFileName = "EventFile"
    
    var listLibrary : ListLibrary!
    var listFileName = "ListFile"
    
    //File Address
    lazy var eventFileURL: URL = {
        let documentsDir =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDir.appendingPathComponent(eventFileName, isDirectory: false)
    }()
    lazy var listFileURL: URL = {
        let documentsDir =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDir.appendingPathComponent(listFileName, isDirectory: false)
    }()
    
    //run the initialization and set the app version
    override init() {
        defaults.set(Bundle.main.build, forKey: dAppVersion)
    }
    
    //initialize the default
    func initDefaults() {
        if let path = Bundle.main.path(forResource: "Defaults", ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path) {
            defaults.register(defaults: dictionary as! [String : Any])
            defaults.synchronize()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        loadData()
        initDefaults()
        
        //pass the library to the controller
        if let navController = window?.rootViewController as? UINavigationController {
            if let mainViewController = navController.viewControllers.first as? MainViewController {
                mainViewController.eventLibrary = eventLibrary
                mainViewController.listLibrary = listLibrary
            }
        }
        //print("\(eventFileURL.path)")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //increase num of launch
        let numLaunches = defaults.integer(forKey: dNumLaunches) + 1
        defaults.set(numLaunches, forKey: dNumLaunches)
        
        saveData()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveData()
    }
    
    func saveData() {
        
        if FileManager.default.fileExists(atPath: eventFileURL.path) {
            do {
                try FileManager.default.removeItem(at: eventFileURL)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        if let encodedData = try? JSONEncoder().encode(eventLibrary) {
            FileManager.default.createFile(atPath: eventFileURL.path, contents: encodedData, attributes: nil)
        } else {
            fatalError("Couldn't write data!")
        }
        
        if FileManager.default.fileExists(atPath: listFileURL.path) {
            do {
                try FileManager.default.removeItem(at: listFileURL)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        if let encodedData = try? JSONEncoder().encode(listLibrary) {
            FileManager.default.createFile(atPath: listFileURL.path, contents: encodedData, attributes: nil)
        } else {
            fatalError("Couldn't write data!")
        }
    }
    
    func loadData() {
        
        if !FileManager.default.fileExists(atPath: eventFileURL.path) {
            eventLibrary = EventLibrary();
            return
        }
        
        if let jsondata = FileManager.default.contents(atPath: eventFileURL.path) {
            let decoder = JSONDecoder()
            do {
                let decLibrary = try decoder.decode(EventLibrary.self, from: jsondata)
                eventLibrary = decLibrary
                //in case past fail attempt happens.
                if eventLibrary.eventDocs.count == 0{
                    eventLibrary = EventLibrary();
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("No data at \(eventFileURL.path)!")
        }
        
        
        if !FileManager.default.fileExists(atPath: listFileURL.path) {
            listLibrary = ListLibrary();
            return
        }
        
        if let jsondata = FileManager.default.contents(atPath: listFileURL.path) {
            let decoder = JSONDecoder()
            do {
                let decLibrary = try decoder.decode(ListLibrary.self, from: jsondata)
                listLibrary = decLibrary
                //in case past fail attempt happens.
                if listLibrary.listDocs.count == 0{
                    listLibrary = ListLibrary();
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("No data at \(listFileURL.path)!")
        }
    }


}

