//
//  Annotation.h
//  Directions
//
//  Created by Nitin Karki on 4/7/14.
//  Copyright (c) 2014 Nitin Karki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property (assign,nonatomic) CLLocationCoordinate2D coordinate;
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSString *address;


@end
