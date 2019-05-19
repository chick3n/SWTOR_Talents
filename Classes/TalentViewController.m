//
//  TalentViewController.m
//  SWTOR_Talents
//
//  Created by Vincent Mancini on 12-01-07.
//  Copyright 2012 Vice Interactive. All rights reserved.
//

#import "TalentViewController.h"
#import "definitions.h"

@interface TalentViewController ()
- (void) loadScrollViewWithPage:(int)page;
- (void) scrollViewDidScroll:(UIScrollView *)sender;
- (void) loadProfileDataForClass;
- (NSString *) convertTypeToString;
@end



@implementation TalentViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize viewControllers;
@synthesize savedData;
@synthesize savedName;
@synthesize remainingTalents;

- (id) initWithClass:(int)_type
{
	if(!(self = [super init]))
		return nil;
		
	type = _type;
    talentCount = MAX_TALENTS;
    savedData = nil;
    savedName = nil;
    savedPosition = -1;
    
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
	for(unsigned i = 0; i < 3; i++)
		[controllers addObject:[NSNull null]];
	
	self.viewControllers = controllers;
	[controllers release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTalentChangeNotification:) name: TALENTCHANGENOTIFICATION object:nil];
	
	return self;
}

- (id) initWithSaved:(NSDictionary*)_specs Class:(int)_type SavedIndex:(int)_index SavedName:(NSString*)_name
{
    if(!(self = [super init]))
		return nil;
    
    self.savedData = _specs;
    self.savedName = _name;
    savedPosition = _index;
    
	type = _type;
    talentCount = MAX_TALENTS;
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
	for(unsigned i = 0; i < 3; i++)
		[controllers addObject:[NSNull null]];
	
	self.viewControllers = controllers;
	[controllers release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTalentChangeNotification:) name: TALENTCHANGENOTIFICATION object:nil];
	
	return self;
}

- (void) viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//self.title = [self convertTypeToString];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 44)];
    UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, self.view.frame.size.width/2, 24)];
    headerText.backgroundColor = [UIColor clearColor];
    headerText.font = [UIFont boldSystemFontOfSize:24.f];
    headerText.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    headerText.textAlignment = UITextAlignmentCenter;
    headerText.textColor = [UIColor whiteColor];
    [headerText setText:[self convertTypeToSpecialClassString]];
    [titleView addSubview:headerText];
    [headerText release];
    
    UILabel *subtext = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, self.view.frame.size.width/2, 16)];
    subtext.backgroundColor = [UIColor clearColor];
    subtext.font = [UIFont systemFontOfSize:14.0f];
    subtext.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    subtext.textAlignment = UITextAlignmentCenter;
    subtext.textColor = [UIColor lightGrayColor];
    [subtext setText:[self convertTypeToString]];
    [titleView addSubview:subtext];
    [subtext release];
    
    self.navigationItem.titleView = titleView;
    [titleView release];
	
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    //scrollView.multipleTouchEnabled = YES;
    /*for (UIGestureRecognizer *gestureRecognizer in scrollView.gestureRecognizers) {     
        if ([gestureRecognizer  isKindOfClass:[UIPanGestureRecognizer class]])
        {
            UIPanGestureRecognizer *panGR = (UIPanGestureRecognizer *) gestureRecognizer;
            panGR.minimumNumberOfTouches = 1;          
            panGR.maximumNumberOfTouches = 1;  
        }
    }*/
    
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    
    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                                                                   UIBarButtonSystemItemAction
                                                                                   target:self
                                                                                   action:@selector(optionsButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:optionsButton];
    [optionsButton release];
    
	
	[self loadProfileDataForClass];
	
	[self loadScrollViewWithPage:0];
	[self loadScrollViewWithPage:1];
	[self loadScrollViewWithPage:2];
    
    if(savedPosition > -1 && savedData != nil && savedName != nil)
        [self loadSavedProfileData];
}

- (void) loadSavedProfileData
{
    for (int i =0; i<viewControllers.count; i++) {
        SectionViewController *st = [viewControllers objectAtIndex:i];
        NSString *_specTitle = [st getTitle];
        
        [st loadSavedData:[savedData valueForKey:_specTitle]];
    }
}

#pragma mark -
#pragma mark Talents

