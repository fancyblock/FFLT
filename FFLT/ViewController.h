//
//  ViewController.h
//  FFLT
//
//  Created by He jia bin on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookManager.h"
#import "LeaderboardViewController.h"

@interface ViewController : UIViewController
{
    //TODO 
}

@property (retain,nonatomic) IBOutlet UIButton* btnLogin;
@property (retain,nonatomic) IBOutlet UIButton* btnLogout;
@property (retain,nonatomic) IBOutlet UITextField* txtScore;

@property (retain,nonatomic) IBOutlet LeaderboardViewController* viewLeaderboard;


- (IBAction)LoginFB:(id)sender;

- (IBAction)LogoutFB:(id)sender;

- (IBAction)SubmitScore:(id)sender;

- (IBAction)ShowLeaderboard:(id)sender;

- (IBAction)CloseKeyboard:(id)sender;

- (IBAction)PostToWall:(id)sender;

@end
