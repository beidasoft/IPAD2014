    //
//  RenMianController.m
//  IPAD
//
//  Created by  careers on 12-6-2.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RenMianController.h"
#import "Utilities.h"


@implementation RenMianController
@synthesize resultArray;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,1024, 748)];
	bgImage.image = [UIImage imageNamed:@"excel_Bg.png"];
	bgImage.userInteractionEnabled = YES;
	[self.view addSubview:bgImage];
	
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10,-5,90,70)];
    [backButton setImage:[UIImage imageNamed:@"excel_back.png"] 
				forState:UIControlStateNormal];
	[backButton addTarget:self 
				   action:@selector(back)
		 forControlEvents:UIControlEventTouchUpInside];
	[bgImage addSubview:backButton];
	
	
	listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 63,304,705) style:UITableViewStylePlain];
	listTableView.delegate = self;
	listTableView.dataSource = self;
	[bgImage addSubview:listTableView];
	numberOfPages = [[resultArray objectAtIndex:1]count];
	contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(304, 63, 720, 705)];
	contentScrollView.delegate = self;
	contentScrollView.backgroundColor = [UIColor whiteColor];
	contentScrollView.contentOffset = CGPointMake(0,0);
	contentScrollView.contentSize = CGSizeMake(720,705*numberOfPages);
	contentScrollView.pagingEnabled = YES;
	contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	contentScrollView.showsHorizontalScrollIndicator = NO;
	contentScrollView.scrollsToTop = NO;
	
	[self.view addSubview:contentScrollView];
	[backButton release];
	[bgImage release];
	
	prevPageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.frame.size.width, contentScrollView.frame.size.height)];
	currentPageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.frame.size.width, contentScrollView.frame.size.height)];
	nextPageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.frame.size.width, contentScrollView.frame.size.height)];
	
	[self setWithPageNumber:currentPage];
	
	//isClicked = NO;
}

//显示当前选中的人的详细信息
-(void)setWithPageNumber:(NSInteger)pageNumber
{
    CGFloat pageWidth = 720;
    CGFloat pageHeight = contentScrollView.frame.size.height;
    currentPageView.frame = CGRectMake(0,pageHeight*currentPage, pageWidth, pageHeight);
	
    //[currentPageView setImage: [UIImage imageWithContentsOfFile:[Utilities documentsPath:[NSString stringWithFormat:@"template/%@",[[[resultArray objectAtIndex:currentPage]allValues]objectAtIndex:0]]]]];
	[currentPageView setImage: [UIImage imageWithContentsOfFile:[Utilities documentsPath:[NSString stringWithFormat:@"template/%@",[[resultArray objectAtIndex:1]objectAtIndex:currentPage]]]]];
	
    
    if (pageNumber == 0) 
	{
        prevPageView.frame = CGRectZero;
        currentPageView.frame = CGRectMake(0, 0, pageWidth, pageHeight);
        nextPageView.frame = CGRectMake(0,pageHeight, pageWidth, pageHeight);
       // [nextPageView setImage: [UIImage imageWithContentsOfFile:[Utilities documentsPath:[NSString stringWithFormat:@"template/%@",[[[resultArray objectAtIndex:(currentPage+1)]allValues]objectAtIndex:0]]]]];
		[nextPageView setImage: [UIImage imageWithContentsOfFile:[Utilities documentsPath:[NSString stringWithFormat:@"template/%@",[[resultArray objectAtIndex:1]objectAtIndex:(currentPage+1)]]]]];
        
    }else if(currentPage == (numberOfPages - 1))
	{
        nextPageView.frame = CGRectZero;
        prevPageView.frame = CGRectMake(0,((currentPage - 1) * pageHeight), pageWidth, pageHeight);
       // [prevPageView setImage: [UIImage imageWithContentsOfFile:[Utilities documentsPath:[NSString stringWithFormat:@"template/%@",[[[resultArray objectAtIndex:(currentPage-1)]allValues]objectAtIndex:0]]]]];
		[prevPageView setImage: [UIImage imageWithContentsOfFile:[Utilities documentsPath:[NSString stringWithFormat:@"template/%@",[[resultArray objectAtIndex:1]objectAtIndex:(currentPage-1)]]]]];
    }
	else
	{
        prevPageView.frame = CGRectMake(0,((currentPage - 1) * pageHeight), pageWidth, pageHeight);
        nextPageView.frame = CGRectMake(0,((currentPage + 1) * pageHeight), pageWidth, pageHeight);
       // [prevPageView setImage: [UIImage imageWithContentsOfFile:[Utilities documentsPath:[NSString stringWithFormat:@"template/%@",[[[resultArray objectAtIndex:(currentPage-1)]allValues]objectAtIndex:0]]]]];
       // [nextPageView setImage: [UIImage imageWithContentsOfFile:[Utilities documentsPath:[NSString stringWithFormat:@"template/%@",[[[resultArray objectAtIndex:(currentPage+1)]allValues]objectAtIndex:0]]]]];
		[prevPageView setImage: [UIImage imageWithContentsOfFile:[Utilities documentsPath:[NSString stringWithFormat:@"template/%@",[[resultArray objectAtIndex:1]objectAtIndex:(currentPage-1)]]]]];
		[nextPageView setImage: [UIImage imageWithContentsOfFile:[Utilities documentsPath:[NSString stringWithFormat:@"template/%@",[[resultArray objectAtIndex:1]objectAtIndex:(currentPage+1)]]]]];
		
    }
	
    
    [contentScrollView addSubview:currentPageView];
    [contentScrollView addSubview:prevPageView];
    [contentScrollView addSubview:nextPageView];
}

