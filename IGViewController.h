//
//  IGViewController.h
//  fbShowMap
//
//  Created by Ilya on 7/15/14.
//  Copyright (c) 2014 __DevInteractive__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface IGViewController : UIViewController <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

@end
