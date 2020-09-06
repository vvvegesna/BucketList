//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Vegesna, Vijay V EX1 on 9/2/20.
//  Copyright © 2020 Vegesna, Vijay V. All rights reserved.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown"
        }
        set {
            self.title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown value"
        }
        set {
            self.subtitle = newValue
        }
    }
}
