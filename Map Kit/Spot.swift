//
//  Spot.swift
//  Map Kit
//
//  Created by Maryam Jafari on 9/26/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation
import MapKit
class Spot: NSObject, MKAnnotation {
    var title: String?
    var latitude: Double
    var longitude:Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double, address: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.title = address
    }
}
