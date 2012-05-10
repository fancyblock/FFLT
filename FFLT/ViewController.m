//
//  ViewController.m
//  FFLT
//
//  Created by He jia bin on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Parse/Parse.h"

@interface ViewController (Private)

- (void)_onAuthComplete;
- (void)submitMark:(int)mark withName:(NSString*)name andUID:(NSString*)uid to:(NSString*)table;

@end

@implementation ViewController

@synthesize btnLogin;
@synthesize btnLogout;
@synthesize txtScore;
@synthesize viewLeaderboard;


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
    
    self.viewLeaderboard = [[LeaderboardViewController alloc] initWithNibName:@"LeaderboardViewController" bundle:nil];
 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [self.viewLeaderboard release];
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


- (IBAction)ShowLeaderboard:(id)sender
{
    self.viewLeaderboard.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:self.viewLeaderboard animated:YES completion:NULL];
}


- (IBAction)SubmitScore:(id)sender;
{
    if ( [self.txtScore.text isEqualToString:@""] )
    {
        return;
    }
    
    if( [FacebookManager sharedInstance]._userInfo == nil )
    {
        [[FacebookManager sharedInstance] GetProfile:self withCallback:@selector(_onProfileComplete)];
    }
    else 
    {
        [self _onProfileComplete];
    }
}


- (IBAction)CloseKeyboard:(id)sender
{
    [txtScore resignFirstResponder];
}


- (IBAction)PostToWall:(id)sender
{
    NSLog( @"Post the info to wall" );
    
    //TODO 
}


- (void)submitMark:(int)mark withName:(NSString*)name andUID:(NSString*)uid to:(NSString*)table;
{
    PFQuery* query = [PFQuery queryWithClassName:table];
    
    [query whereKey:@"uid" equalTo:uid];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error)
     {
         if( error == nil )
         {
             PFObject *gameScore = nil;
             
             if( [objects count] == 0 )
             {
                 gameScore = [PFObject objectWithClassName:table];
             }
             else 
             {
                 gameScore = [objects objectAtIndex:0];
             }
             
             int oldMark = [[gameScore valueForKey:@"mark"] intValue];
             
             if( mark <= oldMark )
             {
                 return;
             }
             
             [gameScore setObject:[NSNumber numberWithInt:mark] forKey:@"mark"];
             [gameScore setObject:name forKey:@"name"];
             [gameScore setObject:uid forKey:@"uid"];
             [gameScore saveEventually];
         }
     }];

}


- (void)_onProfileComplete
{
    UserInfo* info = [FacebookManager sharedInstance]._userInfo;
    
    [self submitMark:[self.txtScore.text intValue] withName:info._name andUID:info._uid to:@"GameMark_week"];
    [self submitMark:[self.txtScore.text intValue] withName:info._name andUID:info._uid to:@"GameMark2"];
}


- (void)_onAuthComplete
{
    btnLogin.enabled = NO;
    btnLogin.alpha = 0.3;
    btnLogout.enabled = YES;
    btnLogout.alpha = 1;
}

@end
