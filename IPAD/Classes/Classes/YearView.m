//
//  YearView.m
//  IPAD
//
//  Created by  careers on 12-3-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "YearView.h"


@implementation YearView
@synthesize yearArray,buttonTitle,yearButton;

- (id)initWithFrame:(CGRect)frame {
    
	//if (frame.size.height<200) {
//        frameHeight = 200;
//    }else{
//        frameHeight = frame.size.height;
//    }
//    tabheight = frameHeight-30;
//    
//    frame.size.height = 30.0f;
	
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		showList = NO;
		yearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		yearButton.frame = CGRectMake(0, 0, 80, 30);
		
		
		
		
		
		[yearButton addTarget:self
					   action:@selector(change)
			 forControlEvents:UIControlEventTouchUpInside];
		buttonTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,50,30)];
		buttonTitle.backgroundColor = [UIColor clearColor];
		buttonTitle.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		//[yearButton addSubview:buttonTitle];
		[self addSubview:yearButton];
		tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, self.frame.size.height)];
		tv.delegate = self;
		tv.dataSource = self;
		tv.backgroundColor = [UIColor grayColor];  
        tv.separatorColor = [UIColor lightGrayColor];
		tv.layer.cornerRadius = 10;
		tv.layer.borderWidth =1 ;
		tv.layer.borderColor = [[UIColor blackColor] CGColor];
		tv.layer.masksToBounds = YES;
		tv.hidden = YES;
		[self addSubview:tv];
	}
    return self;
}

-(void)setYearArray:(NSMutableArray *)array
{
    [yearButton setTitle:[[array objectAtIndex:0] objectForKey:@"aScore"] forState:UIControlStateNormal];
}

-(void)change
{
   if(showList)
   {
	   return;
   }
	else {
		CGRect sf = self.frame;
        sf.size.height = 170;
		
		[self.superview bringSubviewToFront:self];
        tv.hidden = NO;
        showList = YES;
        
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;
        frame.size.height = 35*[yearArray count];
        [UIView beginAnimations:nil context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];  
        self.frame = sf;
        tv.frame = frame;
        [UIView commitAnimations];
	}

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [yearArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//buttonTitle.text = ;
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.textLabel.text = [[yearArray objectAtIndex:indexPath.row] objectForKey:@"aScore"];
	cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	buttonTitle.text = [[yearArray objectAtIndex:[indexPath row]] objectForKey:@"aScore"];
    showList = NO;
    tv.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = 30;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"year" object:buttonTitle.text];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
