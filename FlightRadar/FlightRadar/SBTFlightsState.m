//
//  SBTFlightsState.m
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 15/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//

#import "SBTFlightsState.h"

@implementation SBTFlightsState

-(void)getFlightsInfo:(CLLocationCoordinate2D)swCoord and:(CLLocationCoordinate2D)neCoord
{
    [self.session finishTasksAndInvalidate];
    NSString *urlString;
    if((swCoord.longitude*neCoord.longitude<=0)&&(fabs(swCoord.longitude*neCoord.longitude)>4300))
    {
        urlString = [NSString stringWithFormat:@"https://Dante13Dark:Pro100Yarik@opensky-network.org/api/states/all"];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"https://Dante13Dark:Pro100Yarik@opensky-network.org/api/states/all?lamin=%f&lomin=%f&lamax=%f&lomax=%f",swCoord.latitude, swCoord.longitude, neCoord.latitude, neCoord.longitude];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *sessionDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            self.currentFlights = json[@"states"];
            [self.output flightsInfoFinishedLoadingWith:self.currentFlights];
        }
        else
        {
            NSLog(@"Error %@",error);
        }
    }];
    [sessionDataTask resume];
}


@end