//UIScrollView代理方法，scrollView的点击事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageHeight = contentScrollView.frame.size.height;
    NSInteger page = floor((contentScrollView.contentOffset.y - pageHeight/2) / pageHeight) + 1;
    if ((currentPage == page) || page < 0 || page > numberOfPages) 
	{
		
        return;
    }else
	{
        NSInteger prevPage = currentPage;
		
        currentPage = page;
		
        contentScrollView.userInteractionEnabled = NO;
        
        [self performSelector:@selector(refreshPageViewAfterPaged:) withObject:[NSNumber numberWithInteger:prevPage] afterDelay:0.1];
        checkDouble = NO;
    }
}

//根据prevPageNumner刷新页面
- (void)refreshPageViewAfterPaged:(NSNumber *)prevPageNumber
{
    CGFloat pageWidth = 720;
    CGFloat pageHeight = contentScrollView.frame.size.height;
	
    NSInteger prevPage = [prevPageNumber integerValue];
	
    UIImageView *tempPageView = nil;
	
    if (!checkDouble) 
	{
        if (currentPage - 1 == prevPage) {
            tempPageView = currentPageView;
            currentPageView = nextPageView;
            nextPageView = prevPageView;
            prevPageView = tempPageView;
            
            prevPageView.frame = CGRectMake(0,((currentPage - 1) * pageHeight), pageWidth, pageHeight);
            currentPageView.frame = CGRectMake(0,currentPage * pageHeight, pageWidth, pageHeight);
            
            if (currentPage == (numberOfPages - 1)) 
			{
                nextPageView.frame = CGRectZero;
            }else
			{
                nextPageView.frame = CGRectMake(0,((currentPage + 1) * pageHeight), pageWidth, pageHeight);
                [self setWithPageNumber:currentPage];
            }
            
        }else if(currentPage + 1 == prevPage)
		{
            tempPageView = currentPageView;
            currentPageView = prevPageView;
            prevPageView = nextPageView;
            nextPageView = tempPageView;
            
            currentPageView.frame = CGRectMake(0,currentPage * pageHeight, pageWidth, pageHeight);
            nextPageView.frame = CGRectMake(0,((currentPage + 1) * pageHeight), pageWidth, pageHeight);
            
            if (currentPage == 0) {
                prevPageView.frame = CGRectZero;
            }else{
                prevPageView.frame = CGRectMake(0,((currentPage - 1) * pageHeight), pageWidth, pageHeight);
                
                [self setWithPageNumber:currentPage];
            }
        }
        checkDouble = YES;
    }
    
    contentScrollView.userInteractionEnabled = YES;
    
}

