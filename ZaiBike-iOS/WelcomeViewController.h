//
//  WelcomeViewController.h
//  ZaiBike-iOS
//
//  Created by May Ying on 25/2/16.
//  Copyright © 2016 ZaiBike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *loginFacebook;
    NSMutableArray *pageViews;
    NSMutableArray *pageTextViews;
    UIImageView *newPageView;
    int pageCount;
}

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
- (IBAction)changePage:(id)sender;
@property(nonatomic, copy) UIColor *backgroundColor;


@end
