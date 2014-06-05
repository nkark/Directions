//
//  MapViewController.h
//  Directions
//
//  Created by Nitin Karki on 4/6/14.
//  Copyright (c) 2014 Nitin Karki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSString *startAddress;
@property (strong, nonatomic) NSString *endAddress;

@end
