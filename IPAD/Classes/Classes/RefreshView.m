//
//  RefreshView.m
//  Testself
//
//  Created by Jason Liu on 12-1-10.
//  Copyright 2012年 Yulong. All rights reserved.
//

#import "RefreshView.h"

@implementation RefreshView
@synthesize refreshIndicator;
@synthesize refreshStatusLabel;
@synthesize refreshLastUpdatedTimeLabel;
@synthesize refreshArrowImageView;
@synthesize isLoading;
@synthesize isDragging;
@synthesize owner;
@synthesize delegate;
@synthesize cellCount;

//视图初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//对象释放
- (void)dealloc {
    [refreshArrowImageView release];
    [refreshIndicator release];
    [refreshStatusLabel release];
    [refreshLastUpdatedTimeLabel release];
    
    [owner release];
    [super dealloc];
}

//初始化refreshView
- (void)setupWithOwner:(UIScrollView *)owner_  delegate:(id)delegate_ {
    self.owner = owner_;
    self.delegate = delegate_;
	self.frame = CGRectMake(0, 768, 800, 60);
    [[self.delegate view]addSubview:self];//[[self.delegate animationView]addSubview:self];

    [refreshIndicator stopAnimating];
}
// refreshView 结束加载动画
- (void)stopLoading {
    // control
    isLoading = NO;
    
    // Animation
    [UIView beginAnimations:@"remove" context:NULL];
    [UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	//    owner.contentInset = UIEdgeInsetsZero;
	
    //owner.contentOffset = CGPointZero;
    self.refreshArrowImageView.transform = CGAffineTransformMakeRotation(0);
    [UIView commitAnimations];
    
  
    refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;
    refreshArrowImageView.hidden = NO;
    [refreshIndicator stopAnimating];
}

//拖动动画效果
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"remove"]) 
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		
		self.frame =CGRectMake(10, 768, 800, REFRESH_HEADER_HEIGHT);
		
		[UIView commitAnimations];
		
	}
}
// refreshView 开始加载动画
- (void)startLoading {
    // control
    isLoading = YES;
    
    // Animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    owner.contentOffset = CGPointMake(0, owner.contentSize.height+40);
    //owner.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshStatusLabel.text = REFRESH_LOADING_STATUS;
    refreshArrowImageView.hidden = YES;
    [refreshIndicator startAnimating];
    [UIView commitAnimations];
}
// refreshView 刚开始拖动时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}
// refreshView 拖动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	NSLog(@"%d",[owner numberOfRowsInSection:0]);
	if ([owner numberOfRowsInSection:0]<self.cellCount) {
		if (isLoading) {
			//  // Update the content inset, good for section headers
			//        if (scrollView.contentOffset.y > 0)
			//            scrollView.contentInset = UIEdgeInsetsZero;
			//        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
			//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
		} 
		else if (isDragging && scrollView.contentOffset.y +460 >= scrollView.contentSize.height) 
		{
			// Update the arrow direction and label
			

			
			[UIView beginAnimations:nil context:NULL];
			
			self.frame =CGRectMake(10, 480, 800, REFRESH_HEADER_HEIGHT);
			
			
			
			if (scrollView.contentOffset.y + 460 - scrollView.contentSize.height> 20) {
				// User is scrolling above the header
				refreshStatusLabel.text = REFRESH_RELEASED_STATUS;
				refreshArrowImageView.transform = CGAffineTransformMakeRotation(3.14);
			} 
			else { // User is scrolling somewhere within the header
				refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;
				refreshArrowImageView.transform = CGAffineTransformMakeRotation(0);
			}
			[UIView commitAnimations];
		}
		
	}
}
// refreshView 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
	
	NSLog(@"%f,%f",scrollView.contentOffset.y,scrollView.contentSize.height);
	
    if (scrollView.contentOffset.y +460>= scrollView.contentSize.height) {
        if ([delegate respondsToSelector:@selector(refreshViewDidCallBack)]) {
            [delegate refreshViewDidCallBack];
        }
    }
}
@end
