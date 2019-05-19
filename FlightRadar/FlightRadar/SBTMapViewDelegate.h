//
//  SBTMapViewDelegate.h
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 17/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBTProtocols.h"
#import "SBTAnnotations.h"

@import MapKit;

NS_ASSUME_NONNULL_BEGIN

@interface SBTMapViewDelegate : NSObject <MKMapViewDelegate, SBTFlightsStateOutputProtocol, SBTFlightInfoOutputProtocol>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, weak) id<MKMapViewDelegate> delegate;

-(instancetype)initWithAnnotations:(SBTAnnotations *)annotations;
-(void)getFlightsState;


@end

NS_ASSUME_NONNULL_END
