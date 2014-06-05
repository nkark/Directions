//
//  MapViewController.m
//  Directions
//
//  Created by Nitin Karki on 4/6/14.
//  Copyright (c) 2014 Nitin Karki. All rights reserved.
//

#import "MapViewController.h"
#import "Annotation.h"
#import "InformationViewController.h"

@interface MapViewController ()

@property (strong, atomic) MKMapItem *startItem;
@property (strong, atomic) MKMapItem *endItem;
@property (assign, nonatomic) CLLocationCoordinate2D annotationCoord;

@end

@implementation MapViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self geocodeLocations];
    
    self.mapView.showsUserLocation = YES;
}

#pragma mark - Find Directions

-(void) geocodeLocations
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //GEOCODE START ADDRESS
    [geocoder
     geocodeAddressString:self.startAddress
     completionHandler:^(NSArray *placemarks,
                         NSError *error) {
         if (error) {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Geocoding start address failed with error." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
             return;
         }
 
         if (placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark = placemarks[0];
             MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithPlacemark:placemark];
             self.startItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
            
             //MOVE MAP TO STARTING LOCATION
             [self moveToCurrentLocation:startPlacemark.coordinate.latitude :startPlacemark.coordinate.longitude];
             
             //GEOCODE END ADDRESS WHEN START ADDRESS HAS BEEN GEOCODED
             [geocoder
              geocodeAddressString:self.endAddress
              completionHandler:^(NSArray *placemarks,
                                  NSError *error) {
                  if (error) {
                      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Geocoding end address failed with error." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                      [alert show];
                      return;
                  }
                  
                  if (placemarks && placemarks.count > 0)
                  {
                      CLPlacemark *placemark = placemarks[0];
                      MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithPlacemark:placemark];
                      self.endItem = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
                      
                      
                      //Make end annotation
                      Annotation *endAnnotation = [Annotation alloc];
                      endAnnotation.coordinate = endPlacemark.coordinate;
                      endAnnotation.title = @"Finish";
                      endAnnotation.subtitle = [NSString stringWithFormat:@"Longitude: %.5f Latitude: %.5f",endPlacemark.coordinate.longitude,endPlacemark.coordinate.latitude];
                      endAnnotation.address = self.endAddress;
                      [self.mapView addAnnotation:endAnnotation];
                      
                      [self findDirectionsFrom:self.startItem to:self.endItem];
                }}];
    }}];
}

- (void)findDirectionsFrom:(MKMapItem *)source
                        to:(MKMapItem *)destination
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.destination = destination;
    request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         
         if (error) {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Error finding directions." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
         }
         else {
             MKRoute *route = response.routes[0];
             [self.mapView addOverlay:route.polyline];
         }
     }];
}
#pragma mark - Zoom Map
-(void)moveToCurrentLocation:(CLLocationDegrees) latitude
                            :(CLLocationDegrees) longitude
{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    
    //Make start annotation
    Annotation *startAnnotation = [Annotation alloc];
    startAnnotation.coordinate = center;
    startAnnotation.title = @"Start";
    startAnnotation.subtitle = [NSString stringWithFormat:@"Longitude: %.5f Latitude: %.5f",center.longitude,center.latitude];
    startAnnotation.address = self.startAddress;
    [self.mapView addAnnotation:startAnnotation];
    
    
    MKCoordinateSpan span = MKCoordinateSpanMake(.05, .05);
    
    MKCoordinateRegion newRegion = MKCoordinateRegionMake(center, span);
    
    [self.mapView setRegion:newRegion animated:YES];
}
#pragma mark - Map Annotation

- (void)mapView:(MKMapView *)sender didSelectAnnotationView:(MKAnnotationView *)aView
{
    aView.canShowCallout = YES;
    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
}

static NSString *viewId = @"MKPinAnnotationView";

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(Annotation *)annotation
{
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:viewId];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:viewId];
    }
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    
    if([annotation.title isEqualToString:@"Start"])
        annotationView.pinColor = MKPinAnnotationColorGreen;
    else if([annotation.title isEqualToString:@"Finish"])
        annotationView.pinColor = MKPinAnnotationColorRed;
    else
        annotationView.pinColor = MKPinAnnotationColorPurple;
    
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.annotationCoord = ((Annotation *)view.annotation).coordinate;
    
    [self performSegueWithIdentifier:@"informationSegue" sender:self];
}
#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    InformationViewController *infoVC = segue.destinationViewController;
    infoVC.addressCoordinate = self.annotationCoord;
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 2.5;
    renderer.strokeColor = [UIColor purpleColor];
    return renderer;
}

@end
