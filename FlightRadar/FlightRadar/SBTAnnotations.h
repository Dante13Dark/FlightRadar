//
//  SBTAnnotations.h
//  FlightRadar
//
//  Created by Yaroslav Tutushkin on 17/05/2019.
//  Copyright © 2019 Yaroslav Tutushkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBTProtocols.h"
#import "SBTCustomAnnotationView.h"
@import MapKit;

NS_ASSUME_NONNULL_BEGIN

@interface SBTAnnotations : NSObject
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray <SBTCustomAnnotationView *> *arrayAnnonations;

-(instancetype)initWithMapView:(MKMapView *)mapView;
-(void)annotationAdding:(NSArray *)flights;
-(void)updateCoordinate;
@end

NS_ASSUME_NONNULL_END
