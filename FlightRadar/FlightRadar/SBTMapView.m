//
//  SBTMapView.m
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 15/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//

#import "SBTMapView.h"
#import "SBTAnnotations.h"
#import "SBTMapViewDelegate.h"

@interface SBTMapView() 

@property (nonatomic, assign) CLLocationDegrees latitudeDelta;
@property (nonatomic, assign) CLLocationDegrees longitudeDelta;
@property (nonatomic, strong) SBTAnnotations *myAnnotations;
@property (nonatomic, strong) SBTMapViewDelegate *myMapViewDelegate;


@end

@implementation SBTMapView

-(instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if(self)
    {
        self.mapView = [[MKMapView alloc] initWithFrame:viewController.view.frame];
        [viewController.view addSubview:self.mapView];
        self.mapView.showsUserLocation = YES;
        self.myAnnotations = [[SBTAnnotations alloc] initWithMapView:self.mapView];
        self.myMapViewDelegate = [[SBTMapViewDelegate alloc] initWithAnnotations:self.myAnnotations];
    }
    return self;
}


#pragma mark - Buttons
-(void)zoomInButtonDidTape
{
    self.latitudeDelta = self.mapView.region.span.latitudeDelta / 2;
    self.longitudeDelta = self.mapView.region.span.longitudeDelta / 2;
    [self myZoomMethod];
}

-(void)zoomOutButtonDidTape
{
    self.latitudeDelta = self.mapView.region.span.latitudeDelta * 2;
    if (self.latitudeDelta > 180) {self.latitudeDelta = 180;};
    self.longitudeDelta = self.mapView.region.span.longitudeDelta * 2;
    if (self.longitudeDelta > 360) {self.longitudeDelta = 360;};
    [self myZoomMethod];
}

-(void)myZoomMethod
{
    MKCoordinateSpan span = MKCoordinateSpanMake(self.latitudeDelta, self.longitudeDelta);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.centerCoordinate, span);
    [self.mapView setRegion:region animated:YES];
}

-(void)centerPozition:(CLLocationManager *)locationManager
{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude,  locationManager.location.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.4 , 0.4);
    MKCoordinateRegion deviceRegion = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:deviceRegion animated:YES];
}

-(void)getFlightsState
{
    [self.myMapViewDelegate getFlightsState];
}


-(void)updateCoordinate
{
    [self.myAnnotations updateCoordinate];
}

@end
