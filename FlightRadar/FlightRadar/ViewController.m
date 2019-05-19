//
//  ViewController.m
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 15/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//

#import "ViewController.h"
#import "SBTMapView.h"
#import "SBTFlightsState.h"
#import "SBTProtocols.h"
#import "SBTAnnotations.h"

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) SBTMapView *myMap;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myMap = [[SBTMapView alloc] initWithViewController:self];
    [self locationManagerCreate];
    [self createUI];

    [self centerPozition];
    [self getFlightsState];
}

- (void)locationManagerCreate
{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    if ([CLLocationManager locationServicesEnabled])
    {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
}

-(void)createUI
{
    UIButton *zoomIn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, [UIScreen mainScreen].bounds.size.height/2-50, 50, 50)];
    [zoomIn setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [self.view addSubview:zoomIn];
    [zoomIn addTarget:self action:@selector(zoomInButtonDidTape) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *zoomOut = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, [UIScreen mainScreen].bounds.size.height/2, 50, 50)];
    [zoomOut setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
    [self.view addSubview:zoomOut];
    [zoomOut addTarget:self action:@selector(zoomOutButtonDidTape) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *pozition = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, [UIScreen mainScreen].bounds.size.height/2+50, 50, 50)];
    [pozition setImage:[UIImage imageNamed:@"pozition.png"] forState:UIControlStateNormal];
    [self.view addSubview:pozition];
    [pozition addTarget:self action:@selector(centerPozition) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *getFlights = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, [UIScreen mainScreen].bounds.size.height/2+50+50, 50, 50)];
    [getFlights setImage:[UIImage imageNamed:@"flight.png"] forState:UIControlStateNormal];
    [self.view addSubview:getFlights];
    [getFlights addTarget:self action:@selector(getFlightsState) forControlEvents:UIControlEventTouchUpInside];
}

-(void)zoomInButtonDidTape
{
    [self.myMap zoomInButtonDidTape];
}

-(void)zoomOutButtonDidTape
{
    [self.myMap zoomOutButtonDidTape];
}

-(void)centerPozition
{
    [self.myMap centerPozition:self.locationManager];
}

-(void)getFlightsState
{
    [self.myMap getFlightsState];
}

-(void)updateFlights
{
    [self.myMap updateCoordinate];
}


@end
