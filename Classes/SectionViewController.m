//
//  SectionViewController.m
//  SWTOR_Talents
//
//  Created by Vincent Mancini on 12-01-07.
//  Copyright 2012 Vice Interactive. All rights reserved.
//

#import "SectionViewController.h"
#import <QuartzCore/QuartzCore.h>

#define col 4
#define row 7
#define widthApart 10
#define heightApart 16
#define topApart 12
#define sideApart 18

@interface SectionViewController()
- (IBAction) itemClicked:(id)sender;
@end

@implementation SectionViewController
@synthesize specTitle, dimmer, specBackground, scrollView, upClick, downClick, specCurrentTalentsCount, stopper;


- (id) initWithSection:(int)page Of:(int)_type For:(NSArray*)_data Titled:(NSString *)_specName With:(NSArray*)_rules
{
	if(self = [super initWithNibName:@"SectionViewController" bundle:nil])
	{
		section = page;
		type = _type;
		data = _data;
		specName = _specName;
		structure = [[NSMutableArray alloc] init];
        currentTalentsCount = 0;
        rules = _rules;
        row1 = 0;
        row2 = 0;
        row3 = 0;
        row4 = 0;
        row5 = 0;
        row6 = 0;
        row7 = 0;
        
        tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        tapGestureRecognizer.delegate = self;
        
        tooltip = [[TalentDescriptionView alloc] init];
		
	}
	
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 490);
    
	[specTitle setText:specName];
    [specTitle.layer setShadowColor:[[UIColor colorWithRed:88/255.f green:173/255.f blue:199/255.f alpha:1.0] CGColor]];
    [specTitle.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [specTitle.layer setShadowRadius:0.8];
    [specTitle.layer setShadowOpacity:1.0];
    [specTitle.layer setMasksToBounds:NO];
    
    
    [specCurrentTalentsCount.layer setShadowColor:[[UIColor colorWithRed:9/255.f green:114/255.f blue:184/255.f alpha:1.0] CGColor]];
    [specCurrentTalentsCount.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [specCurrentTalentsCount.layer setShadowRadius:0.8];
    [specCurrentTalentsCount.layer setShadowOpacity:1.0];
    [specCurrentTalentsCount.layer setMasksToBounds:NO];
    
    int rowCount = 0;
    int itemCount = 0;
    for(int i=(row*col)-1; i>=0; i--)
    {
        NSArray *itemData = [data objectAtIndex:i];

        if(itemCount >= 4)
        {
            itemCount = 0;
            rowCount += 1;
        }
        
        if(itemData.count <= 0)
        {
            [structure addObject:[NSNull null]];
            itemCount += 1;
            continue;
        }
        
        ItemView *item = [[ItemView alloc] initWithItem:(row*col-1) - i For:[itemData objectAtIndex:2] With:itemData];
        
        CGRect frame = item.frame;
        frame.origin.x = (itemCount * ItemViewWidth) + (widthApart * itemCount) + sideApart;
        frame.origin.y = (rowCount * ItemViewHeight) + (heightApart * rowCount) + topApart;
        item.frame = frame;
        
        //set up connectors for the rules
        NSNumber *rule = (NSNumber*)[rules objectAtIndex:(row*col-1) - i];
        if([rule intValue] > -1)
        {
            int currentSpot = (row*col-1) - i;
            int connectSpot = [rule intValue];
            
            UIImageView *connector;
            CGRect c_frame = item.frame;
            
            if(currentSpot + 1 == connectSpot) //right to left
            {
                connector = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"talent_connect_hori_right.png"]];
                c_frame.origin.x = item.frame.origin.x + item.frame.size.width;
                c_frame.origin.y = (item.frame.origin.y + item.frame.size.height / 2) - (connector.frame.size.height / 2) - 8;
            }
            else if(currentSpot - 1 == connectSpot) //left to right
            {
                connector = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"talent_connect_hori_left.png"]];
                c_frame.origin.x = item.frame.origin.x - connector.frame.size.width;
                c_frame.origin.y = (item.frame.origin.y + item.frame.size.height / 2) - (connector.frame.size.height / 2) - 8;
                
            }
            else if(currentSpot + 8 == connectSpot) //top to bottom x2
            {
                connector = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"talent_connect_vert_x2.png"]];
                
                c_frame.origin.x = (item.frame.origin.x + item.frame.size.width / 2) - (connector.frame.size.width / 2);
                c_frame.origin.y = (item.frame.origin.y + item.frame.size.height) - 9;
            }
            else //top to bottom
            {
                connector = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"talent_connect_vert.png"]];
                
                c_frame.origin.x = (item.frame.origin.x + item.frame.size.width / 2) - (connector.frame.size.width / 2);
                c_frame.origin.y = item.frame.origin.y + item.frame.size.height - (connector.frame.size.height + 2);
            }
                   
            connector.frame = CGRectMake(c_frame.origin.x, c_frame.origin.y, connector.frame.size.width, connector.frame.size.height);
            [scrollView addSubview:connector];
            
            [connector release];
        }

        [scrollView addSubview:item];
        [structure addObject:item];
        
        [item release];
        
        itemCount += 1;
    }
    
    
    
    
    [self.view bringSubviewToFront:dimmer];
    [self.view bringSubviewToFront:stopper];
    [self.view bringSubviewToFront:upClick];
    [self.view bringSubviewToFront:downClick];
    
    //scroll tto bottom
    CGPoint bottomOffset = CGPointMake(0, [self.scrollView contentSize].height - self.scrollView.frame.size.height);
    [scrollView setContentOffset: bottomOffset animated: YES];
    
    [self dimChoices];
    
    [[upClick layer] setCornerRadius:6.0f];
    [[upClick layer] setBorderColor:[[UIColor colorWithRed:48/255.f green:96/255.f blue:133/255.f alpha:0.8] CGColor]];
    [[upClick layer] setBorderWidth:2.0f];
	
    [[downClick layer] setCornerRadius:6.0f];
    [[downClick layer] setBorderColor:[[UIColor colorWithRed:48/255.f green:96/255.f blue:133/255.f alpha:0.8] CGColor]];
    [[downClick layer] setBorderWidth:2.0f];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [swipeUpGestureRecognizer release];
    [swipeDownGestureRecognizer release];
    [tapGestureRecognizer release];
	[structure release];
	[specTitle release];
	//[specButton release];
    [scrollView release];
    [specBackground release];
    [tooltip release];
    [upClick release];
    [downClick release];
    [specCurrentTalentsCount release];
    [stopper release];
    
    if(clickedViewClone) [clickedViewClone release];
    
    [super dealloc];
}

