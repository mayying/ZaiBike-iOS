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


@interface ViewController : UIViewController <ZBarReaderDelegate, UIAlertViewDelegate>{
    BOOL renting;
}
@property (weak, nonatomic) IBOutlet UIButton *currentLocationBtn;
@property (weak, nonatomic) IBOutlet UIButton *qrScanner;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) ZBarReaderViewController *codeReader;
@property (weak, nonatomic) IBOutlet UIButton *inTransit;
@property NSMutableArray *bike_num;
@property NSNumber *lock_combi;
@property BOOL isWalking;
@property (retain, atomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *more;
@property (weak, nonatomic) IBOutlet UIButton *settings;
@property (weak, nonatomic) IBOutlet UIButton *crowdtivate;
@property (weak, nonatomic) IBOutlet UILabel *combi_code;

- (IBAction)toggleTransit:(UIButton*)sender;
- (IBAction)showCurrentLocation:(id)sender;
- (IBAction)scanQR:(id)sender;
- (IBAction)showSettings:(id)sender;
- (IBAction)showMore:(UIButton *)sender;
- (IBAction)showSupport:(id)sender;
- (IBAction)showFeedback:(id)sender;



- (void)initMarkers;
@end

