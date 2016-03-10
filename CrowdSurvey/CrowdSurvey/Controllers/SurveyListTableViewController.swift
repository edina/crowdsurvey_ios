//
//  SurveyListTableViewController.swift
//  CrowdSurvey
//
//  Created by Colin Gormley on 09/03/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit

class SurveyListTableViewController: UITableViewController {

   
    var surveys: [Survey] = []
    
    @IBOutlet var tableViewController: UITableView!
    
    let surveyCellIdentifier = "SurveyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.surveys.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(surveyCellIdentifier, forIndexPath: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = surveys[row].title
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        // Note this segue was created in the storyboard

      
            
            if let mvc = segue.destinationViewController as? MapViewController {
                tableView.indexPathForSelectedRow?.row
                if let surveyIndex = tableView.indexPathForSelectedRow?.row {
                    mvc.survey = surveys[surveyIndex]
                }
            }
        
    
    }


}