- (void) loadProfileDataForClass
{
	NSString *filename;
    NSString *rules;
	
	switch (type) {
		case SENTINEL:
			filename = @"sentinel.plist";
            rules = @"sentinel_rules.plist";
			break;
		case GAURDIAN:
			filename = @"gaurdian.plist";
            rules = @"gaurdian_rules.plist";
			break;
		case SAGE:
			filename = @"sage.plist";
            rules = @"sage_rules.plist";
			break;
		case SHADOW:
			filename = @"shadow.plist";
            rules = @"shadow_rules.plist";
			break;
		case GUNSLINGER:
			filename = @"gunslinger.plist";
            rules = @"gunslinger_rules.plist";
			break;
		case SCOUNDREL:
			filename = @"scoundrel.plist";
            rules = @"scoundrel_rules.plist";
			break;
		case VANGUARD:
			filename = @"vanguard.plist";
            rules = @"vanguard_rules.plist";
			break;
		case COMMANDO:
			filename = @"commando.plist";
            rules = @"commando_rules.plist";
			break;
		case JUGGERNAUT:
			filename = @"juggernaut.plist";
            rules = @"juggernaut_rules.plist";
			break;
		case MARAUDER:
			filename = @"marauder.plist";
            rules = @"marauder_rules.plist";
			break;
		case SORCERER:
			filename = @"sorcerer.plist";
            rules = @"sorcerer_rules.plist";
			break;
		case ASSASSIN:
			filename = @"assassin.plist";
            rules = @"assassin_rules.plist";
			break;
		case OPERATIVE:
			filename = @"operative.plist";
            rules = @"operative_rules.plist";
			break;
		case SNIPER:
			filename = @"sniper.plist";
            rules = @"sniper_rules.plist";
			break;
		case POWERTECH:
			filename = @"powertech.plist";
            rules = @"powertech_rules.plist";
			break;
		case MERCENARY:
			filename = @"mercenary.plist";
            rules = @"mercenary_rules.plist";
			break;
			
		default:
			return;
	}
	
	if(filename == nil)
		return;
	
	NSString *fullPath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
	plist = [[NSDictionary alloc] initWithContentsOfFile:fullPath];
	if(!plist)
		return;
    
    fullPath = [[NSBundle mainBundle] pathForResource:rules ofType:nil];
    rulePlist = [[NSDictionary alloc] initWithContentsOfFile:fullPath];
	
    fullPath = [[NSBundle mainBundle] pathForResource:@"ProfileLoadOrder.plist" ofType:nil];
	NSDictionary *profileOrderDic = [[NSDictionary alloc] initWithContentsOfFile:fullPath];

    keys = [[profileOrderDic objectForKey:filename] retain];
    
    [profileOrderDic release];
}

- (NSString *) convertTypeToSpecialClassString
{
	switch (type) {
		case SENTINEL:
			return @"Sentinel";
		case GAURDIAN:
			return @"Gaurdian";
		case SAGE:
			return @"Sage";
		case SHADOW:
			return @"Shadow";
		case GUNSLINGER:
			return @"Gunslinger";
		case SCOUNDREL:
			return @"Scoundrel";
		case VANGUARD:
			return @"Vanguard";
		case COMMANDO:
			return @"Commando";
		case JUGGERNAUT:
			return @"Juggernaut";
		case MARAUDER:
			return @"Marauder";
		case SORCERER:
			return @"Sorcerer";
		case ASSASSIN:
			return @"Assassin";
		case OPERATIVE:
			return @"Operative";
		case SNIPER:
			return @"Sniper";
		case POWERTECH:
			return @"Powertech";
		case MERCENARY:
			return @"Mercenary";
	}
	
	return @"";
}

- (NSString *) convertTypeToString
{
	switch (type) {
		case SENTINEL:
			return @"Jedi Knight";
		case GAURDIAN:
			return @"Jedi Knight";
		case SAGE:
			return @"Jedi Consular";
		case SHADOW:
			return @"Jedi Consular";
		case GUNSLINGER:
			return @"Smuggler";
		case SCOUNDREL:
			return @"Smuggler";
		case VANGUARD:
			return @"Trooper";
		case COMMANDO:
			return @"Trooper";
		case JUGGERNAUT:
			return @"Sith Warrior";
		case MARAUDER:
			return @"Sith Warrior";
		case SORCERER:
			return @"Sith Inquisitor";
		case ASSASSIN:
			return @"Sith Inquisitor";
		case OPERATIVE:
			return @"Imperial Agent";
		case SNIPER:
			return @"Imperial Agent";
		case POWERTECH:
			return @"Bounty Hunter";
		case MERCENARY:
			return @"Bounty Hunter";
	}
	
	return @"";
}

