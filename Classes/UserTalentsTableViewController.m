//
//  UserTalentsTableViewController.m
//  SWTOR_Talents
//
//  Created by Vincent Mancini on 12-01-12.
//  Copyright (c) 2012 Vice Interactive. All rights reserved.
//

#import "UserTalentsTableViewController.h"
#import "definitions.h"

#define CELL_BACKGROUND_IMAGEVIEW 100
#define CELL_ICON_IMAGEVIEW 101
#define CELL_FACTION_IMAGEVIEW 102
#define CELL_PROFILETITLE_LABEL 103
#define CELL_CLASSTYPE_LABEL 104
#define CELL_DELETE_IMAGEVIEW 105

@implementation UserTalentsTableViewController
@synthesize data, editButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editClicked:)];
    self.navigationItem.rightBarButtonItem = self.editButton;
    [editButton release];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES);
    NSString *documentsDirectory = [arrayPaths objectAtIndex:0];
    NSString *userData = [documentsDirectory stringByAppendingPathComponent:@"talents.plist"];
    
    if([fm fileExistsAtPath:userData])
    {
        self.data = [NSArray arrayWithContentsOfFile:userData];
    }
    
    UIView *tableFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [tableFooter setBackgroundColor:[UIColor clearColor]];
    
    [self.tableView setTableFooterView:tableFooter];
    [self.tableView setTableHeaderView:tableFooter];
    [tableFooter release];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:1/255 green:22/255 blue:38/255 alpha:1.0]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UserTalentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UIImageView *base = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
        [base setImage:[UIImage imageNamed:@"profile_cell.png"]];
        [base setHighlightedImage:[UIImage imageNamed:@"profile_cell_clicked.png"]];
        [base setTag:CELL_BACKGROUND_IMAGEVIEW];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 46, 47)];
        [icon setTag:CELL_ICON_IMAGEVIEW];
        
        UIImageView *faction = [[UIImageView alloc] initWithFrame:CGRectMake(256, 6, 56, 54)];
        [faction setTag:CELL_FACTION_IMAGEVIEW];
        
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
        [delete setFrame:CGRectMake(272, 20, 30, 25)];
        [delete setTag:CELL_DELETE_IMAGEVIEW];
        [delete setHidden:YES];
        [delete setImage:[UIImage imageNamed:@"profile_delete.jpg"] forState:UIControlStateNormal];  
        [delete addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue" size:18];
        UIFont *descFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        UIColor *textColor = [UIColor colorWithRed:116/255.f green:191/255.f blue:212/255.f alpha:1.0];
        UIColor *highlightedColor = [UIColor colorWithRed:235/255.f green:193/255.f blue:77/255.f alpha:1.0];
        
        UILabel *profileName = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 190, 20)];
        [profileName setFont:titleFont];
        [profileName setBackgroundColor:[UIColor clearColor]];
        [profileName setTextColor:textColor];
        [profileName setHighlightedTextColor:highlightedColor];
        [profileName setTextAlignment:UITextAlignmentLeft];
        [profileName setNumberOfLines:1];
        [profileName setLineBreakMode:UILineBreakModeTailTruncation];
        [profileName setTag:CELL_PROFILETITLE_LABEL];
        
        UILabel *className = [[UILabel alloc] initWithFrame:CGRectMake(65, 25, 190, 20)];
        [className setFont:descFont];
        [className setBackgroundColor:[UIColor clearColor]];
        [className setTextColor:textColor];
        [className setHighlightedTextColor:highlightedColor];
        [className setTextAlignment:UITextAlignmentLeft];
        [className setNumberOfLines:1];
        [className setLineBreakMode:UILineBreakModeTailTruncation];
        [className setTag:CELL_CLASSTYPE_LABEL];
        
        
        [cell.contentView addSubview:base];
        [cell.contentView addSubview:icon];
        [cell.contentView addSubview:faction];
        [cell.contentView addSubview:profileName];
        [cell.contentView addSubview:className];
        [cell.contentView addSubview:delete];
        
       
        [base release];
        [icon release];
        [faction release];
        [profileName release];
        [className release];
    }
    
    NSDictionary *item = [data objectAtIndex:indexPath.row];
    
    if(editing)
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    else
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    UIImageView *icon = (UIImageView *)[cell viewWithTag:CELL_ICON_IMAGEVIEW];
    [icon setImage:[UIImage imageNamed:[self convertTypeToIcon:(int)[(NSNumber*)[item valueForKey:@"type"] intValue]]]];
    
    UIImageView *faction = (UIImageView *)[cell viewWithTag:CELL_FACTION_IMAGEVIEW];
    [faction setImage:[UIImage imageNamed:[self convertTypeToFaction:(int)[(NSNumber*)[item valueForKey:@"type"] intValue]]]];   
    faction.hidden = (editing) ? YES : NO;
    
    UIButton *delete = (UIButton *)[cell viewWithTag:CELL_DELETE_IMAGEVIEW];
    delete.hidden = (editing) ? NO : YES;
    
    UILabel *profileName = (UILabel *)[cell viewWithTag:CELL_PROFILETITLE_LABEL];
    [profileName setText:(NSString *)[item valueForKey:@"title"]];
    
    UILabel *className = (UILabel *)[cell viewWithTag:CELL_CLASSTYPE_LABEL];
    [className setText:[self convertTypeToString:(int)[(NSNumber*)[item valueForKey:@"type"] intValue]]];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	//return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleNone;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
       
        [data removeObjectAtIndex:indexPath.row];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES);
        NSString *documentsDirectory = [arrayPaths objectAtIndex:0];
        NSString *userData = [documentsDirectory stringByAppendingPathComponent:@"talents.plist"];
        
        if([fm fileExistsAtPath:userData])
        {
            [data writeToFile:userData atomically:YES];
        }   

        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIImageView *faction = (UIImageView *)[cell viewWithTag:CELL_FACTION_IMAGEVIEW];
    faction.hidden = NO;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIImageView *faction = (UIImageView *)[cell viewWithTag:CELL_FACTION_IMAGEVIEW];
    faction.hidden = YES;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editing)
        return;
    
    NSDictionary* item = [data objectAtIndex:indexPath.row];
    NSNumber *type = [item valueForKey:@"type"];
    NSString *title = [item valueForKey:@"title"];
    NSDictionary *specs = [item valueForKey:@"talents"];
    
    TalentViewController *tv = [[TalentViewController alloc]
                                initWithSaved:specs Class:[type intValue] SavedIndex:indexPath.row SavedName:title];
    [self.navigationController pushViewController:tv animated:YES];
    [tv release];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (NSString *) convertTypeToIcon:(int)type
{
	switch (type) {
		case GAURDIAN:
		case SENTINEL:
			return @"jedi_gaurdian_profile.jpg";
		case SAGE:
		case SHADOW:
			return @"jedi_consular_profile.jpg";
		case GUNSLINGER:
		case SCOUNDREL:
			return @"smuggler_profile.jpg";
		case VANGUARD:
		case COMMANDO:
			return @"commando_profile.jpg";
		case JUGGERNAUT:
		case MARAUDER:
			return @"sith_warrior_profile.jpg";
		case SORCERER:
		case ASSASSIN:
			return @"sith_sorcerer_profile.jpg";
		case OPERATIVE:
		case SNIPER:
			return @"imperial_agent_profile.jpg";
		case POWERTECH:
		case MERCENARY:
			return @"bounty_hunter_profile.jpg";
	}
	
	return @"";
}

