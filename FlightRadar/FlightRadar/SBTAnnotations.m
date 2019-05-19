//
//  SBTAnnotations.m
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 17/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//

#import "SBTAnnotations.h"
#import "SBTFlightsState.h"
#import "SBTMapViewDelegate.h"

@interface SBTAnnotations()

@end

@implementation SBTAnnotations

-(instancetype)initWithMapView:(MKMapView *)mapView
{
    self = [super init];
    if(self)
    {
        _mapView=mapView;
        self.arrayAnnonations = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Annotations
-(void)annotationAdding:(NSArray *)flights
{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.arrayAnnonations removeAllObjects];

        if (flights != (id)[NSNull null])
        {
            for (NSArray *flight in flights)
            {
                SBTCustomAnnotationView *plain = [[SBTCustomAnnotationView alloc] initWithFlight:flight];
                [self.arrayAnnonations addObject:plain];
            }
        }
    });
    

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotations:self.arrayAnnonations];
        NSLog(@"%lu", self.arrayAnnonations.count);
    });
}

-(void)updateCoordinate
{
    double time = 1;
    double earthRadius = 6378100;
    NSLock *arrayLock = [[NSLock alloc] init];
    [arrayLock lock];
    if((self.arrayAnnonations.count != 0) && (self.arrayAnnonations.count <= 150))
    {
        for (SBTCustomAnnotationView *plain in self.arrayAnnonations)
        {
            MKMapPoint point = MKMapPointForCoordinate(plain.coordinate);
            if(MKMapRectContainsPoint(self.mapView.visibleMapRect, point))
            {
                CLLocationCoordinate2D newCoordinate;
                newCoordinate.latitude = asin(sin(plain.coordinate.latitude*M_PI/180)*cos(time*plain.speed/earthRadius)+cos(plain.coordinate.latitude*M_PI/180)*sin(time*plain.speed/earthRadius)*cos(plain.degrees))*180/M_PI;
                newCoordinate.longitude = plain.coordinate.longitude + atan2(sin(plain.degrees)*sin(time*plain.speed/earthRadius)*cos(plain.coordinate.latitude*M_PI/180), cos(time*plain.speed/earthRadius)-sin(plain.coordinate.latitude*M_PI/180)*sin(newCoordinate.latitude*M_PI/180))*180/M_PI;
                
                [plain setCoordinate:newCoordinate];
            }
        }
    }
    [arrayLock unlock];
}


@end
