//
//  TalentDescriptionView.m
//  SWTOR_Talents
//
//  Created by Lion User on 10/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TalentDescriptionView.h"
#import <QuartzCore/QuartzCore.h>

@interface TalentDescriptionView()
- (void) setupView;
@end

@implementation TalentDescriptionView


- (id) init
{
    if(self = [super initWithFrame:CGRectMake(4, 110, 280, 200)])
    {
        [self setupView];
    }
    
    return self;
}

- (void) dealloc
{
    [title release];
    [cast release];
    [desc release];
    [details release];
    [next release];
    [nextdetails release];
    
    [super release];
}

- (void) setupView
{
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.6;
    
    UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    UIFont *textFont = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    UIFont *nextFont = [UIFont fontWithName:@"HelveticaNeue-Italic" size:12.0];
    UIColor *clearColor = [UIColor clearColor];
    UIColor *titleColor = [UIColor yellowColor];
    UIColor *textColor = [UIColor whiteColor];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, 40)];
    [title setFont:titleFont];
    [title setBackgroundColor:clearColor];
    [title setTextColor:titleColor];
    [title setNumberOfLines:0];
    [self addSubview:title];
    
    cast = [[UILabel alloc] initWithFrame:title.frame];
    [cast setFont:titleFont];
    [cast setBackgroundColor:clearColor];
    [cast setTextColor:titleColor];
    [cast setNumberOfLines:0];
    [self addSubview:cast];
    
    desc = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, 40)];
    [desc setFont:titleFont];
    [desc setBackgroundColor:clearColor];
    [desc setTextColor:textColor];
    [desc setNumberOfLines:0];
    [self addSubview:desc];
    
    details = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, 40)];
    [details setFont:textFont];
    [details setBackgroundColor:clearColor];
    [details setNumberOfLines:0];
    [details setTextColor:textColor];
    [self addSubview:details];
    
    next = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 30, 40)];
    [next setFont:nextFont];
    [next setBackgroundColor:clearColor];
    [next setTextColor:titleColor];
    [next setText:@"Next"];
    [self addSubview:next];
    
    nextdetails = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 40)];
    [nextdetails setFont:nextFont];
    [nextdetails setBackgroundColor:clearColor];
    [nextdetails setNumberOfLines:0];
    [nextdetails setTextColor:textColor];
    [self addSubview:nextdetails];
    
    [[self layer] setCornerRadius:10.f];
    [[self layer] setBorderColor:[[UIColor colorWithRed:48/255.f green:96/255.f blue:133/255.f alpha:0.8] CGColor]];
    [[self layer] setBorderWidth:2.0f];
}

- (void) setDetails:(NSArray*)data For:(int)spot Of:(NSString *)_title
{
    int spotOriginal = spot;
    
    //rearrange and grow/shrink here
    if(data == nil || spot < 0)
        return;
    
    //if(spot == 1 && data.count > 1)
    //    spot = 0;
    
    /*if(spot >= data.count)
        spot = data.count - 1;
    */
    if(spot > 0)
        spot -= 1;
    
    NSArray *obj = [data objectAtIndex:spot];
    NSString *c, *d, *dd;
    c = [obj objectAtIndex:0];
    d = [obj objectAtIndex:1];
    dd = [obj objectAtIndex:2];
    CGFloat yAxis = 5.0; 
    CGSize textSize;
    CGRect textFrame;
    CGSize boundingSize;
    
    if(_title != nil && _title.length > 0)
    {
        boundingSize = CGSizeMake(title.frame.size.width, CGFLOAT_MAX);
        textSize = [_title sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]
                      constrainedToSize:boundingSize lineBreakMode:UILineBreakModeWordWrap];
        
        title.hidden = NO;
        textFrame = title.frame;
        textFrame.size.height = textSize.height;
        textFrame.origin.y = yAxis;
        title.frame = textFrame;
        
        [title setText:_title];
        yAxis = title.frame.origin.y + title.frame.size.height;
    }
    
    if(c != nil && c.length > 0)
    {
        boundingSize = CGSizeMake(cast.frame.size.width, CGFLOAT_MAX);
        textSize = [c sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]
                      constrainedToSize:boundingSize lineBreakMode:UILineBreakModeWordWrap];
        
        cast.hidden = NO;
        
        textFrame = cast.frame;
        textFrame.size.height = textSize.height;
        textFrame.origin.y = yAxis;
        cast.frame = textFrame;
        
        [cast setText:c];
        [cast setFrame:CGRectMake(title.frame.origin.x, yAxis, cast.frame.size.width, cast.frame.size.height)];
        yAxis = cast.frame.origin.y + cast.frame.size.height;
    }

    if(d != nil && d.length > 0)
    {
        boundingSize = CGSizeMake(desc.frame.size.width, CGFLOAT_MAX);
        textSize = [d sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]
                      constrainedToSize:boundingSize lineBreakMode:UILineBreakModeWordWrap];
        
        desc.hidden = NO;
        
        textFrame = desc.frame;
        textFrame.size.height = textSize.height;
        textFrame.origin.y = yAxis;
        desc.frame = textFrame;
        
        [desc setText:d];
        yAxis = desc.frame.origin.y + desc.frame.size.height;
    }
    
    if(dd != nil && dd.length > 0)
    {
        //if(spotOriginal > 0 && spotOriginal < data.count)
        //    dd = [NSString stringWithFormat:@"Next > %@", dd];
        
        boundingSize = CGSizeMake(details.frame.size.width, CGFLOAT_MAX);
        textSize = [dd sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]
                  constrainedToSize:boundingSize lineBreakMode:UILineBreakModeWordWrap];
        
        details.hidden = NO;
        
        textFrame = details.frame;
        textFrame.size.height = textSize.height;
        textFrame.origin.y = yAxis;
        details.frame = textFrame;
        
        [details setText:dd];
        
        yAxis = details.frame.origin.y + details.frame.size.height;
    }
    
    if(spotOriginal != 0 && spotOriginal < data.count)
    {
        next.hidden = NO;
        [next setFrame:CGRectMake(next.frame.origin.x, yAxis, next.frame.size.width, 16)];
        
        NSString *ddd = [[data objectAtIndex:spotOriginal] objectAtIndex:2];
        boundingSize = CGSizeMake(nextdetails.frame.size.width, CGFLOAT_MAX);
        textSize = [ddd sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0] constrainedToSize:boundingSize lineBreakMode:UILineBreakModeWordWrap];
        
        nextdetails.hidden = NO;
        
        textFrame = nextdetails.frame;
        textFrame.size.height = textSize.height;
        textFrame.origin.y = yAxis + next.frame.size.height;
        nextdetails.frame = textFrame;
        
        [nextdetails setText:ddd];
        
        yAxis = nextdetails.frame.origin.y + nextdetails.frame.size.height;
    }
    
    CGRect viewFrame = self.frame;
    viewFrame.size.height = yAxis + 10;
    self.frame = viewFrame;

    
}

- (void) clearDetails
{
    title.hidden = YES;
    cast.hidden = YES;
    desc.hidden = YES;
    details.hidden = YES;
    next.hidden = YES;
    nextdetails.hidden = YES;
    
    [title setText:@""];
    [cast setText:@""];
    [desc setText:@""];
    [details setText:@""];
    [nextdetails setText:@""];
}

@end
             
