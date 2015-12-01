//
//  SLDUtils.h
//  SOLID
//
//  Created by Alper KIRDÖK on 9/13/15.
//  Copyright (c) 2015 Alper KIRDÖK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface SLDUtils : NSObject

@property (nonatomic, strong) MBProgressHUD *progressHUD;

+ (SLDUtils *)sharedInstance;

+ (AppDelegate *)getAppDelegate;
- (void)showHud:(NSString *)text view:(UIView *)view;
- (void)hideHud;
- (void)informWithAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message;
- (AFHTTPRequestOperationManager *)getRequestManager;
- (NSString *)appendUrlToBase:(NSString *)url;
+ (CGFloat)getScreenHeight;
+ (CGFloat)getScreenWidth;
+ (UIImage *)scaleImage:(UIImage *)sourceImage scaledToWidth:(float)i_width;

+ (void)saveNSUserDefaults:(id)object key:(NSString *)key;
- (UIToolbar *)getOkeyButton:(UIViewController *)viewController;
- (void)closeKeyboard:(UIBarButtonItem *)sender;

+ (CGSize)getCalculateLabelSizeMethod:(NSString *)text font:(UIFont *)font sizeMake:(CGSize)sizeMake;

//Calculate Date Methods
+ (NSString *)getDateFromSecondSince1970:(NSString *)second dateFormat:(NSString *)dateFormat;
+ (NSDate *)getDateFormatFromString:(NSString *)stringDate dateFormat:(NSString *)dateFormat;
+ (NSString *)getStringDateFromDateFormat:(NSDate *)date dateFormat:(NSString *)dateFormat;
+ (NSString *)getTurkishMounthName:(int)mounth;
+ (int)getDayOfMounth:(NSDate *)date dateFormat:(NSString *)dateFormat;
+ (int)getMounthOfYear:(NSDate *)date dateFormat:(NSString *)dateFormat;
+ (int)getYearFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *headerKey;

@end
