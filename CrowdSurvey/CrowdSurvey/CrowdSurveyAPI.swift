//
//  CrowdSurveyAPI.swift
//  CrowdSurvey
//
//  Created by Colin Gormley on 03/03/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import SwiftyJSON
import Siesta
import ObjectMapper


class _CrowdSurveyAPI: Service {
    
    init() {
        
        super.init(baseURL: "http://dlib-rainbow.edina.ac.uk:3000/api", networking: AlamofireProvider())
        
        // Uncomment for Siesta logging
        //        Siesta.enabledLogCategories = LogCategory.all
        
        configure {
            $0.config.headers["Accept"] = "application/json"
            $0.config.headers["Content-Type"] = "application/json"
            // Automatically convert all responses to SwiftyJSON so we can just call resource.latestData.content
            $0.config.responseTransformers.add(self.SwiftyJSONTransformer, contentTypes: ["*/json"])
        }
    }
    
    private let SwiftyJSONTransformer =
    ResponseContentTransformer(skipWhenEntityMatchesOutputType: false)
        { JSON($0.content as AnyObject) }
    
    var surveys: Resource {
        return resource("/survey")
    }
    
}

let crowdSurveyAPI = _CrowdSurveyAPI()