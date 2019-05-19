//
//  RootViewController.m
//  SWTOR_Talents
//
//  Created by Vincent Mancini on 12-01-07.
//  Copyright 2012 Vice Interactive. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
- (void) resetSavedSpecs:(BOOL)choice;
@end


@implementation RootViewController
@synthesize republicView, sithView, savedSpecs;

- (IBAction) goRepublic
{
	sithView.hidden = YES;
	clickedClass = 0;
	
	if(activeClasses == 1)
	{
		activeClasses = 0;
		republicView.hidden = YES;
		[self resetSavedSpecs:YES];
	}
	else {
		republicView.hidden = NO;
		activeClasses = 1;
		[self resetSavedSpecs:NO];
	}
	
}

- (IBAction) goSith
{
	republicView.hidden = YES;
	clickedClass = 0;
	
	if(activeClasses == 2)
	{
		activeClasses = 0;
		sithView.hidden = YES;
		[self resetSavedSpecs:YES];
	}
	else {
		sithView.hidden = NO;
		activeClasses = 2;
		[self resetSavedSpecs:NO];
	}
}

- (void) resetSavedSpecs:(BOOL)choice
{
	CGRect frame = CGRectMake(63, 274, 191, 37);
	if(choice) frame.origin.y = 274;
	else frame.origin.y = 348;
	
	savedSpecs.frame = frame;
}

- (void) displayClass:(NSString*)name withChoices:(NSString*)one And:(NSString*)two
{
	UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:name delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:one, two, nil];
	popup.actionSheetStyle = UIActionSheetStyleDefault;
	[popup showInView:self.view];
	[popup release];
}

- (IBAction) trooper:(id)sender
{
	clickedClass = 40;
	[self displayClass:@"TROOPER" withChoices:@"VANGUARD" And:@"COMMANDO"];
}

- (IBAction) smuggler:(id)sender
{
	clickedClass = 30;
	[self displayClass:@"SMUGGLER" withChoices:@"GUNSLINGER" And:@"SCOUNDREL"];
}

- (IBAction) jediknight:(id)sender
{
	clickedClass = 10;
	[self displayClass:@"JEDI KNIGHT" withChoices:@"SENTINEL" And:@"GAURDIAN"];
}

- (IBAction) jediconsular:(id)sender
{
	clickedClass = 20;
	[self displayClass:@"JEDI CONSULAR" withChoices:@"SAGE" And:@"SHADOW"];
}

- (IBAction) bountyhunter:(id)sender
{
	clickedClass = 70;
	[self displayClass:@"IMPERIAL AGENT" withChoices:@"OPERATIVE" And:@"SNIPER"];
}

- (IBAction) sithwarrior:(id)sender
{
	clickedClass = 50;
	[self displayClass:@"SITH WARRIOR" withChoices:@"JUGGERNAUT" And:@"MARAUDER"];
}

- (IBAction) imperialagent:(id)sender
{
	
    clickedClass = 80;
	[self displayClass:@"BOUNTY HUNTER" withChoices:@"POWERTECH" And:@"MERCENARY"];
}

- (IBAction) sithinquisitor:(id)sender
{
	clickedClass = 60;
	[self displayClass:@"SITH INQUISITOR" withChoices:@"SORCERER" And:@"ASSASSIN"];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
		case 1:
			clickedClass += (buttonIndex + 1);
			TalentViewController *t = [[TalentViewController alloc] initWithClass:clickedClass];
			[self.navigationController pushViewController:t animated:YES];
			[t release];
			break;
		default:
			clickedClass = 0;
			break;
	}
	NSLog(@"%d", clickedClass);
}

- (IBAction) savedProfilesClicked:(id)sender
{
    UserTalentsTableViewController *ut = [[UserTalentsTableViewController alloc] init];
    
    [self.navigationController pushViewController:ut animated:YES];
    
    [ut release];
}

#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	
	CGRect frame = republicView.frame;
	frame.origin.x = 0;
	frame.origin.y = 276;
	republicView.frame = frame;
	sithView.frame = frame;
    
    //check if we have saved files and show button
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES);
    NSString *documentsDirectory = [arrayPaths objectAtIndex:0];
    NSString *userData = [documentsDirectory stringByAppendingPathComponent:@"talents.plist"];
    
    NSArray *profiles = [NSArray arrayWithContentsOfFile:userData];
    if(profiles && profiles.count > 0)
        savedSpecs.hidden = NO;
    else savedSpecs.hidden = YES;
	
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[republicView release];
	[sithView release];
	[savedSpecs release];
	
    [super dealloc];
}


@end

