//
//  ViewController.m
//  ZaiBike-iOS
//
//  Created by May Ying on 1/11/15.
//  Copyright © 2015 ZaiBike. All rights reserved.
//

#import "MainViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MainViewController.h"
#import "ZBarViewController.h"

@implementation MainViewController{
    GMSMapView *mapView;
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // query server for rent/return status
    isRenting = [[NSUserDefaults standardUserDefaults] boolForKey:@"bikeRent"];
    lock_combi = [[NSUserDefaults standardUserDefaults] stringForKey:@"lock_combi"];
    
    [self initMap];
    // toggle rent/return status
    [self toggleStatus];
    
    [mapView addSubview:currentLocationBtn];
    [mapView addSubview:qrScanner];
    [mapView bringSubviewToFront:currentLocationBtn];
    [mapView bringSubviewToFront:qrScanner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initMap
{
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate: (id)self];
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
    }
#endif
    
    [locationManager startUpdatingLocation];
    // latitude and longitude of the current location of the device.
    double lati = locationManager.location.coordinate.latitude;
    double longi = locationManager.location.coordinate.longitude;
    NSLog(@"Latitude = %f", lati);
    NSLog(@"Longitude = %f", longi);
    
    // create a GMSCameraPosition that tells the map to display the coordinate
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lati
                                                            longitude:longi
                                                                 zoom:15.5f];
    
    mapView = [GMSMapView mapWithFrame:[[UIScreen mainScreen] bounds] camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.mapType = kGMSTypeHybrid;
    [self.view addSubview:mapView];
    
    [self initMarkers];
    
}



// toggle qr scanner label, and decide if should show combination code
- (void) toggleStatus
{
    NSAttributedString *attributedTitle = [qrScanner attributedTitleForState:UIControlStateNormal];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithAttributedString:attributedTitle];
    
    if (isRenting)
    {
        [mas.mutableString setString:@"Scan to Return"];
        [qrScanner setAttributedTitle:mas forState:UIControlStateNormal];
        [combi_code setText:[NSString stringWithFormat: @"  LOCK COMBINATION: %@  ",lock_combi]];
        [combi_code setBackgroundColor:[UIColor colorWithRed:(254/255.0f) green:(141/255.0f) blue:(9/255.0f) alpha:0.7]];
    }else
    {
        [mas.mutableString setString:@"Scan to Rent"];
        [qrScanner setAttributedTitle:mas forState:UIControlStateNormal];
        //[_qrScanner.titleLabel setFont: [_qrScanner.titleLabel.font fontWithSize:10.0f]];
        [combi_code setText:@""];
        [combi_code setBackgroundColor:[UIColor clearColor]];
    }
    
}

- (void) replaceItem:(int)j withItem:(int)item
{
    NSString *newItem = [NSString stringWithFormat:@"%i", item];
    [bike_num replaceObjectAtIndex:j withObject:newItem];
}

-(void)initMarkers
{
    bike_num = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++){
        [bike_num addObject:[NSString stringWithFormat:@"%i", 0]];
    }
    
    NSMutableArray *marker_des = [NSMutableArray arrayWithObjects:
                                  [NSArray arrayWithObjects:@1.341916f, @103.963889f, @"Block 59 Main Rack", nil],
                                  [NSArray arrayWithObjects:@1.342024f, @103.963625f, @"Block 59 Rack beside kitchen", nil],
                                  [NSArray arrayWithObjects:@1.342373f, @103.963950f, @"Block 57 Rack beside kitchen", nil],
                                  [NSArray arrayWithObjects:@1.342661f, @103.964243f, @"Block 55 Rack beside kitchen", nil],
                                  [NSArray arrayWithObjects:@1.341364f, @103.964554f, @"Block Sports Hall Rack", nil],
                                  [NSArray arrayWithObjects:@1.341744f, @103.963177f, @"Fab Lab Rack", nil],
                                  [NSArray arrayWithObjects:@1.340007f, @103.962269f, @"Building 1 Rack", nil],
                                  [NSArray arrayWithObjects:@1.334443f, @103.961661f, @"Expo MRT", nil], nil];
    
    NSString *param = [NSString stringWithFormat:@"action=search_bike"];
    
