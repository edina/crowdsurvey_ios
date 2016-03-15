//
//  Constants.swift
//  CrowdSurvey
//
//  Created by Colin Gormley on 28/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
struct Constants {
    
    struct Notifications {
        static let FieldUpdatedNotification = "Field Updated Notification"
    }
    struct SegueIDs {
        static let ShowSurvey = "Show Survey"
        static let ShowSurveyList = "Show Survey List"
        static let ShowSurveyOnMap = "Show Survey On Map"
        static let SaveSurvey = "saveSurvey"
    }
    struct Form {
        static let Text = "text"
        static let Checkbox = "checkbox"
        static let Radio = "radio"
        static let Image = "image"
        static let Select = "select"
        static let Dtree = "dtree"
        static let Location = "location"
        static let Warning = "warning"
        static let Range = "range"
        static let SelectPlaceHolder = "Select…"
        static let validGreenColour = UIColor(
            red:0.1,
            green:0.8,
            blue:0.1,
            alpha:0.1)
        static let requiredRedColour = UIColor(
            red:1,
            green:0.1,
            blue:0.1,
            alpha:0.1)
        static let Notification = "Field Updated Notification"
    }
    
}