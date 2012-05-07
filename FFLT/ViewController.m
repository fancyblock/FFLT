//
//  ViewController.m
//  FFLT
//
//  Created by He jia bin on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (Private)

- (void)_onAuthComplete;

@end

@implementation ViewController

@synthesize btnLogin;
@synthesize btnLogout;
@synthesize txtObjectId;
@synthesize txtObjectInfo;
@synthesize imgProfile;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if( [FacebookManager sharedInstance].IsAuthenticated )
    {
        btnLogin.enabled = NO;
        btnLogin.alpha = 0.3;
        btnLogout.enabled = YES;
        btnLogout.alpha = 1;
    }
    else 
    {
        btnLogin.enabled = YES;
        btnLogin.alpha = 1;
        btnLogout.enabled = NO;
        btnLogout.alpha = 0.3;
    }
 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (IBAction)LoginFB:(id)sender
{
    [[FacebookManager sharedInstance] Authenticate:self withCallback:@selector(_onAuthComplete)];
}

- (IBAction)LogoutFB:(id)sender
{
    [[FacebookManager sharedInstance] Logout];
    
    btnLogin.enabled = YES;
    btnLogin.alpha = 1;
    btnLogout.enabled = NO;
    btnLogout.alpha = 0.3;
}

- (IBAction)SendRequest:(id)sender
{
   
    [[FacebookManager sharedInstance] GetProfile:self withCallback:@selector(_onProfileComplete)];
    
    //[[FacebookManager sharedInstance] GetFriendList:self withCallback:@selector(_onFriendComplete)];
    
    [txtObjectId resignFirstResponder];
}

- (void)_onProfileComplete
{
    UserInfo* info = [FacebookManager sharedInstance]._userInfo;
    
    txtObjectInfo.text = info._name;
    
    [[FacebookManager sharedInstance] LoadPicture:info];
}


- (void)_onFriendComplete
{
    NSArray* friendList = [FacebookManager sharedInstance]._friendList;
    
    UserInfo* info = [friendList objectAtIndex:1];
    
    txtObjectInfo.text = info._name;
}


- (void)_onAuthComplete
{
    btnLogin.enabled = NO;
    btnLogin.alpha = 0.3;
    btnLogout.enabled = YES;
    btnLogout.alpha = 1;
}

@end
