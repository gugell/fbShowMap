//
//  IGMapViewController.m
//  fbShowMap
//
//  Created by Ilya on 7/15/14.
//  Copyright (c) 2014 __DevInteractive__. All rights reserved.
//

#import "IGMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>


@interface IGMapViewController ()

@end

@implementation IGMapViewController
{
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
    GMSMarker *marker;
    CGFloat screenWidth ;
    CGFloat screenHeight;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    locationManager = [[CLLocationManager alloc] init];
    
    
    mapView_.settings.myLocationButton = YES;
    mapView_.myLocationEnabled = YES;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:mapView_.myLocation.coordinate.latitude
                                                            longitude:mapView_.myLocation.coordinate.longitude
                                                                 zoom:2];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo=[NSDictionary dictionaryWithDictionary:[defaults objectForKey:@"info"]];
    UILabel *userName=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 20)];
    userName.text=userInfo[@"name"];
   
    self.view = mapView_;
    
    UIButton *terminateSession=[[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2-40, screenHeight-60, 80 ,40)];
    [terminateSession setImage:[UIImage imageNamed:@"images.jpeg"] forState:UIControlStateNormal];
    [terminateSession addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:userName];
    [self.view addSubview:terminateSession];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)exit{
    
    NSLog(@"Logged out of facebook");
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    [FBSession.activeSession closeAndClearTokenInformation];
    [self.navigationController popToRootViewControllerAnimated:YES];

}
-(void)getCurrentLocation{

    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];

}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *myLocation = newLocation;
    
    if (myLocation != nil) {
  
         marker= [[GMSMarker alloc] init];
         NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
         NSDictionary *userInfo=[NSDictionary dictionaryWithDictionary:[defaults objectForKey:@"info"]];
         
         marker.position = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
         marker.map = mapView_;
       // [mapView_ animateToLocation:CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude)];
       [ mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:myLocation.coordinate.latitude
                                                                                                 longitude:myLocation.coordinate.longitude
                                                                           zoom:20]];
         marker.title = userInfo[@"name"];
         marker.snippet = userInfo[@"link"];
    }
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(getCurrentLocation)
                                   userInfo:nil
                                    repeats:NO];
      NSLog(@"User's location: %@", mapView_.myLocation);

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
