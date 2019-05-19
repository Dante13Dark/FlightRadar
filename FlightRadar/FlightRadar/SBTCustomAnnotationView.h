//
//  SBTCustomAnnotationView.h
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 15/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

NS_ASSUME_NONNULL_BEGIN

@interface SBTCustomAnnotationView : NSObject <MKAnnotation>


@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) double degrees;
@property (nonatomic, readonly) double speed;
@property (nonatomic, strong) NSArray *flight;


-(id)initWithFlight:(NSArray *)flight;
-(MKAnnotationView *)annotationView;

@end

NS_ASSUME_NONNULL_END