//    URLHandler *urlObject = [[URLHandler alloc] init];
//    [urlObject httpPOST :param completion:^(NSDictionary *request)
//     {
//         NSDictionary *bikes = request[@"data"];
//         
//         for (NSDictionary *bike in bikes)
//         {
//             NSArray *foo = [[bikes valueForKeyPath:[NSString stringWithFormat: @"%@.locale", bike]] componentsSeparatedByString: @"|"];
//             int j = 0;
//             for (NSArray *i in marker_des)
//             {
//                 if ([[foo firstObject] floatValue] == [i[0] floatValue])
//                 {
//                     int initValue = [[bike_num objectAtIndex:j] intValue];
//                     int finalValue = initValue + 1;
//                     NSString *newItem = [NSString stringWithFormat:@"%i", finalValue];
//                     [bike_num replaceObjectAtIndex:j withObject:newItem];
//                     break;
//                 }
//                 j += 1;
//             }
//         }
//         
//         int k = 0;
//         UIImage *image = nil;
//         
//         if (isRenting)
//         {
//             image = [UIImage imageNamed:@"cycle_marker.png"];
//         }else
//         {
//             image = [UIImage imageNamed:@"walk_marker.png"];
//         }
//         
//         for (NSArray *i in marker_des){
//             if (([[bike_num objectAtIndex: k] intValue] == 0) && isRenting){
//                 k += 1;
//                 continue;
//             }
//             
//             GMSMarker *marker = [[GMSMarker alloc] init];
//             marker.position = CLLocationCoordinate2DMake([i[0] floatValue], [i[1] floatValue]);
//             marker.title = i[2];
//             if (isRenting){
//                 marker.snippet = [NSString stringWithFormat: @"Number of bikes: %i", [[bike_num objectAtIndex: k] intValue]];
//             }
//             marker.map = mapView;
//             marker.icon = image;
//             k += 1;
//         }
//     }];
}

-(IBAction)toggleTransit:(UIButton*)sender {
    sender.selected = !sender.selected;
    [self initMarkers];
    NSAttributedString *attributedTitle = [inTransit attributedTitleForState:UIControlStateNormal];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithAttributedString:attributedTitle];
    
    if (sender.selected){
        [mas.mutableString setString:@"Parking Bike"];
        [mas addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [@"Parking Bike" length])];
        [inTransit setAttributedTitle:mas forState:UIControlStateSelected];
        [inTransit setBackgroundImage:[UIImage imageNamed:@"cycling.png"] forState:UIControlStateSelected];
        isRenting = NO;
    }else{
        [mas.mutableString setString:@"Locating Bike"];
        [mas addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(254/255.0f) green:(141/255.0f) blue:(9/255.0f) alpha:0.7] range:NSMakeRange(0, [@"Locating Bike" length])];
        [inTransit setAttributedTitle:mas forState:UIControlStateNormal];
        [inTransit setBackgroundImage:[UIImage imageNamed:@"walking.png"] forState:UIControlStateSelected];
        isRenting = YES;
    }
    [mapView clear];
}

// Show current location
- (IBAction)showCurrentLocation:(id)sender {
    [locationManager startUpdatingLocation];
    
    //    Latitude and longitude of the current location of the device.
    double lati = locationManager.location.coordinate.latitude;
    double longi = locationManager.location.coordinate.longitude;
    NSLog(@"Latitude = %f", lati);
    NSLog(@"Longitude = %f", longi);
    
    //     Create a GMSCameraPosition that tells the map to display the coordinate
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lati
                                                            longitude:longi
                                                                 zoom:15.5f];
    
    [mapView animateToCameraPosition:camera];
    NSLog(@"%f", mapView.myLocation.coordinate.longitude);
}


