//
//  MainViewController.m
//  Directions
//
//  Created by Nitin Karki on 4/6/14.
//  Copyright (c) 2014 Nitin Karki. All rights reserved.
//

#import "MainViewController.h"
#import "MapViewController.h"

@interface MainViewController ()

@property (strong,nonatomic) NSString *startAddress;
@property (strong,nonatomic) NSString *endAddress;
@property (strong,nonatomic) NSString *currentStreet;
@property (strong,nonatomic) NSString *currentCity;
@property (strong,nonatomic) NSString *currentState;
@property (strong,nonatomic) NSString *currentZip;


@end

@implementation MainViewController

CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hideKeyboard];
 
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    self.startLabel.font = [UIFont fontWithName:@"Grouser" size:30];
    self.startLabel.textColor = [UIColor blueColor];
    self.endLabel.font = [UIFont fontWithName:@"Grouser" size:30];
    self.endLabel.textColor = [UIColor blueColor];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //GET CURRENT LOCATION
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}


#pragma mark - Get Directions Button Action

- (IBAction)directionsButtonPressed:(id)sender {
    
    self.startAddress =
    [NSString stringWithFormat:
     @"%@ %@ %@ %@",
     self.startStreetTF.text, // street addr
     self.startCityTF.text, // city
     self.startStateTF.text, // state
     self.startZipTF.text]; // zip

    self.endAddress =
    [NSString stringWithFormat:
     @"%@ %@ %@ %@",
     self.endStreetTF.text, // street addr
     self.endCityTF.text, // city
     self.endStateTF.text, // state
     self.endZipTF.text]; // zip
    
    if([self.startStreetTF.text isEqualToString:@""]|[self.startCityTF.text isEqualToString:@""]|[self.endStreetTF.text isEqualToString:@""]|[self.endCityTF.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fill out all fields." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self performSegueWithIdentifier:@"mapSegue" sender:self];
    }
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //PASS DATA TO MAPS VIEW CONTROLLER
    MapViewController *mapVC = segue.destinationViewController;
    mapVC.startAddress = self.startAddress;
    mapVC.endAddress = self.endAddress;
}

#pragma mark - Current Location Button Actions

- (IBAction)startCurrentPressed:(id)sender {
    
    self.startStreetTF.text = self.currentStreet;
    self.startCityTF.text = self.currentCity;
    self.startStateTF.text = self.currentState;
    self.startZipTF.text = self.currentZip;
}

- (IBAction)endCurrentPressed:(id)sender {
    
    self.endStreetTF.text = self.currentStreet;
    self.endCityTF.text = self.currentCity;
    self.endStateTF.text = self.currentState;
    self.endZipTF.text = self.currentZip;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Warning" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    // Stop Location Manager - save battery power
    [locationManager stopUpdatingLocation];
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            self.currentStreet = [NSString stringWithFormat:@"%@ %@",placemark.subThoroughfare,placemark.thoroughfare];
            self.currentCity = placemark.locality;
            self.currentState = placemark.administrativeArea;
            self.currentZip = placemark.postalCode;
            
            self.startCurrentButton.hidden = NO;
            self.endCurrentButton.hidden = NO;
        } else {
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Error" message:@"Failed to Reverse Geocode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
    } ];
}

#pragma mark - Return Key

-(void) hideKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //RETURN KEY HIDES KEYBOARD
    [self.startStreetTF addTarget:self.startStreetTF
                           action:@selector(resignFirstResponder)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.startCityTF addTarget:self.startCityTF
                         action:@selector(resignFirstResponder)
               forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.startStateTF addTarget:self.startStateTF
                          action:@selector(resignFirstResponder)
                forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.startZipTF addTarget:self.startZipTF
                        action:@selector(resignFirstResponder)
              forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.endStreetTF addTarget:self.endStreetTF
                         action:@selector(resignFirstResponder)
               forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.endCityTF addTarget:self.endCityTF
                       action:@selector(resignFirstResponder)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.endStateTF addTarget:self.endStateTF
                        action:@selector(resignFirstResponder)
              forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.endZipTF addTarget:self.endZipTF
                      action:@selector(resignFirstResponder)
            forControlEvents:UIControlEventEditingDidEndOnExit];
    
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    if(self.endStateTF.isEditing|self.endZipTF.isEditing)
        [UIView animateWithDuration:.3 animations:^{
            [self.view setFrame:CGRectMake(0,-90,320,568)];
        }];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:.3 animations:^{
    [self.view setFrame:CGRectMake(0,0,320,568)];
    }];
}
@end
