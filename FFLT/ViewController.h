//
//  ViewController.h
//  FFLT
//
//  Created by He jia bin on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookManager.h"

@interface ViewController : UIViewController
{
    //TODO 
}

@property (retain,nonatomic) IBOutlet UIButton* btnLogin;
@property (retain,nonatomic) IBOutlet UIButton* btnLogout;
@property (retain,nonatomic) IBOutlet UITextField* txtObjectId;
@property (retain,nonatomic) IBOutlet UITextView* txtObjectInfo;
@property (retain,nonatomic) IBOutlet UIImageView* imgProfile;


- (IBAction)LoginFB:(id)sender;

- (IBAction)LogoutFB:(id)sender;

- (IBAction)SendRequest:(id)sender;

@end
