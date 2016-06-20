//
//  WelcomeViewController.m
//  ZaiBike-iOS
//
//  Created by May Ying on 25/2/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import "WelcomeViewController.h"
#import "EmailLoginViewController.h"
#import "Utilities.h"

@implementation WelcomeViewController

- (IBAction)changePage:(id)sender{

}

- (IBAction)loginEmailBtn:(id)sender {
    sharedManager.currentPage = (NSInteger *) pageControl.currentPage;
    UIStoryboard *mySB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EmailLoginViewController *view = [mySB instantiateViewControllerWithIdentifier:@"EmailLoginViewController"];
    [self presentViewController:view animated:YES completion:NULL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    CGSize pageScrollViewSize = self.view.frame.size;
    scrollView.contentSize = CGSizeMake(pageScrollViewSize.width * pageCount, 0);
    [self loadVisiblePages];
}

- (void) loadVisiblePages
{
    CGFloat pageWidth = self.view.frame.size.width;
    NSInteger page = (NSInteger)floor((scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    pageControl.currentPage = page;
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    NSLog(@"hello00 %llu", (long long unsigned)page);
    NSLog(@"hello01 %llu", (long long unsigned)firstPage);
    NSLog(@"hello02 %llu", (long long unsigned)lastPage);

    for (NSInteger i = 0; i < firstPage; i++)
    {
        NSLog(@"hello0 %llu %llu", (long long unsigned)pageControl.currentPage, (long long unsigned)i);

        [self purgePage:i];
    }
    
    for (NSInteger i = firstPage; i <= lastPage; i++)
    {
        NSLog(@"hello1 %llu %llu", (long long unsigned)pageControl.currentPage, (long long unsigned)i);

        [self loadPage:i];
    }
    
    for (NSInteger i = lastPage+1; i<pageCount; i++) {
        NSLog(@"hello2 %llu %llu", (long long unsigned)pageControl.currentPage, (long long unsigned)i);

        [self purgePage:i];
    }
    
}

- (void) loadPage:(NSInteger)page
{
    NSLog(@"hello4 %llu", (long long unsigned)page);

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
        
        newPageView = [[UIImageView alloc] initWithImage:[Utilities getBgImage:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        newPageView.backgroundColor = [Utilities getBgColor:page];
        
        [scrollView addSubview:newPageView];
        
        [pageViews replaceObjectAtIndex:page withObject:newPageView];
        NSLog(@"hello6 %@", newPageView );

    }
}

- (void) purgePage:(NSInteger) page
{
    NSLog(@"hello5 %llu", (long long unsigned)page);

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
    
    pageCount = [Utilities getBgImageCount];
    
    sharedManager = [DataManager sharedManager];
    
    if (sharedManager.currentPage != NULL){
        pageControl.currentPage = (NSInteger) sharedManager.currentPage;
    }else{
        pageControl.currentPage = 0;
    }    
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
