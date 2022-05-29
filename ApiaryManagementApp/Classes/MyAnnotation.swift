//
//  MyAnnotation.swift
//  ApiaryManagementApp
//
//  Created by Dawid Zytko on 12/05/2022.
//  Copyright © 2022 Dawid Zytko. All rights reserved.
//


import SwiftUI
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let moveOnly: Bool
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, moveOnly: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.moveOnly = moveOnly
    }
}
