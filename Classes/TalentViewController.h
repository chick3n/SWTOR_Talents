//
//  TalentViewController.h
//  SWTOR_Talents
//
//  Created by Vincent Mancini on 12-01-07.
//  Copyright 2012 Vice Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveTalentsViewController.h"
#import "SectionViewController.h"

@interface TalentViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate> {
	UIScrollView *scrollView;
	UIPageControl *pageControl;
    UILabel *remainingTalents;
	
	NSMutableArray *viewControllers;
	
	NSDictionary *plist;
	NSArray *keys;
    NSDictionary *rulePlist;
	
	int type;
	bool pageControlUsed;
    
    int talentCount;
    
    //Saved Variables for IMport    
    NSDictionary *savedData;
    NSString *savedName;
    int savedPosition;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UILabel *remainingTalents;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSDictionary *savedData;
@property (nonatomic, retain) NSString *savedName;

- (id) initWithClass:(int)_type;
- (id) initWithSaved:(NSDictionary*)_specs Class:(int)_type SavedIndex:(int)_index SavedName:(NSString*)_name;
- (IBAction) changePage:(id)sender;
- (IBAction)optionsButtonClicked:(id)sender;
- (void) saveSpec;
- (void) loadSavedProfileData;
- (void) clearTalents;
- (NSString *) convertTypeToSpecialClassString;
- (NSString *) convertTypeToString;
- (void) resetTree;

@end
