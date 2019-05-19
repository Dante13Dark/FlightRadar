//
//  SBTMapViewDelegate.m
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 17/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//

#import "SBTMapViewDelegate.h"
#import "SBTCustomAnnotationView.h"
#import "SBTFlightsState.h"
#import "SBTFlightInfo.h"

@interface SBTMapViewDelegate()

@property (nonatomic, strong) SBTFlightsState *flightsState;
@property (nonatomic, strong) SBTFlightInfo *flightInfo;
@property (nonatomic, strong) SBTAnnotations *annotations;
@property (nonatomic, assign) CLLocationCoordinate2D swCoord;
@property (nonatomic, assign) CLLocationCoordinate2D neCoord;
@property (nonatomic, strong) NSMutableArray *airportAnnotationsArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL indicator;

@end

@implementation SBTMapViewDelegate

-(instancetype)initWithAnnotations:(SBTAnnotations *)annotations
{
    self = [super init];
    if(self)
    {
        _annotations=annotations;
        _mapView=annotations.mapView;
        _mapView.delegate = self;
        self.flightsState = [[SBTFlightsState alloc] init];
        self.flightsState.output = self;
        self.flightInfo = [[SBTFlightInfo alloc]init];
        self.flightInfo.output = self;
        self.airportAnnotationsArray = [NSMutableArray new];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
        self.indicator = YES;
    }
    return self;
}

-(void)startTimer
{
    [_annotations updateCoordinate];
}
#pragma mark - MKMapView delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[SBTCustomAnnotationView class]])
    {
        SBTCustomAnnotationView *planeLocation = (SBTCustomAnnotationView *)annotation;
        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Plane"];
        annotationView = planeLocation.annotationView;
        if (self.annotations.arrayAnnonations.count > 125)
        {
            annotationView.clusteringIdentifier = @"Cluster";
        }
        return annotationView;
    }
    
    return nil;

}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    animated = YES;
    if(self.indicator)
    {
        [self getFlightsState];
    }
}


#pragma mark - getFlightsState
-(void)getMapCorners
{
    CGPoint swPoint = CGPointMake(self.mapView.bounds.origin.x, self.mapView.bounds.size.height);
    self.swCoord = [self.mapView convertPoint:swPoint toCoordinateFromView:self.mapView];
    CGPoint nePoint = CGPointMake(self.mapView.bounds.size.width, self.mapView.bounds.origin.y);
    self.neCoord = [self.mapView convertPoint:nePoint toCoordinateFromView:self.mapView];
}

-(void)getFlightsState
{
    self.indicator = YES;
    [self getMapCorners];
    [self.flightsState getFlightsInfo:self.swCoord and:self.neCoord];
    [self.mapView removeOverlays:self.mapView.overlays];
}

- (void)flightsInfoFinishedLoadingWith:(NSArray *)array
{
    [self.annotations annotationAdding:array];
}


#pragma mark - getFlightInfo
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [self.airportAnnotationsArray removeAllObjects];
    if ([view.annotation isKindOfClass:[SBTCustomAnnotationView class]])
    {
        NSLog(@"%@",view.annotation.title);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *callsignString= [[NSString stringWithFormat:@"%@",view.annotation.title] stringByReplacingOccurrencesOfString:@" " withString:@""];
            [self.flightInfo getFlightInfo:callsignString];
        });
    }
}

- (void)flightInfoFinishedLoadingWith:(NSDictionary *)array
{
    NSString *departure = array[@"departure"][@"iataCode"];
    NSString *arrival = array[@"arrival"][@"iataCode"];
    [self findingAirport:departure];
    [self findingAirport:arrival];
}

-(void)findingAirport:(NSString *)airportName
{
    MKLocalSearchRequest* request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = [NSString stringWithFormat: @"%@ Аэропорт",airportName];;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            [self.airportAnnotationsArray addObject:[response.mapItems[0] placemark]];
        } else
        {
            NSLog(@"Search Request Error: %@", [error localizedDescription]);
        }
    }];
}

-(void)afterComplitionHandler
{
    self.indicator = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.mapView addAnnotations:self.airportAnnotationsArray];
            [self createGeoPolyline:self.airportAnnotationsArray];
            [self.mapView showAnnotations:self.airportAnnotationsArray animated:YES];
            [self.airportAnnotationsArray removeAllObjects];
    });
    
}
- (void)createGeoPolyline:(NSMutableArray *)airports
{
    CLLocationCoordinate2D departure = CLLocationCoordinate2DMake([airports[0] coordinate].latitude,[airports[0] coordinate].longitude);
    CLLocationCoordinate2D arrival = CLLocationCoordinate2DMake([airports[1] coordinate].latitude,[airports[1] coordinate].longitude);
    CLLocationCoordinate2D points[] = {departure, arrival};
    
    MKGeodesicPolyline *track = [MKGeodesicPolyline polylineWithCoordinates:&points[0] count:2];
    [self.mapView addOverlay:track];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = UIColor.blueColor;
    renderer.lineWidth = 3;
    
    return renderer;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (self.airportAnnotationsArray.count != 0)
    {
        [self afterComplitionHandler];
        [self.airportAnnotationsArray addObject:view.annotation];
    }
}
@end
