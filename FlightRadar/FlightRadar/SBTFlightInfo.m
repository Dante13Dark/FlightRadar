//
//  SBTFlightInfo.m
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 18/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//

#import "SBTFlightInfo.h"

@implementation SBTFlightInfo

-(void)getFlightInfo:(NSString *)callsign
{
    NSString *apiKey = @"45de5c-f8966f";
    NSString *urlString = [NSString stringWithFormat:@"http://aviation-edge.com/v2/public/flights?key=%@&flightIcao=%@",apiKey, callsign];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:5];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil)
        {
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if ([json isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"Нет информации");
            }
            else
            {
                NSLog(@"Информации получена");
                self.currentFlight = json[0];
                [self.output flightInfoFinishedLoadingWith:self.currentFlight];
            }
        }
        else
        {
            NSLog(@"Error %@",error);
        }
    }];
    [sessionDataTask resume];
}

@end