- (void) resetTree
{
    *maxTalentRef += currentTalentsCount;
    [self clearTalents:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TALENTCHANGENOTIFICATION object:self userInfo:nil];
    
    [self gestureRecognizer:nil shouldReceiveTouch:[[[UITouch alloc] init] autorelease]];
}

- (IBAction) clearTalents:(id)sender
{
    row1 = 0;
    row2 = 0;
    row3 = 0;
    row4 = 0;
    row5 = 0;
    row6 = 0;
    row7 = 0;
    specCurrentTalentsCount.text = @"0";
    currentTalentsCount = 0;
    
    
    for(int i=0; i<structure.count; i++)
    {
        if([structure objectAtIndex:i] == [NSNull null])
            continue;
        
        ItemView *item = [structure objectAtIndex:i];
        [item skillCountChange:0];
    }
    
    [self gestureRecognizer:nil shouldReceiveTouch:[[[UITouch alloc] init] autorelease]];
}

- (IBAction) itemClicked:(id)sender
{
	ItemView *item = (ItemView*)sender;
	[item skillCountClicked];
}

#pragma -
#pragma Gesture Controls

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    /*if([touch.view isKindOfClass:[UIButton class]]
       || [touch.view isKindOfClass:[UITextView class]])
        return NO;
    */
    if([touch.view isEqual:upClick] || [touch.view isEqual:downClick] || [touch.view isEqual:stopper])
        return NO;
    
    if(clickedView != nil && clickedViewClone != nil)
    {
        upClick.hidden = YES;
        downClick.hidden = YES;
        dimmer.hidden = YES;
        stopper.hidden = YES;
        //clickedView.frame = clickedViewOriginalFrame;
        //[scrollView insertSubview:clickedView aboveSubview:scrollView];
        [clickedViewClone removeFromSuperview];
        [clickedViewClone release];
        [tooltip removeFromSuperview];
        [tooltip clearDetails];
        clickedViewClone = nil;
        clickedView = nil;
        return NO;
    }
    
    if([touch.view isKindOfClass:[ItemView class]])
    {
        clickedView = (ItemView*)touch.view;
        clickedViewClone = [clickedView copy];
        return YES;
    }
    
    clickedView = nil;
    if(clickedViewClone)
    {
        [clickedViewClone removeFromSuperview];
        [clickedViewClone release];
    }
    clickedViewClone = nil;
    return NO;
}

