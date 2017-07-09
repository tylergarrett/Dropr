//
//  Dot.swift
//  Dropr
//
//  Created by Josh Peters on 4/11/17.
//  Copyright © 2017 GarrettPeters. All rights reserved.
//

import UIKit
import MapKit

class Dot: NSObject, MKAnnotation{
    let title: String?
    let desc: String
    let upVoteCount: Int
    let imagePath: String
    let green: Bool
    let coordinate: CLLocationCoordinate2D
    var uri: String
    let deviceID: Int
    
    //constructor
    init(title: String, desc: String, upVoteCount: Int, imagePath: String, green: Bool, coordinate: CLLocationCoordinate2D, uri: String, deviceID:Int) {
        self.title = title
        self.desc = desc
        self.upVoteCount = upVoteCount
        self.imagePath = imagePath
        self.green = green
        self.coordinate = coordinate
        self.uri = uri
        self.deviceID = deviceID
        
        super.init()
    }
    
    init(title: String, desc: String, upVoteCount: Int, imagePath: String, green: Bool, coordinate: CLLocationCoordinate2D, deviceID:Int) {
        self.title = title
        self.desc = desc
        self.upVoteCount = upVoteCount
        self.imagePath = imagePath
        self.green = green
        self.coordinate = coordinate
        self.uri = "no uri set yet"
        self.deviceID = deviceID
    
        super.init()
    }
    
    func setUri(uri: String){
        self.uri = uri
    }
    
    // Add subtitle in the pin info
    var subtitle: String? {
        return desc
    }
    
    // Function that sets the green/red color of the pins
    func pinTintColor() -> UIColor  {
        if(green){
            return MKPinAnnotationView.greenPinColor()
        }
        else{
            return MKPinAnnotationView.redPinColor()
        }
    }
    
    
}
