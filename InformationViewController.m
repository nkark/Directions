//
//  InformationViewController.m
//  Directions
//
//  Created by Nitin Karki on 4/7/14.
//  Copyright (c) 2014 Nitin Karki. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController ()

@property (strong, nonatomic) NSString *addressString;

@end

@implementation InformationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)closePressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    CLLocation *currentLocation = [[CLLocation alloc]initWithLatitude:self.addressCoordinate.latitude longitude:self.addressCoordinate.longitude];
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            MKPlacemark *placemark = [placemarks lastObject];
            NSString *street = [NSString stringWithFormat:@"%@ %@",placemark.subThoroughfare,placemark.thoroughfare];
            self.addressString = [NSString stringWithFormat:@"%@\n%@, %@ %@",street, placemark.locality, placemark.administrativeArea, placemark.postalCode];
            
            self.textView.text = [NSString stringWithFormat:@"Address:\n\n%@",self.addressString];
        } else {
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Error" message:@"Failed to Reverse Geocode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
    } ];
    
}
@end
