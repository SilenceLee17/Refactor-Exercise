//
//  XDLocationManager.m
//  meituan
//
//  Created by 李兴东 on 17/1/6.
//  Copyright © 2017年 xingshao. All rights reserved.
//

#import "XDLocationManager.h"
@interface XDLocationManager ()<CLLocationManagerDelegate>
{
    CLLocation *_checkLocation;//用于保存位置信息
}
@end

@implementation XDLocationManager

+ (XDLocationManager *)sharedManager
{
    static XDLocationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}
//设置定位
-(void)setupLocationManager{
    _latitude = LATITUDE_DEFAULT;
    _longitude = LONGITUDE_DEFAULT;
    _locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"开始定位");
        _locationManager.delegate = self;
        // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
        // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
        _locationManager.distanceFilter = 200.0;
        // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        
        //ios8+以上要授权，并且在plist文件中添加NSLocationWhenInUseUsageDescription，NSLocationAlwaysUsageDescription，值可以为空
        if (IOS_VERSION >=8.0) {//ios8+，不加这个则不会弹框
            [_locationManager requestWhenInUseAuthorization];//使用中授权
            [_locationManager requestAlwaysAuthorization];
        }
        [_locationManager startUpdatingLocation];
    }else{
        NSLog(@"定位失败，请确定是否开启定位功能");
        //        _locationManager.delegate = self;
        //        // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
        //        // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
        //        _locationManager.distanceFilter = 200.0;
        //        // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
        //        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //        [_locationManager startUpdatingLocation];
    }
}
#pragma mark - CLLocationManagerDelegate
//ios 6.0sdk以上
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"didUpdateToLocation+++");
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *cl = [locations lastObject];
    _latitude = cl.coordinate.latitude;
    _longitude = cl.coordinate.longitude;
    NSLog(@"纬度--%f",_latitude);
    NSLog(@"经度--%f",_longitude);
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
}

@end
