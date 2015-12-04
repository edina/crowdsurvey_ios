//
//  MapController.m
//  FieldTripOpen
//
//  Created by Colin Gormley on 04/12/2015.
//  Copyright © 2015 Edina. All rights reserved.
//

#import "MapViewController.h"
@import MapKit;

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setDelegate:self];
    
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 20; // meters

    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    [self.mapView setShowsUserLocation:YES];
}


#pragma mark - MapView
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [self.mapView setRegion:mapRegion animated: YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
