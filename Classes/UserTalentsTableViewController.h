//
//  UserTalentsTableViewController.h
//  SWTOR_Talents
//
//  Created by Vincent Mancini on 12-01-12.
//  Copyright (c) 2012 Vice Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalentViewController.h"
#import "UserTalentsTableViewCell.h"

@interface UserTalentsTableViewController : UITableViewController

{
    BOOL editing;
    NSMutableArray *data;
    
    UIBarButtonItem *editButton;
}

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, strong) UIBarButtonItem *editButton;

- (NSString *) convertTypeToString:(int)type;
- (NSString *) convertTypeToFaction:(int)type;
- (NSString *) convertTypeToIcon:(int)type;

- (IBAction) editClicked:(id)sender;
- (IBAction) deleteClicked:(id)sender;

@end
