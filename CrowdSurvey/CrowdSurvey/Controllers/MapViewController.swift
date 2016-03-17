  //
  //  MapViewController.swift
  //  CrowdSurvey
  //
  //  Created by Colin Gormley on 11/01/2016.
  //  Copyright © 2016 Edina. All rights reserved.
  //
  
  import UIKit
  import CoreLocation
  import Alamofire
  import ObjectMapper
  import Mapbox
  import SwiftyJSON
  import Siesta
  import BubbleTransition
  import BTNavigationDropdownMenu
  
  class MapViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate, ResourceObserver, UIViewControllerTransitioningDelegate {
    
    
    
    let transition = BubbleTransition()
    let locationManager = CLLocationManager()
    
    
    var menuView: BTNavigationDropdownMenu!
    
    
    // Simple default survey to be loaded if no other id explicitly specified
    let defaultSurveyId = "566ed9b30351d817555158ce"
    
    var database: CouchBaseUtils?
    var survey: Survey?
    var surveyId: String?
    
    var surveys: [Survey] = []
    
    let statusOverlay = ResourceStatusOverlay()
    
    
    var surveysResource: Resource? {
        didSet {
            // One call to removeObservers() removes both self and statusOverlay as observers of the old resource,
            // since both observers are owned by self (see below).
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            // Adding ourselves as an observer triggers an immediate call to resourceChanged().
            
            surveysResource?.addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        statusOverlay.positionToCoverParent()
    }
    
    
    // MARK: - Outlets
    @IBOutlet weak var newSurvey: UIButton!{
        didSet{
            newSurvey.layer.cornerRadius = 30
        }
    }
    @IBOutlet weak var mapView: MGLMapView!
    
    //    @IBOutlet weak var navbarTitle: UINavigationItem!
    
    @IBAction func surveySubmitted(segue:UIStoryboardSegue) {
        print("Submitted")
        if let record = self.survey?.records?.last {
            addAnnotationToMap(record)
        }
    }
    
    @IBAction func setMapToUserLocation(sender: UIBarButtonItem) {
        // TODO: Check user location is within survey bounding box
        mapView.setCenterCoordinate(locationManager.location!.coordinate, animated: true)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get survey resource
        surveysResource = crowdSurveyAPI.surveys
        
        statusOverlay.embedIn(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newSurvey.hidden = true
        self.newSurvey.enabled = false
        
        self.setupMapView()
        self.database = self.setupDatabase()
    }
    
    // MARK: - Siesta Delegate
    // Listen for SurveysResource changing.
    func resourceChanged(resource: Resource, event: ResourceEvent) {
        
        // Only do stuff if there is new data
        if case .NewData = event {
            setupSurvey()
            
            setupNavBar()
        }
    }
    
    
    
    // MARK: - Setup
    
    func setupNavBar() {
        let items = self.surveys.map({$0.title!})
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = Constants.Colour.DarkBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        var title : String?
        
        if (self.surveyId?.isEmpty != nil) {
            // Load requested survey
            if let requestedTitle = self.surveys.filter({$0.id == self.surveyId}).first?.title{
                title = requestedTitle
            }
            
        }else{
            // load default
            if let defaultSurveyTitle = self.surveys.filter({$0.id == defaultSurveyId}).first?.title {
                title = defaultSurveyTitle
            }
        }
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: title!, items: items)
    
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = Constants.Colour.LightBlue
        menuView.cellSeparatorColor = Constants.Colour.LightBlue
        menuView.cellTextLabelAlignment = .Left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        
        // Use weak self to prevent strong reference cycle
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in

            self?.survey = self?.surveys[indexPath]
            self?.resetAnnotationsForNewSurvey()
        }
        
        self.navigationItem.titleView = menuView
        
        
    }
    
    func setupMapView(){
        // Set the map view‘s delegate property
        mapView.delegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        mapView.showsUserLocation = true
        
        self.view.bringSubviewToFront(self.newSurvey)
    }
    
    func setupDatabase() -> CouchBaseUtils {
        return CouchBaseUtils(databaseName: "survey")
    }
    
    func createActiveSurveyModelForID(id : String){
        self.database?.setActiveFlagForId(id)
        self.newSurvey.hidden = false
        self.newSurvey.enabled = true
        //        navbarTitle.title = self.survey?.title
    }
    
    func loadDefaultSurvey(){
        // Get the default survey
        if let defaultSurvey = self.surveys.filter({$0.id == defaultSurveyId}).first {
            self.survey = defaultSurvey
            createActiveSurveyModelForID(defaultSurveyId)
        }
    }
    
    func addSurveysToDB(surveyJson : JSON) -> Bool{
        
        var surveyFound = false
        
        if let doc = self.database?.getOrCreateDocument(surveyJson){
            
            let newSurvey = Mapper<Survey>().map(doc.properties)!
            
            // Only add survey to array if not already there
            if(!self.surveys.contains(newSurvey)){
                self.surveys.append(newSurvey)
            }
            
            // Check if we need to load a specific survey
            if self.surveyId == surveyJson["id"].stringValue{
                surveyFound = true
                self.survey = newSurvey
                createActiveSurveyModelForID(self.surveyId!)
                self.surveyId = nil // Reset survey id - survey is loaded in self.survey anyway
            }
        }
        return surveyFound
    }
    
    
    func setupSurvey(){
        
        // Get surveys json
        if let surveysJson = surveysResource?.latestData?.content as? JSON{
            
            // Only update our models and db if there are more surveys on the server
            if ((surveysJson.count > self.surveys.count) || (self.surveyId?.isEmpty != nil)){
                
                var surveyFound = false
                
                // Iterate over surveys and add to database if not already added
                for (index, surveyJson):(String, JSON) in surveysJson {
                    
                    surveyFound = addSurveysToDB(surveyJson)
                }
                
                // If we weren't looking for a specific survey, assume we just load the default
                if !surveyFound {
                    loadDefaultSurvey()
                }
            }
            
            removeAllAnnotations()
            // Add annotations to map for any existing survey responses
            for record: Record in (survey?.records)! {
                addAnnotationToMap(record)
            }
        }
    }
    
    // MARK: - Utility
    
    func addAnnotationToMap(record: Record){
        if let state = record.state?.rawValue {
            record.title = state
        }
        mapView.addAnnotation(record)
    }
    
    func removeAllAnnotations(){
        if let annotations = self.mapView.annotations{
            self.mapView.removeAnnotations(annotations)
            
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        if let navigationController = self.navigationController {
            navigationController.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func resetAnnotationsForNewSurvey() {
        let id = self.survey?.id
        self.createActiveSurveyModelForID(id!)
        self.removeAllAnnotations()
        
        for record: Record in (survey?.records)! {
            addAnnotationToMap(record)
        }
    }
    
    // MARK: - MGLMapView Delegate
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage: MGLAnnotationImage?
        var image: UIImage!
        var reuseIdentifier: String!
        if let title = annotation.title {
            if title == Record.RecordState.Incomplete.rawValue {
                image = UIImage(named: "Map Marker (incomplete)")!
                reuseIdentifier = Record.RecordState.Incomplete.rawValue
            } else if title == Record.RecordState.Complete.rawValue {
                image = UIImage(named: "Map Marker (complete)")!
                reuseIdentifier = Record.RecordState.Complete.rawValue
            } else if title == Record.RecordState.Submitted.rawValue {
                image = UIImage(named: "Map Marker (submitted)")!
                reuseIdentifier = Record.RecordState.Submitted.rawValue
            }
        }
        // Initialize the ‘map pin’ annotation image with the UIImage we just loaded
        annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
        return annotationImage
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped
        return true
    }
    
    func mapView(mapView: MGLMapView, didSelectAnnotation annotation: MGLAnnotation) {
        self.performSegueWithIdentifier(Constants.SegueIDs.ShowSurvey, sender: annotation)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == Constants.SegueIDs.ShowSurvey {
            if let surveyVC = segue.destinationViewController as? SurveyViewController {
                
                
                surveyVC.transitioningDelegate = self
                surveyVC.modalPresentationStyle = .Custom
                
                
                // Ensure back button text is "Back" rather than the Survey title
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                navigationItem.backBarButtonItem = backItem //
                
                if let survey = survey {
                    surveyVC.survey = survey
                    
                    let point = CLLocationCoordinate2D(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
                    let record = sender as? Record ?? Record(survey: survey, coordinate: point)
                    
                    surveyVC.survey?.records?.append(record)
                }
                surveyVC.database = self.database!
            }
            
        }else if segue.identifier == Constants.SegueIDs.ShowSurveyList {
            
            // Destination is NavigationViewController - we want the subsequent SurveyListTableViewController
            if let navVC = segue.destinationViewController as? UINavigationController{
                
                if let surveyListVC = navVC.viewControllers.first as? SurveyListTableViewController {
                    // Set survey list
                    surveyListVC.surveys = self.surveys
                }
            }
        }
    }
    
    @IBAction func returnToMapViewController(segue:UIStoryboardSegue) {
        //unwind segue
        self.resetAnnotationsForNewSurvey()
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = newSurvey.center
        transition.bubbleColor = newSurvey.backgroundColor!
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = newSurvey.center
        transition.bubbleColor = newSurvey.backgroundColor!
        return transition
    }
    
    
  }