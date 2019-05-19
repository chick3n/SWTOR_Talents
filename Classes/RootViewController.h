//
//  RootViewController.h
//  SWTOR_Talents
//
//  Created by Vincent Mancini on 12-01-07.
//  Copyright 2012 Vice Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTalentsTableViewController.h"
#import "TalentViewController.h"

@interface RootViewController : UIViewController< UIActionSheetDelegate > {
	int activeClasses;
	int clickedClass;
	
	UIView* republicView;
	UIView *sithView;
	UIButton *savedSpecs;
}

@property (nonatomic, retain) IBOutlet UIView *republicView, *sithView;
@property (nonatomic, retain) IBOutlet UIButton *savedSpecs;

- (IBAction) goRepublic;
- (IBAction) goSith;

- (IBAction) trooper:(id)sender;
- (IBAction) smuggler:(id)sender;
- (IBAction) jediknight:(id)sender;
- (IBAction) jediconsular:(id)sender;

- (IBAction) bountyhunter:(id)sender;
- (IBAction) sithwarrior:(id)sender;
- (IBAction) imperialagent:(id)sender;
- (IBAction) sithinquisitor:(id)sender;

- (IBAction) savedProfilesClicked:(id)sender;

@end
