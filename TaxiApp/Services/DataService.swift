//
//  DataService.swift
//  TaxiApp
//
//  Created by Loay on 6/20/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class Dataservice {

// Variables
    
    static let instance = Dataservice()
    
    private var _REF_BASE = DB_BASE
    private var _REF_PASSENGERS = DB_BASE.child("passengers")
    private var _REF_DRIVERS = DB_BASE.child("drivers")
    private var _REF_TRIPS = DB_BASE.child("trips")
    
    var REF_BASE: DatabaseReference {
        
        return _REF_BASE
    }
    
    var REF_PASSENGERS: DatabaseReference {
        
        return _REF_PASSENGERS
    }
    
    var REF_DRIVERS: DatabaseReference {
        
        return _REF_DRIVERS
    }
    
    var REF_TRIPS: DatabaseReference {
        
        return _REF_TRIPS
    }
    
// Functions
    
    func createFirebasePassenger(uid: String, userData: Dictionary<String, Any>) {
        
        REF_PASSENGERS.child(uid).updateChildValues(userData)
    }
    
    func createFirebaseDriver(uid: String, userData: Dictionary<String, Any>) {
        
        REF_DRIVERS.child(uid).updateChildValues(userData)
    }
    
}
