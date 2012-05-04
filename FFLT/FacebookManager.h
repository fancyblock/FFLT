//
//  FacebookManager.h
//  FFLT
//
//  Created by He jia bin on 5/2/12.
//  Copyright (c) 2012 Coconut Island Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

#define FACEBOOK_APP_KEY @"441674662525532"


@interface FacebookManager : NSObject <FBSessionDelegate, FBRequestDelegate, FBDialogDelegate>
{
    Facebook* m_facebook;
    
    id m_authCallbackSender;
    SEL m_authCallback;
}

@property (nonatomic, readonly) BOOL IsAuthenticated;

@property (nonatomic, retain) Facebook* Facebook;


+ (FacebookManager*)sharedInstance;

- (void)Authenticate:(id)caller withCallback:(SEL)callback;

- (void)Logout;

- (BOOL)GetProfile:(id)caller withCallback:(SEL)callback;

@end
