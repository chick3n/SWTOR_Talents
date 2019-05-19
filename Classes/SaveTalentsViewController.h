//
//  SaveTalentsViewController.h
//  SWTOR_Talents
//
//  Created by Vincent Mancini on 12-01-12.
//  Copyright (c) 2012 Vice Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveTalentsViewController : UIViewController
{
    NSMutableDictionary *data;
    
    UITextField *specTitle;
}

@property (nonatomic,retain) NSMutableDictionary *data;
@property (nonatomic, retain) IBOutlet UITextField *specTitle;

- (IBAction)doneClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;

@end
