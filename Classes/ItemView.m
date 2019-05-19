//
//  ItemView.m
//  SWTOR_Talents
//
//  Created by Vincent Mancini on 12-01-08.
//  Copyright 2012 Vice Interactive. All rights reserved.
//

#import "ItemView.h"
#import <QuartzCore/QuartzCore.h>

@interface ItemView()
- (void) setupIcon;
- (void) updateSkillCount;
@end

@implementation ItemView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (id) initWithItem:(int)number For:(NSString*)_filename With:(NSArray *)_data
{
	CGRect newFrame = CGRectMake(0, 0, 52, 70);
	self = [super initWithFrame:newFrame];
	if(self)
	{
		currentSkillCount = 0;
		item = number;
		filename = _filename;
		data = _data;
	
		[self setupIcon];
	}
	
	return self;	
}

- (void) setupIcon
{
	totalSkills = [data objectAtIndex:1];
	title = [data objectAtIndex:0];
	toolTips = [data objectAtIndex:3];

	icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];
	icon.frame = CGRectMake(0, 0, 52, 52);
    [[icon layer] setBorderWidth:2];
    

    NSLog(@"%@", [[[data objectAtIndex:3] objectAtIndex:0] objectAtIndex:0]);
    if(![(NSString *)[[[data objectAtIndex:3] objectAtIndex:0] objectAtIndex:0] isEqualToString:@""])
        [[icon layer] setBorderColor:[[UIColor greenColor] CGColor]];
    else
        [[icon layer] setBorderColor:[[UIColor colorWithRed:48/255.f green:96/255.f blue:133/255.f alpha:0.8] CGColor]];
    [[icon layer] setCornerRadius:6.f];
	//[icon addTarget:self action:@selector(skillCountClicked) forControlEvents:UIControlEventTouchUpInside];
	//[icon setImage:[UIImage imageNamed:filename]
	//	  forState:UIControlStateNormal];
	
	skillCounter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skillcount.jpg"]];
	//skillCounter = [UIButton buttonWithType:UIButtonTypeCustom];
	//skillCounter.userInteractionEnabled = YES;
	skillCounter.frame = CGRectMake(8, 43, 36, 18);
	//[skillCounter addTarget:self action:@selector(skillCountClicked) forControlEvents:UIControlEventTouchUpInside];
	//[skillCounter setImage:
	// [UIImage imageNamed:@"skillcount.jpg"]
	//			  forState:UIControlStateNormal];
	
	UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14];
	
	currentCount = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, 16, 10)];
	[currentCount setText:[NSString stringWithFormat:@"%d", currentSkillCount]];
	[currentCount setBackgroundColor:[UIColor clearColor]];
	[currentCount setTextColor:[UIColor	whiteColor]];
	[currentCount setFont:font];
	[currentCount setAdjustsFontSizeToFitWidth:NO];
	
	totalCount = [[UILabel alloc] initWithFrame:CGRectMake(23, 4, 16, 10)];
	[totalCount setText:[NSString stringWithFormat:@"%d", [totalSkills intValue]]];
	[totalCount setBackgroundColor:[UIColor clearColor]];
	[totalCount setTextColor:[UIColor blackColor]];
	[totalCount setFont:font];
	[totalCount setAdjustsFontSizeToFitWidth:NO];
	
	[self addSubview:icon];
	[self addSubview:skillCounter];
	[skillCounter addSubview:currentCount];
	[skillCounter addSubview:totalCount];
}

- (NSString *) getItemName
{
    if(title == nil)
        return @"";
    
    return title;
}


- (void)dealloc {
	[icon release];
	[currentCount release];
	[totalCount release];
	[skillCounter release];
	
    [super dealloc];
}

- (void) skillCountClicked
{
	currentSkillCount += 1;
	
	if(currentSkillCount <= (int)[totalSkills intValue])
		[self updateSkillCount];
	else {
		currentSkillCount = 0;
		[self updateSkillCount];
	}
}

- (void) updateSkillCount
{
	[currentCount setText:[NSString stringWithFormat:@"%d", currentSkillCount]];
}

- (void) toggleButtonStatus:(BOOL)status
{
	if(currentSkillCount != 0 && status == NO)
		currentSkillCount = 0;
	
	[currentCount setEnabled:status];
	[totalCount setEnabled:status];
	//[skillCounter setEnabled:status];
	//[icon setEnabled:status];
}

- (void) skillCountIncreased
{
    if(currentSkillCount == [totalSkills intValue])
        return;
    
    currentSkillCount += 1;
    [currentCount setText:[NSString stringWithFormat:@"%d", currentSkillCount]];
}
- (void) skillCountDecreased
{
    if(currentSkillCount <= 0)
        return;
    
    currentSkillCount -= 1;
    [currentCount setText:[NSString stringWithFormat:@"%d", currentSkillCount]];
}

- (void) skillCountChange:(int)value
{
	if(value >= 0 && value <= (int)[totalSkills intValue])
		currentSkillCount = value;
    [self updateSkillCount];
}

- (int) currentClickCount
{
    return currentSkillCount;
}

- (int) maxClickCount
{
    return totalSkills.intValue;
}

-(id) copyWithZone:(NSZone*) zone
{
    ItemView *copy = [[ItemView allocWithZone:zone] initWithItem:item For:filename With:data];
    [copy skillCountChange:currentSkillCount];
    return copy;
}

- (void) skillCountChanged:(int)value;
{
    int newValue = currentSkillCount + value;
    if(newValue >= 0 && newValue <= (int)[totalSkills intValue])
		currentSkillCount = newValue;
    [self updateSkillCount];
}

- (NSArray *) getData
{
    return data;
}

- (BOOL)full
{
    return currentSkillCount >= (int)totalSkills.intValue;
}

- (BOOL) empty
{
    return currentSkillCount == 0;
}

- (int) getItem
{
    return item;
}

@end
