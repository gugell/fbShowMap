//
//  IGViewController.m
//  fbShowMap
//
//  Created by Ilya on 7/15/14.
//  Copyright (c) 2014 __DevInteractive__. All rights reserved.
//

#import "IGViewController.h"

@interface IGViewController ()
{
    BOOL isLogged;
}

@end

@implementation IGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"creativity-back.png"]]];
    self.loginView.readPermissions=@[@"public_profile", @"email"];
    self.loginView.delegate=self;
    isLogged=NO;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{

    NSLog(@"Loged");
    isLogged=YES;
    
   
}
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
       NSLog( @"You are logged out");
    isLogged=NO;
    
}
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:user forKey:@"info"];
    [defaults synchronize];
    if(isLogged) {
        [NSTimer scheduledTimerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(showMap)
                                       userInfo:nil
                                        repeats:NO];

       
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    if(isLogged){
        
        [self showMap];
        
    }
}
-(void)showMap{
   
    UIViewController * vc=[self.storyboard instantiateViewControllerWithIdentifier:@"mapVc"];
    [self.navigationController pushViewController:vc animated:NO];

}
- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error{
    [self handleAuthError:error];
}
- (void)handleAuthError:(NSError *)error
    {
        NSString *alertText;
        NSString *alertTitle;
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            // Error requires people using you app to make an action outside your app to recover
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
            
        } else {
            
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                
                alertTitle = @"Login cancelled";
                alertText = @"You need to login to access this part of the app";
                [self showMessage:alertText withTitle:alertTitle];
                
            }else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryServer) {
                
                alertTitle = @"Server error";
                alertText = @"Please try again later";
                [self showMessage:alertText withTitle:alertTitle];
                
            }
            else {
                
                alertTitle = @"Something went wrong";
                alertText = @"Please retry";
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
    }
    
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
    {
        [[[UIAlertView alloc] initWithTitle:title
                                    message:text
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }


@end