- (IBAction)handleTapFrom:(id)sender
{
    CGRect frame = CGRectMake(18, 10, clickedView.frame.size.width, clickedView.frame.size.height);  
    clickedViewOriginalFrame = clickedView.frame;
        
    CGRect upFrame = upClick.frame;
    CGRect downFrame = downClick.frame;
    
    upFrame.origin.y = frame.origin.y;
    downFrame.origin.y = upFrame.origin.y + upFrame.size.height + 5;
    
    upFrame.origin.x = frame.origin.x + frame.size.width + 4;
    downFrame.origin.x = upFrame.origin.x;
    
    upClick.frame = upFrame;
    downClick.frame = downFrame;
    
    stopper.frame = CGRectMake(upFrame.origin.x - 10, upFrame.origin.y - 10, stopper.frame.size.width, stopper.frame.size.height);
    
    if([self verifyLegalLook] && [self verifyRuleLegal])
    {
        upClick.hidden = NO;
        downClick.hidden = NO;
        stopper.hidden = NO;
        
        [tooltip setFrame:CGRectMake(frame.origin.x, downClick.frame.origin.y + downClick.frame.size.height + 10, tooltip.frame.size.width, tooltip.frame.size.height)];
    }
    else
    {
        [tooltip setFrame:CGRectMake(frame.origin.x, downClick.frame.origin.y + downClick.frame.size.height + 10, tooltip.frame.size.width, tooltip.frame.size.height)];
    }
    
    clickedViewClone.frame = frame;
    [self.view insertSubview:clickedViewClone aboveSubview:dimmer];
    
    dimmer.hidden = NO;
    
    [tooltip clearDetails];
    [tooltip setDetails:[[clickedView getData] objectAtIndex:3] For:[clickedView currentClickCount] Of:[clickedView getItemName]];
    [self.view insertSubview:tooltip aboveSubview:dimmer];
    
    //[self.view insertSubview:clickedView aboveSubview:dimmer];
    
    NSLog(@"TAP [%@]", [clickedView getItemName]);
}

- (void)incremeantSkillCount:(int)value
{
    if(value > 0 && [clickedView full])
        return;
    else if(value < 0 && [clickedView empty])
        return;
    else if(![self verifyLegalClick:value])
        return;
    else if(*maxTalentRef - value < 0)
        return;
    
    *maxTalentRef -= value;
    currentTalentsCount += value;
    specCurrentTalentsCount.text = [NSString stringWithFormat:@"%d", currentTalentsCount];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TALENTCHANGENOTIFICATION object:self userInfo:nil];
    
    [self fillInRow:value];
    
    [clickedView skillCountChanged:value];
    [clickedViewClone skillCountChanged:value];
    [tooltip clearDetails];
    [tooltip setDetails:[[clickedView getData] objectAtIndex:3]
                    For:[clickedView currentClickCount]
                     Of:[clickedView getItemName]];
    
    [self dimChoices];
}

- (IBAction)upClickClicked:(id)sender
{
    //legal
    [self incremeantSkillCount:+1];
}

- (IBAction)downClickClicked:(id)sender
{
    //legal
    [self incremeantSkillCount:-1];
}


- (void)setMaxTalentRef:(int *)ref
{
    maxTalentRef = ref;
}

- (void) fillInRow:(int)value
{
    switch([clickedView getItem])
    {
        case 0: case 1: case 2: case 3:
            row1 += value;
            break;
        case 4: case 5: case 6: case 7:
            row2 += value;
            break;
        case 8: case 9: case 10: case 11:
            row3 += value;
            break;
        case 12: case 13: case 14: case 15:
            row4 += value;
            break;
        case 16: case 17: case 18: case 19:
            row5 += value;
            break;
        case 20: case 21: case 22: case 23:
            row6 += value;
            break;
        case 24: case 25: case 26: case 27:
            row7 += value;
            break;
    }
}

- (BOOL) verifyLegalClick:(int)value
{
    switch([clickedView getItem])
    {
        case 0: case 1: case 2: case 3:
            break;
        case 4: case 5: case 6: case 7:
            if(row2 + value < 5 &&
               (row1 > 0))
                return NO;
            break;
        case 8: case 9: case 10: case 11:
            if(row3 + value < 5 &&
               (row2 > 0 || row1 > 0))
                return NO;
            break;
        case 12: case 13: case 14: case 15:
            if(row4 + value < 5 &&
               (row3 > 0 || row2 > 0 || row1 > 0))
                return NO;
            break;
        case 16: case 17: case 18: case 19:
            if(row5 + value < 5 &&
               (row4 > 0 || row3 > 0 || row2 > 0 || row1 > 0))
                return NO;
            break;
        case 20: case 21: case 22: case 23:
            if(row6 + value < 5 &&
               (row5 > 0 || row4 > 0 || row3 > 0 || row2 > 0 || row1 > 0))
                return NO;
            break;
        case 24: case 25: case 26: case 27:
            if(row7 + value < 5 &&
               (row6 > 0 || row5 > 0 || row4 > 0 || row3 > 0 || row2 > 0 || row1 > 0))
                return NO;
            break;
    }
    
    return YES;
}

