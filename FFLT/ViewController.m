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
    txtObjectInfo.text = @"";
    [[FacebookManager sharedInstance].Facebook requestWithGraphPath:self.txtObjectId.text andDelegate:self];
    [txtObjectId resignFirstResponder];
}

- (void)_onAuthComplete
{
    btnLogin.enabled = NO;
    btnLogin.alpha = 0.3;
    btnLogout.enabled = YES;
    btnLogout.alpha = 1;
}

/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    //TODO 
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    txtObjectInfo.text = [error localizedDescription];
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result
{
   
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
    self.txtObjectInfo.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    UIImage* img = [[UIImage alloc] initWithData:data];
    if( img != nil )
    {
        [imgProfile setImage:img];
    }
}



@end
