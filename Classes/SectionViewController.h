//
//  SectionViewController.h
//  SWTOR_Talents
//
//  Created by Vincent Mancini on 12-01-07.
//  Copyright 2012 Vice Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemView.h"
#import "TalentDescriptionView.h"

#define TALENTCHANGENOTIFICATION @"TalentChangeNotification"


@interface SectionViewController : UIViewController <UIGestureRecognizerDelegate> {
	int type;
	int section;
	
	NSString *specName;
	NSArray *data;
	NSMutableArray *structure;
	
	UILabel *specTitle;
    UIImageView *specBackground;
    UILabel *specCurrentTalentsCount;
    
    ItemView *clickedView;
    ItemView *clickedViewClone;
    CGRect clickedViewOriginalFrame;
    TalentDescriptionView *tooltip;
    
    UISwipeGestureRecognizer *swipeUpGestureRecognizer, *swipeDownGestureRecognizer;
    UITapGestureRecognizer *tapGestureRecognizer;
    
    UIButton *upClick, *downClick, *stopper;
    UIView *dimmer;
    
    UIScrollView *scrollView;
    
    int *maxTalentRef;
    int currentTalentsCount;
    
    NSArray *rules;
    
    int row1, row2, row3, row4, row5, row6, row7;
}

@property (nonatomic, retain) IBOutlet UILabel *specTitle, *specCurrentTalentsCount;
@property (nonatomic, retain) IBOutlet UIView *dimmer;
@property (nonatomic, retain) IBOutlet UIImageView *specBackground;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *upClick, *downClick, *stopper;

- (id) initWithSection:(int)page Of:(int)_type For:(NSArray*)_data Titled:(NSString *)_specName With:(NSArray*)_rules;
- (IBAction) clearTalents:(id)sender;
- (IBAction) handleTapFrom:(id)sender;
- (IBAction)upClickClicked:(id)sender;
- (IBAction)downClickClicked:(id)sender;

- (void)setMaxTalentRef:(int*)ref;
- (BOOL) verifyLegalLook;
- (BOOL) dimChoices;
- (BOOL) verifyRuleLegal;
- (BOOL) verifyLegalClick:(int)value;
- (void) fillInRow:(int)value;
- (NSArray *) saveSpec;
- (NSString *) getTitle;
- (void) resetTree;

//saved data
- (void) loadSavedData:(NSArray*)_data;

@end
