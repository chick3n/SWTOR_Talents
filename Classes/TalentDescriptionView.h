//
//  TalentDescriptionView.h
//  SWTOR_Talents
//
//  Created by Lion User on 10/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalentDescriptionView : UIView
{
    UILabel *title;
    UILabel *desc;
    UILabel *cast;
    UILabel *details;

    UILabel *next;
    UILabel *nextdetails;
}

- (void) setDetails:(NSArray*)data For:(int)spot Of:(NSString *)_title;
- (void) clearDetails;

@end
