//
//  CLLocation + Pretty.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/2/22.
//

import Foundation

extension CLLocation {
    var pretty:String {
        "lat:\(self.coordinate.latitude), long:\(self.coordinate.longitude)"
    }
}
