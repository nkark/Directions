//
//  InformationViewController.h
//  Directions
//
//  Created by Nitin Karki on 4/7/14.
//  Copyright (c) 2014 Nitin Karki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface InformationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (assign, nonatomic) CLLocationCoordinate2D addressCoordinate;

@end
