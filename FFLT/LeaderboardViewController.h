//
//  LeaderboardViewController.h
//  FFLT
//
//  Created by He jia bin on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookManager.h"

#define WEEK_MARK   @"GameMark_week"
#define ALL_MARK    @"GameMark2"
#define ONE_WEEK_TIME 604800


@interface LeaderboardItem : NSObject

@property (nonatomic, retain) NSString* _name;
@property (nonatomic, retain) NSString* _uid;
@property (nonatomic, readwrite) int _mark;

@end


@interface LeaderboardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* m_leaderboard;
}

@property (nonatomic, retain) IBOutlet UITableView* viewLeaderboard;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* viewLoading;
@property (nonatomic, retain) IBOutlet UISegmentedControl* controlBoardType;


- (IBAction)Close:(id)sender;

- (IBAction)ChangeType:(id)sender;

@end
