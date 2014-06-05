//
//  MainViewController.h
//  Directions
//
//  Created by Nitin Karki on 4/6/14.
//  Copyright (c) 2014 Nitin Karki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController

//START
@property (strong, nonatomic) IBOutlet UITextField *startStreetTF;
@property (strong, nonatomic) IBOutlet UITextField *startCityTF;
@property (strong, nonatomic) IBOutlet UITextField *startStateTF;
@property (strong, nonatomic) IBOutlet UITextField *startZipTF;
@property (strong, nonatomic) IBOutlet UIButton *startCurrentButton;
@property (strong, nonatomic) IBOutlet UILabel *startLabel;



//END
@property (strong, nonatomic) IBOutlet UITextField *endStreetTF;
@property (strong, nonatomic) IBOutlet UITextField *endCityTF;
@property (strong, nonatomic) IBOutlet UITextField *endStateTF;
@property (strong, nonatomic) IBOutlet UITextField *endZipTF;
@property (strong, nonatomic) IBOutlet UIButton *endCurrentButton;
@property (strong, nonatomic) IBOutlet UILabel *endLabel;

@property (strong, nonatomic) IBOutlet UIButton *directionsButton;
@end
