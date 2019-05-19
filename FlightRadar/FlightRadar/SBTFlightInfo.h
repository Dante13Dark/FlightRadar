//
//  SBTFlightInfo.h
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 18/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBTProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBTFlightInfo : NSObject
@property (nonatomic, strong) NSDictionary *currentFlight;

-(void)getFlightInfo:(NSString *)callsign;
@property (nonatomic, weak) id<SBTFlightInfoOutputProtocol> output;

@end

NS_ASSUME_NONNULL_END
