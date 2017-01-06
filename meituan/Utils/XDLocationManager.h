//
//  XDLocationManager.h
//  meituan
//
//  Created by 李兴东 on 17/1/6.
//  Copyright © 2017年 xingshao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface XDLocationManager : NSObject
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

+ (XDLocationManager *)sharedManager;
-(void)setupLocationManager;
@end
