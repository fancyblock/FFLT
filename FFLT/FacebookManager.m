//
//  FacebookManager.m
//  FFLT
//
//  Created by He jia bin on 5/2/12.
//  Copyright (c) 2012 Coconut Island Studio. All rights reserved.
//

#import "FacebookManager.h"


@implementation FacebookManager

@synthesize Facebook = m_facebook;

static FacebookManager* m_singleton = nil;


/**
 * @desc    return the singleton of FacebookManager
 * @para    none
 * @return  FacebookManager
 */
+ (FacebookManager*)sharedInstance
{
    if( m_singleton == nil )
    {
        m_singleton = [[FacebookManager alloc] init];
    }
    
    return m_singleton;
}


/**
 * @desc    init
 * @para    none
 * @return  instance
 */
- (id)init
{
    self = [super init];
    
    m_facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_KEY andDelegate:self];
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ( [defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"] ) 
    {
        m_facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        m_facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    return self;
}


/**
 * @desc    judge if already login the facebook
 * @para    none
 * @return  BOOL
 */
- (BOOL)IsAuthenticated
{
    BOOL isValid = [m_facebook isSessionValid];
    
    return isValid;
}


/**
 * @desc    authenticate the facebook account
 * @para    caller
 * @para    callback
 * @return  none
 */
- (void)Authenticate:(id)caller withCallback:(SEL)callback
{
    m_authCallbackSender = caller;
    m_authCallback = callback;
    
    if( self.IsAuthenticated == NO )
    {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_likes", 
                                @"read_stream",
                                @"user_photos",
                                @"publish_stream",
                                nil];
        
        [m_facebook authorize:nil];
        
        [permissions release];
    }
}


/**
 * @desc    discard the current tokeyKey
 * @para    none
 * @return  none
 */
- (void)Logout
{
    [m_facebook logout];
}


/**
 * @desc    get the user info
 * @para    none
 * @return  none
 */
- (BOOL)GetProfile:(id)caller withCallback:(SEL)callback
{
    if( self.IsAuthenticated == NO )
    {
        return NO;
    }
    
    //TODO 
    
    return YES;
}


//----------------------------- callback function --------------------------------- 


/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin
{
    NSLog( @"Login Facebook success" );
    
    // save the tokeyKey
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[m_facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[m_facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    // invoke the callback
    if( m_authCallback != nil && m_authCallbackSender != nil )
    {
        [m_authCallbackSender performSelector:m_authCallback];
    }
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
    //TODO 
}


/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt
{
    //TODO 
}


/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}


/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated
{
    NSLog( @"Session Invalidated" );
    
    //TODO 
}


/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    //TODO 
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
    //TODO 
}


@end
