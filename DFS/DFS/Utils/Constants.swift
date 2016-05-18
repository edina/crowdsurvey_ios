//
//  Constants.swift
//  DFS
//
//  Created by Colin Gormley on 12/05/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Colour {
        static let DarkBlue = UIColor(red: 24/255.0, green:21/255.0, blue:76/255.0, alpha: 1.0)
        static let LightBlue = UIColor(red: 34/255.0, green:31/255.0, blue:128/255.0, alpha: 1.0)
    }
    struct SegueIDs {
        static let addPhoto = "addPhoto"
        static let showPhoto = "showPhoto"
    }
    struct ReuseIDs {
        static let photoCell = "photoCell"
    }
    struct Image {
        static let gallery = "Gallery"
        static let camera = "Camera"
        static let LocationArrowIcon = "Location Arrow"
        static let LocationArrowIconOutline = "Location Arrow Outline"
    }
}