//
//  ItemView.h
//  SWTOR_Talents
//
//  Created by Vincent Mancini on 12-01-08.
//  Copyright 2012 Vice Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ItemViewHeight 52
#define ItemViewWidth 52

@interface ItemView : UIButton <NSCopying> {
	int item;
	int currentSkillCount;
	
	NSNumber *totalSkills;
	NSMutableArray *toolTips;
	NSString *filename;
	NSString *title;
	UIImageView *icon;
	NSArray *data;
	UIImageView *skillCounter;
	UILabel *currentCount, *totalCount;
    
    
}

- (id) initWithItem:(int)number For:(NSString*)_filename With:(NSArray *)_data;
- (void) skillCountClicked;
- (void) toggleButtonStatus:(BOOL)status;
- (void) skillCountIncreased;
- (void) skillCountDecreased;
- (void) skillCountChanged:(int)value;

- (void) skillCountChange:(int)value;

- (NSString *) getItemName;
- (int) currentClickCount;
- (int) maxClickCount;
- (BOOL) full;
- (BOOL) empty;
- (int) getItem;

- (NSArray*) getData;
@end
