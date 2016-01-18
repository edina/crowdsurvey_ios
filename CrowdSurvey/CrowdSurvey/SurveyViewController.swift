//
//  SurveyViewController.swift
//  CrowdSurvey
//
//  Created by Colin Gormley on 12/01/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit
import Eureka



class SurveyViewController: FormViewController {

    var survey: Survey? { didSet { setupForm() } }
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupForm(){
        form = survey!.form()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
