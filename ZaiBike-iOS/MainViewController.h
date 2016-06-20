//
//  ViewController.h
//  ZaiBike-iOS
//
//  Created by May Ying on 1/11/15.
//  Copyright © 2015 ZaiBike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleMaps/GoogleMaps.h"
#import "ZBarSDK.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MainViewController : UIViewController <ZBarReaderDelegate, UIAlertViewDelegate>
{
    BOOL isRenting;
    NSMutableArray *bike_num;
    NSString *lock_combi;
    IBOutlet UIButton *currentLocationBtn;
    IBOutlet UIButton *qrScanner;
    IBOutlet UIButton *inTransit;
    IBOutlet UIImageView *imgView;
    IBOutlet UIButton *more;
    IBOutlet UIButton *settings;
    IBOutlet UIButton *crowdtivate;
    IBOutlet UILabel *combi_code;
    __weak IBOutlet UIButton *signOut;
    __weak IBOutlet UIButton *feedback;
    
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) ZBarReaderViewController *codeReader;

- (IBAction)toggleTransit:(UIButton*)sender;
- (IBAction)showCurrentLocation:(id)sender;
- (IBAction)scanQR:(id)sender;
- (IBAction)showSettings:(id)sender;
- (IBAction)showMore:(UIButton *)sender;
- (IBAction)showSupport:(id)sender;
- (IBAction)showFeedback:(id)sender;
- (IBAction)signOut:(id)sender;

- (void)initMarkers;
- (void)toggleStatus;
- (void)initMap;
@end

