//
//  SBTProtocols.h
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 15/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>


@protocol SBTFlightsStateOutputProtocol <NSObject>

- (void)flightsInfoFinishedLoadingWith:(NSArray *)array;

@end

@protocol SBTFlightInfoOutputProtocol <NSObject>

- (void)flightInfoFinishedLoadingWith:(NSDictionary *)dictionary;

@end