- (IBAction)showSettings:(id)sender {
    NSDictionary *mapType = [[NSUserDefaults standardUserDefaults] valueForKey:@"mapType"];
    int value = [(NSString *)mapType intValue] + 1;
    if (value == 5){
        value = 1;
    }
    
    NSLog(@"%@, %i", mapType, value);
    
    switch (value) {
        case 1:
            mapView.mapType = kGMSTypeNormal;
            break;
        case 2:
            mapView.mapType = kGMSTypeHybrid;
            break;
        case 3:
            mapView.mapType = kGMSTypeSatellite;
            break;
        case 4:
            mapView.mapType = kGMSTypeTerrain;
            break;
        default:
            mapView.mapType = kGMSTypeHybrid;
            break;
    }
    [[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%i", value] forKey:@"mapType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)showMore:(UIButton*)sender {
    sender.selected = !sender.selected;
    NSAttributedString *attributedTitleMore = [inTransit attributedTitleForState:UIControlStateNormal];
    NSMutableAttributedString *masMore = [[NSMutableAttributedString alloc] initWithAttributedString:attributedTitleMore];
    
    if (sender.selected) {
        [UIView animateWithDuration:.5 animations:^{
            settings.hidden = NO;
            CGAffineTransform translate = CGAffineTransformMakeTranslation(-85, 0);
            CGAffineTransform rotate = CGAffineTransformMakeRotation(4*M_PI);
            CGAffineTransform concat = CGAffineTransformConcat(rotate, translate);
            
            [settings setTransform:concat];
            
            [masMore.mutableString setString:@""];
            [more setAttributedTitle:masMore forState:UIControlStateNormal];
            more.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
        
    }else{
        
        [UIView animateWithDuration:.5 animations:^{
            CGAffineTransform translate = CGAffineTransformMakeTranslation(0, 0);
            CGAffineTransform rotate = CGAffineTransformMakeRotation(0);
            CGAffineTransform concat = CGAffineTransformConcat(rotate, translate);
            
            [settings setTransform:concat];
            
            [masMore.mutableString setString:@"More"];
            [masMore addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(254/255.0f) green:(141/255.0f) blue:(9/255.0f) alpha:1.0] range:NSMakeRange(0, [@"More" length])];
            [more setAttributedTitle:masMore forState:UIControlStateNormal];
            more.transform = CGAffineTransformMakeRotation	(4*M_PI);
        }completion:^(BOOL finished) {
            settings.hidden = YES;
        }];
    }
    
}

- (IBAction)showSupport:(id)sender {
    NSString *title = @"Support Us Now!";
    NSString *msg = @"Our campaign has ended BUT you can still see our handsome CEO introducing ZaiBike to you!";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"Support later"
                                          otherButtonTitles:nil];
    
    [alert addButtonWithTitle:@"Support ZaiBike"];
    
    [alert show];
}

- (IBAction)showFeedback:(id)sender {
    NSString *title = @"I have issues to feedback!";
    NSString *msg = @"Can't find bike? Map won't display? Want us to expand to Simei MRT? Or simply has something to say? Let us know, we'd love to grant your wish!";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"Later"
                                          otherButtonTitles:nil];
    
    [alert addButtonWithTitle:@"Feedback now"];
    
    [alert show];}



-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Support ZaiBike"])
    {
        NSURL *url = [ [ NSURL alloc ] initWithString: @"http://igg.me/at/zaibike/x" ];
        
        [[UIApplication sharedApplication] openURL:url];
    }else if([title isEqualToString:@"Feedback now"])
    {
        NSLog(@"got lei");
        NSURL *url = [ [ NSURL alloc ] initWithString: @"https://docs.google.com/forms/d/18ggrzVatjR27XPu570Re54bY4nETpJ9FreRbl9GRpwY/viewform" ];
        
        [[UIApplication sharedApplication] openURL:url];
    }
}


