//
//  SaveTalentsViewController.m
//  SWTOR_Talents
//
//  Created by Vincent Mancini on 12-01-12.
//  Copyright (c) 2012 Vice Interactive. All rights reserved.
//

#import "SaveTalentsViewController.h"

@implementation SaveTalentsViewController
@synthesize data, specTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     [specTitle becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void) dealloc
{
    [specTitle release];
    
    [super dealloc];
}

- (IBAction)doneClicked:(id)sender
{
    if(specTitle.text.length <= 0)
        return;
    
    [data setValue:specTitle.text forKey:@"title"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES);
    NSString *documentsDirectory = [arrayPaths objectAtIndex:0];
    NSString *userData = [documentsDirectory stringByAppendingPathComponent:@"talents.plist"];
    
    if([fm fileExistsAtPath:userData])
    {
        NSMutableArray *talentsPlist = [NSMutableArray arrayWithContentsOfFile:userData];
        [talentsPlist addObject:data];
        //[fm removeItemAtPath:userData error:nil];
        [talentsPlist writeToFile:userData atomically:YES];
    }   
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