#pragma mark -
#pragma mark ScrollView delegate

- (void) scrollViewDidScroll:(UIScrollView *)sender
{
	if(pageControlUsed)
		return;
    
    if(scrollView.contentOffset.y >= 136)
        scrollView.pagingEnabled = NO;
    else scrollView.pagingEnabled = YES;
	
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	pageControl.currentPage = page;
    
    NSLog(@"%d", (int)scrollView.contentOffset.y);
	
	[self loadScrollViewWithPage:page - 1];
	[self loadScrollViewWithPage:page];
	[self loadScrollViewWithPage:page + 1];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)sender
{
	pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
	pageControlUsed = NO;
}


#pragma mark -
#pragma mark Pages

- (void) loadScrollViewWithPage:(int)page
{
	if(page < 0)
		return;
	
	if(page >= 3)
		return;
	
	SectionViewController *controller = [viewControllers objectAtIndex:page];
	if((NSNull*)controller == [NSNull null])
	{
		NSString *specName = [keys objectAtIndex:page];
		NSArray *specData = [plist objectForKey:specName];
		        
		controller = [[SectionViewController alloc] initWithSection:page Of:type For:specData Titled:specName With:(NSArray*)[rulePlist objectForKey:specName]];
        [controller setMaxTalentRef:&talentCount];
		[viewControllers replaceObjectAtIndex:page withObject:controller];
		[controller release];
	}
	
	if(controller.view.superview == nil)
	{
		CGRect frame = scrollView.frame;
		frame.origin.x = frame.size.width * page;
		frame.origin.y = 0;
        frame.size.height = 516;
		controller.view.frame = frame;
		[scrollView addSubview:controller.view];
	}
}

- (IBAction) changePage:(id)sender
{
	int page = pageControl.currentPage;
	
	CGRect frame = scrollView.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	[scrollView scrollRectToVisible:frame animated:YES];
	
	pageControlUsed = YES;
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
	if(plist) [plist release];
    if(rulePlist) [rulePlist release];
    if(savedData) [savedData release];
    if(savedName) [savedName release];
    
    [viewControllers release];
	[scrollView release];
	[pageControl release];
    [remainingTalents release];
    [keys release];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [super dealloc];
}

- (IBAction)optionsButtonClicked:(id)sender
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Talents Remaining: %d", talentCount] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Clear Tree", @"Clear Talents", @"Save", nil];
	popup.actionSheetStyle = UIActionSheetStyleDefault;
	[popup showInView:self.view];
	[popup release];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
        case 0: //Reset Tree
            [self resetTree];
            break;
        case 1: //clear all talents
            [self clearTalents];
            break;
		case 2://Save
            [self saveSpec];
            break;
//		case 3://Share
//			break;
		default:			
			break;
	}
}

- (void) resetTree
{
    int page = [pageControl currentPage];
    SectionViewController *svc = (SectionViewController*)[viewControllers objectAtIndex:page];
    [svc resetTree];
}

- (void) saveSpec
{
    NSMutableDictionary *spec = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *specs = [[NSMutableDictionary alloc] init];
    
    for(int i=0; i<viewControllers.count; i++)
    {
        SectionViewController* svc = [viewControllers objectAtIndex:i];
        if(!svc)
            continue;
        
        NSArray *specSection = [svc saveSpec];
        [specs setValue:specSection forKey:[svc getTitle]];
        //[specSection release];
       
    }  
           
    [spec setValue:[NSNumber numberWithInt:type] forKey:@"type"];
    [spec setValue:specs forKey:@"talents"];
    [specs release];
    
    SaveTalentsViewController *stvc = [[SaveTalentsViewController alloc] initWithNibName:@"SaveTalentsViewController" bundle:nil];
    stvc.data = spec;
    [self presentModalViewController:stvc animated:YES];
    [stvc release];
    [spec autorelease];
    //[spec release];
}

- (void) clearTalents
{
    talentCount = MAX_TALENTS;
    [remainingTalents setText:[NSString stringWithFormat:@"%d", talentCount]];
    for(int i=0; i<viewControllers.count; i++)
    {
        SectionViewController* svc = [viewControllers objectAtIndex:i];
        if(!svc)
            continue;
        
        [svc clearTalents:nil];
        
    } 
}

- (void) receiveTalentChangeNotification:(NSNotification *) notification
{
    if([[notification name] isEqualToString:TALENTCHANGENOTIFICATION])
        [remainingTalents setText:[NSString stringWithFormat:@"%d", talentCount]];
}


@end
