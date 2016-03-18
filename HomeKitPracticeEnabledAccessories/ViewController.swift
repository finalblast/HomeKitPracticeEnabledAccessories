//
//  ViewController.swift
//  HomeKitPracticeEnabledAccessories
//
//  Created by Nam (Nick) N. HUYNH on 3/18/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import HomeKit

class ViewController: UIViewController {

    var accessories = [HMAccessory]()
    var home: HMHome!
    var room: HMRoom!
    
    lazy var accessoryBrowser: HMAccessoryBrowser = {
        
       let browser = HMAccessoryBrowser()
        browser.delegate = self
        return browser
        
    }()
    
    var randomHomeName: String = {
        
        return "Home \(arc4random_uniform(UInt32.max))"
        
    }()
    
    let roomName = "Bedroom 1"
    
    var homeManager: HMHomeManager!

    // MARK: Finding services for accessry
    
    func findServicesForAccessory(accessory: HMAccessory!) {
        
        println("Finding services ...")
        for service in accessory.services as [HMService] {
            
            println("Service Name: \(service.name)")
            println("Service Type: \(service.serviceType)")
            findCharacteristicOfService(service)
            
        }
        
    }
    
    // MARK: Finding characteristic of service
    
    func findCharacteristicOfService(service: HMService!) {
        
        println("Finding characteristic ...")
        for characteristic in service.characteristics as [HMCharacteristic] {
            
            println("Chracteristic Type: \(characteristic.characteristicType)")
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeManager = HMHomeManager()
        homeManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: HMHomeManagerDelegate, HMAccessoryBrowserDelegate {
    
    func homeManagerDidUpdateHomes(manager: HMHomeManager!) {
        
        manager.addHomeWithName(randomHomeName, completionHandler: { (home, error) -> Void in
            
            if error != nil {
                
                println("Could not add home! \(error.description)")
                return
                
            }
            
            println("Added Home")
            self.home = home
            home.addRoomWithName(self.roomName, completionHandler: { (room, error) -> Void in
                
                if error != nil {
                    
                    println("Could not add room to home! \(error.description)")
                    return
                    
                }
                
                println("Added Room")
                self.room = room
                self.accessoryBrowser.startSearchingForNewAccessories()
                
            })
            
        })
        
    }
    
    func accessoryBrowser(browser: HMAccessoryBrowser!, didFindNewAccessory accessory: HMAccessory!) {
        
        println("Found new accessory")
        home.addAccessory(accessory, completionHandler: { (error) -> Void in
            
            if error != nil {
                
                println("Could not add accessory to home!")
                return
                
            }
            
            println("Added Accessory")
            self.home.assignAccessory(accessory, toRoom: self.room, completionHandler: { (error) -> Void in
                
                if error != nil {
                    
                    println("Could not assign accessory to room!")
                    return
                    
                }
                
                println("Assigned to room: \(self.room.name)")
                self.findServicesForAccessory(accessory)
                
            })
            
        })
        
    }
    
    func accessoryBrowser(browser: HMAccessoryBrowser!, didRemoveNewAccessory accessory: HMAccessory!) {
        
        println("\(accessory) has been removed!")
        
    }
    
}