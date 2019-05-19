//
//  SBTFlightsState.h
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 15/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBTProtocols.h"
NS_ASSUME_NONNULL_BEGIN

@interface SBTFlightsState : NSObject

@property (nonatomic, strong) NSArray *currentFlights;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, weak) id<SBTFlightsStateOutputProtocol> output;

-(void)getFlightsInfo:(CLLocationCoordinate2D)swCoord and:(CLLocationCoordinate2D)neCoord;

@end

NS_ASSUME_NONNULL_END