//ios7搜索条适配 add by zyy 2014-02-18
- (int)getPaddingY{
    int paddingy = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        paddingy = 20;
    }
    return paddingy;
}

//返回上一层控制器
-(void)back
{
	[[NSNotificationCenter defaultCenter]postNotificationName:@"setIsDianJi" object:nil];
	UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];		
	[navagation.view addSubview:self.view];
	CGRect endFrame = CGRectMake(1024, 20-[self getPaddingY], 1024, 768);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(remove)];
	self.view.frame = endFrame;
	[UIView commitAnimations];
}

//移除任免表视图
-(void)remove
{
	[self.view removeFromSuperview];
	[self release];
}

//UITableView代理，返回section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
  
    return 1;
}

//UITableView代理，返回section中cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//return [resultArray count];
	return [[resultArray objectAtIndex:0] count];
}

//UITableView代理，返回cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;	
}

//UITableView代理，加载cell视图
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	else
	{
        //modify by zyy 2014-01-24 修改列表加载以适配ios7
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            // 7.0 系统的适配处理。
            for (UIView *psubView in [cell subviews])
            {
                for(UILabel *ul in [psubView subviews])
                {
                    if ([ul isKindOfClass:[UILabel class]])
                    {
                        [ul removeFromSuperview];
                    }
                }
            }
        }
        else{
            //6.0及以前版本的处理
            for(UILabel *ul in [cell subviews])
            {
                if ([ul isKindOfClass:[UILabel class]])
                {
                    [ul removeFromSuperview];
                }
            }
        }
	}
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	NSArray *cellContentArray = [[[resultArray objectAtIndex:0] objectAtIndex:indexPath.row] componentsSeparatedByString:@" "];
	CGSize labelSize = [[cellContentArray objectAtIndex:1]//text
						sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]
						constrainedToSize:CGSizeMake(300, 40) 
						lineBreakMode:UILineBreakModeCharacterWrap]; 
	
	UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, labelSize.width, 40)];
	nameLabel.font = [UIFont boldSystemFontOfSize:20];
	nameLabel.backgroundColor = [UIColor clearColor];
	nameLabel.text = [cellContentArray objectAtIndex:0];
	nameLabel.numberOfLines = 0;   
	nameLabel.lineBreakMode = UILineBreakModeCharacterWrap;
	[cell addSubview:nameLabel];
	[nameLabel release];
	
	//文字样式 BY 李国威 2012－07－14
	UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 25, 280, cell.frame.size.height - 22)];
	contentLabel.font = [UIFont boldSystemFontOfSize:15];
	contentLabel.backgroundColor = [UIColor clearColor];
	contentLabel.text = [cellContentArray objectAtIndex:1];
	contentLabel.numberOfLines = 0;   
	contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
	[cell addSubview:contentLabel];
	[contentLabel release];
	
    return cell;
}

//UITableView代理方法，点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	currentPage = indexPath.row;
	[self setWithPageNumber:currentPage];
	currentPageView.frame = CGRectMake(0,705*currentPage,720,705);
	[contentScrollView setContentOffset:CGPointMake(0,705*currentPage) animated:NO];
}

// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

// Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview.
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

// Called after the view controller's view is released and set to nil. For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//对象释放
- (void)dealloc 
{
	[resultArray release];
	[contentScrollView release];
	[listTableView release];
	[prevPageView release];
	[currentPageView release];
	[nextPageView release];
    [super dealloc];
}


@end
