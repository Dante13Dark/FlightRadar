//
//  SBTMapView.h
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 15/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

NS_ASSUME_NONNULL_BEGIN

@interface SBTMapView : NSObject

@property (nonatomic, strong) MKMapView *mapView;

-(instancetype)initWithViewController:(UIViewController *)viewController;

-(void)zoomInButtonDidTape;
-(void)zoomOutButtonDidTape;
-(void)centerPozition:(CLLocationManager *)locationManager;
-(void)getFlightsState;
-(void)updateCoordinate;

@end

NS_ASSUME_NONNULL_END
