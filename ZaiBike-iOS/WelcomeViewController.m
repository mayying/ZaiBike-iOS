//
//  WelcomeViewController.m
//  ZaiBike-iOS
//
//  Created by May Ying on 25/2/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import "WelcomeViewController.h"
#import "EmailLoginViewController.h"
#import "DesignFactory.h"

@implementation WelcomeViewController

- (IBAction)changePage:(id)sender{

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [[segue destinationViewController] setPage:pageControl.currentPage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    CGSize pageScrollViewSize = self.view.frame.size;
    scrollView.contentSize = CGSizeMake(pageScrollViewSize.width * pageCount, 0);
    //    NSLog(@"##### $$$$$ %lu --- %lu", (long unsigned)self.view.bounds.size.width, (long unsigned)self.view.bounds.size.height);
    
    [self loadVisiblePages];
}

- (void) loadVisiblePages
{
    CGFloat pageWidth = self.view.frame.size.width;
    
    NSInteger page = (NSInteger)floor((scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    pageControl.currentPage = page;
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    for (NSInteger i = 0; i < firstPage; i++)
    {
        [self purgePage:i];
    }
    
    for (NSInteger i = firstPage; i <= lastPage; i++)
    {
        [self loadPage:i];
    }
    
    for (NSInteger i = lastPage+1; i<pageCount; i++) {
        [self purgePage:i];
    }
    NSLog(@"page%lu    %lu --- %lu", (long unsigned)pageControl.currentPage, (long unsigned)self.view.bounds.size.width, (long unsigned)self.view.bounds.size.height);
    
}

- (void) loadPage:(NSInteger)page
{
    if (page < 0 || page >= pageCount)
    {
        return;
    }
    
    
    
    UIView *pageView = [pageViews objectAtIndex:page];
    
    if ((NSNull*)pageView == [NSNull null])
    {
        
        CGRect frame = self.view.bounds;
        
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        newPageView = [[UIImageView alloc] initWithImage:[DesignFactory getBgImage:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        newPageView.backgroundColor = [DesignFactory getBgColor:page];
        
        [scrollView addSubview:newPageView];
        
        [pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void) purgePage:(NSInteger) page
{
    if (page < 0 || page >= pageCount) {
        return;
    }
    
    UIView *pageView = [pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null])
    {
        [pageView removeFromSuperview];
        [pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
        
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView_
{
    [self loadVisiblePages];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageCount = [DesignFactory getBgImageCount];
    
    pageControl.currentPage = 0;
    pageControl.numberOfPages = pageCount;
    
    pageViews = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < pageCount; ++i)
    {
        [pageViews addObject:[NSNull null]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
