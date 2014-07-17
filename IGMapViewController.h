//
//  IGMapViewController.h
//  fbShowMap
//
//  Created by Ilya on 7/15/14.
//  Copyright (c) 2014 __DevInteractive__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface IGMapViewController : UIViewController<CLLocationManagerDelegate ,FBLoginViewDelegate>

@end