- (IBAction)scanQR:(id)sender {
    _codeReader = [ZBarViewController new];
    _codeReader.readerDelegate = self;
    _codeReader.showsZBarControls = YES;
    _codeReader.showsHelpOnFail = YES;
    _codeReader.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    
    ZBarImageScanner *scanner = _codeReader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    [self presentViewController:_codeReader animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // get the decode results
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    for (symbol in results)
        break;
    
    //check if the key exists and its value
    BOOL bikeRent = [[NSUserDefaults standardUserDefaults] boolForKey:@"bikeRent"];
    // Rack: myzairack[1-8];[lat];[long]
    // Bike: myzaibike[1-10]
    NSLog(bikeRent ? @"Renting" : @"Not renting");
    if ([symbol.data isEqualToString:@"mydemobike"]){
        if (bikeRent){
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"bikeRent"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSAttributedString *attributedTitle = [qrScanner attributedTitleForState:UIControlStateNormal];
            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithAttributedString:attributedTitle];
            [mas.mutableString setString:@"Scan to Rent"];
            [qrScanner setAttributedTitle:mas forState:UIControlStateNormal];
            
            [self alert:@"Thank you for riding ZaiBike!" title:@"Bike Returned!"];
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"bikeRent"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSAttributedString *attributedTitle = [qrScanner attributedTitleForState:UIControlStateNormal];
            NSMutableAttributedString *mas_ch2return = [[NSMutableAttributedString alloc] initWithAttributedString:attributedTitle];
            
            [mas_ch2return.mutableString setString:@"Scan to Return"];
            [qrScanner setAttributedTitle:mas_ch2return forState:UIControlStateNormal];
            
            [self alert:[NSString stringWithFormat:@"Have a pleasant journey!"] title:@"Bike Rented!"];
        }
    }else{
        
        NSArray *arr = [symbol.data componentsSeparatedByString:@";"];
        NSLog(@"arrrrrrrrrrrrrrrrrr%@", arr);
        // if it's renting, they want to return
        if ([arr count] == 3) {
            NSString *booking_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"booking_id"];
            NSString *bike_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"bike_id"];
            
            NSString *param = [NSString stringWithFormat:@"action=park_bike&bike_id=%@&booking_id=%@&lat=%@&lng=%@", bike_id, booking_id, arr[1], arr[2]];
            NSLog(@"trying to return %@", param);
            
//            URLHandler *urlObject = [[URLHandler alloc] init];
//            [urlObject httpPOST :param completion:^(NSDictionary *request){
//                NSString *status = request[@"status"];
//                NSLog(@"return status %@", status);
//                
//                if ([status isEqualToString:@"ok"]) {
//                    
//                    
//                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"bikeRent"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    [self initMarkers];
//                    
//                    [combi_code setText:@""];
//                    [combi_code setBackgroundColor: [UIColor clearColor]];
//                    
//                    NSAttributedString *attributedTitle = [qrScanner attributedTitleForState:UIControlStateNormal];
//                    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithAttributedString:attributedTitle];
//                    [mas.mutableString setString:@"Scan to Rent"];
//                    [qrScanner setAttributedTitle:mas forState:UIControlStateNormal];
//                    
//                    [self alert:@"Thank you for riding with ZaiBike!" title:@"Bike Returned!"];
//                    
//                }else if([status isEqualToString:@"no user"]){
//                    [self alert:@"This bike is currently unoccupied. Do rent first then return!" title:@"Oopsie!" ];
//                }else if([status isEqualToString:@"no booking"]){
//                    [self alert:@"You currently do not have an active session! Please rent a bike before returning it." title:@"Oopsie!"];
//                }else{
//                    [self alert:@"Return Error! Please contact ZaiBike team @97578476" title:@"Oopsie!"];
//                }
//            }];
//            
//            // if it's not renting, they want to rent
//        }else if([arr count] == 1){
//            NSString *bike_id = arr[0];
//            NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"];
//            
//            NSString *param = [NSString stringWithFormat:@"action=rent_bike&bike_id=%@&user_id=%@", bike_id, userID];
//            URLHandler *urlObject = [[URLHandler alloc] init];
//            [urlObject httpPOST :param completion:^(NSDictionary *request){
//                NSString *status = request[@"status"];
//                NSString *booking_id = request[@"booking_id"];
//                lock_combi = request[@"lock_combi"];
//                
//                NSLog(@"rent status %@", status);
//                NSLog(@"booking id %@", booking_id);
//                NSLog(@"lock_combi %@", lock_combi);
//                
//                if ([status isEqualToString:@"ok"]){
//                    [self initMarkers];
//                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"bikeRent"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    
//                    [[NSUserDefaults standardUserDefaults] setObject: booking_id forKey:@"booking_id"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    
//                    [[NSUserDefaults standardUserDefaults] setObject: bike_id forKey:@"bike_id"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    
//                    [[NSUserDefaults standardUserDefaults] setObject: lock_combi forKey:@"lock_combi"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    
//                    [combi_code setText:[NSString stringWithFormat: @"  LOCK COMBINATION: %@  ",lock_combi]];
//                    [combi_code setBackgroundColor:[UIColor colorWithRed:(254/255.0f) green:(141/255.0f) blue:(9/255.0f) alpha:1.0]];
//                    
//                    NSAttributedString *attributedTitle = [qrScanner attributedTitleForState:UIControlStateNormal];
//                    NSMutableAttributedString *mas_ch2return = [[NSMutableAttributedString alloc] initWithAttributedString:attributedTitle];
//                    
//                    [mas_ch2return.mutableString setString:@"Scan to Return"];
//                    [qrScanner setAttributedTitle:mas_ch2return forState:UIControlStateNormal];
//                    
//                    [self alert:[NSString stringWithFormat:@"Lock Combination: %@\nHave a pleasant journey!",lock_combi] title:@"Bike Rented!"];
//                }else if([status isEqualToString:@"currently renting bike"]){
//                    [self alert:@"Looks like you are still renting one of the ZaiBikes. Please return first!" title:@"Oopsie!"];
//                }else if([status isEqualToString:@"bike not available"]){
//                    [self alert:@"This bike is still being rented! Please contact ZaiBike team @97578476 if you really want to ride with this bike" title:@"Oopsie!"];
//                }else{
//                    [self alert:@"Rent error! Please contact ZaiBike team@97578476" title:@"Oopsie!"];
//                }
//            }];
            
        }else{
            [self alert:@"Rent/Return Error! Please contact ZaiBike team @97578476" title:@"Oopsie!" ];
        }
    }
    
    [_codeReader dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        imgView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        imgView.alpha = 0.0;
        imgView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        if (finished) {
            [imgView removeFromSuperview];
        }
    }];
}

- (void)showAnimate:(NSString *) img
{
    [mapView addSubview:imgView];
    imgView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    imgView.alpha = 0;
    imgView.image = [UIImage imageNamed:img];
    [UIView animateWithDuration:3 animations:^{
        imgView.alpha = 1;
        imgView.transform = CGAffineTransformMakeScale(1, 1);
        
        [self removeAnimate];
    }];
}

-(void)alert:(NSString *) msg title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