- (BOOL) verifyLegalLook
{
    int index = [clickedView getItem];
    
    switch(index)
    {
        case 0: case 1: case 2: case 3:
            if(currentTalentsCount >= 30)
                return YES;
            break;
        case 4: case 5: case 6: case 7:
            if(currentTalentsCount >= 25)
                return YES;
            break;
        case 8: case 9: case 10: case 11:
            if(currentTalentsCount >= 20)
                return YES;
            break;
        case 12: case 13: case 14: case 15:
            if(currentTalentsCount >= 15)
                return YES;
            break;
        case 16: case 17: case 18: case 19:
            if(currentTalentsCount >= 10)
                return YES;
            break;
        case 20: case 21: case 22: case 23:
            if(currentTalentsCount >= 5)
                return YES;
            break;
        case 24: case 25: case 26: case 27:
            if(currentTalentsCount >= 0)
                return YES;
            break;
    }
    
    return NO;
}

- (BOOL) dimChoices
{
    int start = 0;
    int end = 28;
    
    if(currentTalentsCount < 5)
    {
        start = 24;
    }
    else if(currentTalentsCount < 10)
    {
        start = 20;
    }
    else if(currentTalentsCount < 15)
    {
        start = 16;
    }
    else if(currentTalentsCount < 20)
    {
        start = 12;
    }
    else if(currentTalentsCount < 25)
    {
        start = 8;
    }
    else if(currentTalentsCount < 30)
    {
        start = 4;
    }
    else if(currentTalentsCount < 35)
    {
        start = 0;
    }
    
    for(int t = 0; t < start; t++)
    {
        if([structure objectAtIndex:t] == [NSNull null])
            continue;
        ItemView *item = [structure objectAtIndex:t];
        [item setAlpha:0.4];
    }
    
    for(int x = start; x < end; x++)
    {
        if([structure objectAtIndex:x] == [NSNull null])
            continue;
        ItemView *item = [structure objectAtIndex:x];
        
        int reqIndex = [(NSNumber*)[rules objectAtIndex:[item getItem]] intValue];
        
        NSLog(@"%d %d", reqIndex, [item getItem]);
        if(reqIndex > -1)
        {
            ItemView *req = [structure objectAtIndex:reqIndex];
            if([req full])
                [item setAlpha:1.0];
            else [item setAlpha:0.4];
        }
        else
            [item setAlpha:1.0];
    }
    
    
    return YES;
}

- (BOOL) verifyRuleLegal
{
    int index = [clickedView getItem];
    
    NSNumber *match = [rules objectAtIndex:index];
    if([match intValue] > -1)
    {
        if(structure.count > [match intValue])
        {
            if([structure objectAtIndex:[match intValue]] == [NSNull null])
                return NO;
            ItemView *item = [structure objectAtIndex:[match intValue]];
            return [item full];
        }
    }
    
    return YES;
}

- (NSArray *) saveSpec
{
    NSMutableArray *spec = [[NSMutableArray alloc] init];
    
    for(int i = 0; i<structure.count; i++)
    {
        if([structure objectAtIndex:i] == [NSNull null])
        {
            [spec addObject:[NSNumber numberWithInt:0]];
             continue;
        }
        
        ItemView *item = (ItemView*)[structure objectAtIndex:i];
        [spec addObject:[NSNumber numberWithInt:[item currentClickCount]]];
    }
    
    return [spec autorelease];
}

- (NSString *) getTitle
{
    return specName;
}

- (void) loadSavedData:(NSArray*)_data
{
    if(_data.count != structure.count)
        return;
    
    for(int i=structure.count-1; i>=0; i--)
    {
        if([structure objectAtIndex:i] == [NSNull null])
            continue;
        
        NSNumber *itemValue = (NSNumber *)[_data objectAtIndex:i];
        
        ItemView *item = [structure objectAtIndex:i];
        clickedView = item;
        
        [item skillCountChange:[itemValue intValue]];
        [self fillInRow:[itemValue intValue]];
        currentTalentsCount += [itemValue intValue];
    }
    
    specCurrentTalentsCount.text = [NSString stringWithFormat:@"%d", row1 + row2 + row3 + row4 + row5 + row6 + row7];
    *maxTalentRef -= (row1 + row2 + row3 + row4 + row5 + row6 + row7);
    clickedView = nil;
    
    [self dimChoices];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TALENTCHANGENOTIFICATION object:self userInfo:nil];
}

@end
