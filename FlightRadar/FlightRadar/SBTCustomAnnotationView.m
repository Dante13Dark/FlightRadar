//
//  SBTCustomAnnotationView.m
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 15/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//

#import "SBTCustomAnnotationView.h"

@implementation SBTCustomAnnotationView

-(id)initWithFlight:(NSArray *)flight
{
    self = [super init];
    
    if(self)
    {
        if ((flight[5] != (id)[NSNull null]) && (flight[6] != (id)[NSNull null]) && (flight[10] != (id)[NSNull null]) && (flight[9] != (id)[NSNull null]) )
        {
            _flight = flight;
            _title = flight[1];
            _coordinate.latitude = [flight[6] doubleValue];
            _coordinate.longitude = [flight[5] doubleValue];
            _degrees = [flight[10] doubleValue]* M_PI/180;
            _speed = [flight[9] doubleValue];
        }
    }
    return self;
}


-(MKAnnotationView *)annotationView
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"Plane"];
    annotationView.clusteringIdentifier = @"Cluster";
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [self imageWithImage:[UIImage imageNamed:@"smallplane.png"]];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    [self customView:annotationView];
    [annotationView prepareForReuse];
    return annotationView;
}


- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

- (UIImage *)imageWithImage:(UIImage *)image
{
    CGAffineTransform t = CGAffineTransformMakeRotation(self.degrees);
    CGRect sizeRect = (CGRect) {.size = image.size};
    CGRect destRect = CGRectApplyAffineTransform(sizeRect, t);
    CGSize destinationSize = destRect.size;
    
    UIGraphicsBeginImageContext(destinationSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, destinationSize.width / 2.0f, destinationSize.height / 2.0f);
    CGContextRotateCTM(context, self.degrees);
    [image drawInRect:CGRectMake(-image.size.width / 2.0f, -image.size.height / 2.0f, image.size.width, image.size.height)];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