- (NSString *) convertTypeToString:(int)type
{
	switch (type) {
		case SENTINEL:
			return @"Jedi Sentinel";
		case GAURDIAN:
			return @"Jedi Gaurdian";
		case SAGE:
			return @"Jedi Sage";
		case SHADOW:
			return @"Jedi Shadow";
		case GUNSLINGER:
			return @"Gunslinger";
		case SCOUNDREL:
			return @"Scoundrel";
		case VANGUARD:
			return @"Vanguard";
		case COMMANDO:
			return @"Commando";
		case JUGGERNAUT:
			return @"Sith Juggernaut";
		case MARAUDER:
			return @"Sith Marauder";
		case SORCERER:
			return @"Sith Sorcerer";
		case ASSASSIN:
			return @"Sith Assassin";
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

- (NSString *) convertTypeToFaction:(int)type
{
	switch (type) {
		case SENTINEL:
		case GAURDIAN:
		case SAGE:
		case SHADOW:
		case GUNSLINGER:
		case SCOUNDREL:
		case VANGUARD:
		case COMMANDO:
			return @"faction_republic.png";
		case JUGGERNAUT:
		case MARAUDER:
		case SORCERER:
		case ASSASSIN:
		case OPERATIVE:
		case SNIPER:
		case POWERTECH:
		case MERCENARY:
            return @"faction_sith.png";
	}
	
	return @"faction_republic.png";
}

- (IBAction) editClicked:(id)sender
{
    if(editing == NO)
    {
        editing = YES;
        [editButton setStyle:UIBarButtonItemStyleDone];
        [editButton setTitle:@"Done"];
        
        [self.tableView reloadData];
    }
    else
    {
        editing = NO;
        [editButton setStyle:UIBarButtonItemStylePlain];
        [editButton setTitle:@"Edit"];
        
        [self.tableView reloadData];
    }
}

- (IBAction) deleteClicked:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    // Delete the row from the data source
    
    [data removeObjectAtIndex:indexPath.row];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES);
    NSString *documentsDirectory = [arrayPaths objectAtIndex:0];
    NSString *userData = [documentsDirectory stringByAppendingPathComponent:@"talents.plist"];
    
    if([fm fileExistsAtPath:userData])
    {
        [data writeToFile:userData atomically:YES];
    }   
    
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


@end
