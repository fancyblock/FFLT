//
//  LeaderboardViewController.m
//  FFLT
//
//  Created by He jia bin on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "Parse/Parse.h"


@implementation LeaderboardItem

@synthesize _name;
@synthesize _uid;
@synthesize _mark;

@end


@interface LeaderboardViewController (private)

- (void)loadLeaderboard;
- (void)getMark;

@end

@implementation LeaderboardViewController

@synthesize viewLeaderboard;
@synthesize viewLoading;
@synthesize controlBoardType;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadLeaderboard];
}

- (IBAction)Close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)ChangeType:(id)sender
{
    [self loadLeaderboard];
}

- (void)loadLeaderboard
{
    viewLoading.hidesWhenStopped = YES;
    [viewLoading startAnimating];
    [viewLeaderboard setHidden:YES];
    
    if( [FacebookManager sharedInstance]._userInfo == nil )
    {
        [[FacebookManager sharedInstance] GetProfile:self withCallback:@selector(_onUserProfileComplete)];
    }
    else 
    {
        [self getMark];
    }
}

- (void)_onUserProfileComplete
{
    [[FacebookManager sharedInstance] GetFriendList:self withCallback:@selector(_onFriendListComplete)];
}

- (void)_onFriendListComplete
{
    [self getMark];
}

- (void)getMark
{
    int selectIndex = self.controlBoardType.selectedSegmentIndex;
    
    PFQuery* query = nil;
    
    if( selectIndex == 0 )  // week
    {
        query = [PFQuery queryWithClassName:WEEK_MARK];
    }
    else
    {
        query = [PFQuery queryWithClassName:ALL_MARK];
    }
    
    int count = [[FacebookManager sharedInstance]._friendList count];
    UserInfo* userInfo;
    NSMutableArray* uids = [[NSMutableArray alloc] init];
    for( int i = 0; i < count; i++ )
    {
        userInfo = [[FacebookManager sharedInstance]._friendList objectAtIndex:i];
        
        [uids addObject:userInfo._uid];
    }
    [uids addObject:[FacebookManager sharedInstance]._userInfo._uid];
    
    [query whereKey:@"uid" containedIn:uids];
    [uids release];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error)
     {
         if( error == nil )
         {
             int i;
             int count;
             LeaderboardItem* item = nil;
              
             if( m_leaderboard == nil )
             {
                 m_leaderboard = [[NSMutableArray alloc] init];
             }
             else 
             {
                 count = [m_leaderboard count];
                 
                 for( i = 0; i < count; i++ )
                 {
                     item = [m_leaderboard objectAtIndex:i];
                     
                     [item release];
                 }
                 
                 [m_leaderboard removeAllObjects];
             }
             
             count = [objects count];
             for( i = 0; i < count; i++ )
             {
                 if( selectIndex == 0 )
                 {
                     PFObject* obj = [objects objectAtIndex:i];
                     NSDate* objDate = obj.updatedAt;
                     NSTimeInterval interval = -[objDate timeIntervalSinceNow];
                     
                     if( interval > ONE_WEEK_TIME )
                     {
                         continue;
                     }
                 }
                 
                 item = [[LeaderboardItem alloc] init];
                 
                 item._name = [[objects objectAtIndex:i] objectForKey:@"name"];
                 item._uid = [[objects objectAtIndex:i] objectForKey:@"uid"];
                 item._mark = [[[objects objectAtIndex:i] objectForKey:@"mark"] intValue];
                 
                 [m_leaderboard addObject:item];
             }
             
             // sort the leaderboard
             [m_leaderboard sortUsingComparator:^NSComparisonResult( id obj1, id obj2 )
              {
                  LeaderboardItem* item1 = obj1;
                  LeaderboardItem* item2 = obj2;
                  
                  if( item1._mark > item2._mark )
                  {
                      return NSOrderedAscending;
                  }
                  
                  if( item1._mark < item2._mark )
                  {
                      return NSOrderedDescending;
                  }
                  
                  return NSOrderedSame;
              }];
             
             [viewLoading stopAnimating];
             [viewLeaderboard setHidden:NO];
             [self.viewLeaderboard reloadData];
         }
     }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( m_leaderboard == nil )
    {
        return 0;
    }
    
    return [m_leaderboard count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    if( cell == nil )
    {
        cell = [[UITableViewCell alloc] init];
    }
    
    NSInteger row = [indexPath row];
    LeaderboardItem* item = [m_leaderboard objectAtIndex:row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d. %@   %d", row + 1, item._name, item._mark];
    
    NSArray* friendList = [FacebookManager sharedInstance]._friendList;
    int count = [friendList count];
    
    int i;
    for( i = 0; i <= count; i++ )
    {
        UserInfo* info = nil;
        
        if( i < count )
        {
            info = [friendList objectAtIndex:i];
        }
        else
        {
            info = [FacebookManager sharedInstance]._userInfo;
        }
        
        if( [info._uid isEqualToString:item._uid] )
        {
            if( info._pic == nil )
            {
                info._imageHost = cell.imageView;
                
                [[FacebookManager sharedInstance] LoadPicture:info];
            }
            else 
            {
                [cell.imageView setImage:info._pic];
            }
            
            break;
        }
    }
    
    return cell;
}


// fixed font style. use custom view (UILabel) if you want something different
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"You and your friends";
}


@end
