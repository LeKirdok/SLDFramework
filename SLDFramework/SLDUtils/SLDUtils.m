//
//  SLDUtils.m
//  SOLID
//
//  Created by Alper KIRDÖK on 9/13/15.
//  Copyright (c) 2015 Alper KIRDÖK. All rights reserved.
//

#import "SLDUtils.h"
#import <objc/runtime.h>

#define BASE_URL @"ALPER"

@implementation SLDUtils

static SLDUtils *singletonInstance;

#pragma mark - Initialization -

+ (SLDUtils *)sharedInstance
{
    //if (!singletonInstance)
    //NSLog(@"SlideNavigationController has not been initialized. Either place one in your storyboard or initialize one in code");
    
    static SLDUtils *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedMyManager = [[self alloc] init];
        
    });
    
    return singletonInstance;
    
}

- (id)init
{
    if (self = [super init])
    {
        [self setup];
    }
    
    return self;
}

- (void)setup{
    
    if (singletonInstance)
        NSLog(@"Singleton instance already exists. You can only instantiate one instance of SlideNavigationController. This could cause major issues");
    
    singletonInstance = self;
    //self.keepString = BASE_URL;
    
}

#pragma mark - MBProgressHUD

- (void)showHud:(NSString *)text view:(UIView *)view{
    
    [self.progressHUD removeFromSuperview];
    self.progressHUD = [[MBProgressHUD alloc] initWithView:view];
    self.progressHUD.mode= MBProgressHUDModeIndeterminate;
    self.progressHUD.removeFromSuperViewOnHide = YES;
    self.progressHUD.userInteractionEnabled = YES;
    [view addSubview:self.progressHUD];
    if(text){
        self.progressHUD.labelText = text;
    } else {
        self.progressHUD.labelText =@"Lütfen Bekleyiniz...";
    }
    [self.progressHUD show:YES];
    
}

- (void)hideHud{
    
    [self.progressHUD hide:YES];
    
}

#pragma mark - Default AlertView

- (void)informWithAlertViewWithTitle:(NSString *) title andMessage:(NSString *) message{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressHUD hide:YES];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Tamam", @"")  otherButtonTitles:nil];
        [alertView show];
    });
}

#pragma mark - RequestManager

- (AFHTTPRequestOperationManager*)getRequestManager{//SLD
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"keepToken"];
    
    if(token.length > 0){
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:self.headerKey];
        
    }
    
    [manager.requestSerializer setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
    [manager.requestSerializer setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
    NSString *uaString = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    uaString = [uaString stringByAppendingString:@" Mobile;App=PROF (1.0.0)"];
    [manager.requestSerializer setValue:uaString forHTTPHeaderField:@"User-Agent"];
    
    return manager;
    
}

#pragma mark - AppendURLToBase

- (NSString*)appendUrlToBase:(NSString*)url{//SLD
    
    return [self.baseURL stringByAppendingString:url];
    
}

#pragma mark - ScreenHeight

+ (CGFloat)getScreenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

#pragma mark - ScreenWidth

+ (CGFloat)getScreenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

#pragma mark - ScaleImage

+ (UIImage *)scaleImage:(UIImage *)sourceImage scaledToWidth:(float)i_width{
    
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

#pragma mark - closePicker

- (void)closeKeyboard:(UIBarButtonItem *)sender{
    
    UIViewController *viewController = (UIViewController*) objc_getAssociatedObject(sender, @"key");
    [viewController.view endEditing:YES];
    
}

- (UIToolbar *)getOkeyButton:(UIViewController *)viewController{

    UIToolbar *keyboardDoneButtonToolBar = [[UIToolbar alloc] init];
    keyboardDoneButtonToolBar.barStyle = UIBarStyleBlack;
    keyboardDoneButtonToolBar.translucent	= YES;
    keyboardDoneButtonToolBar.tintColor = nil;
    [keyboardDoneButtonToolBar sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(closeKeyboard:)];
    objc_setAssociatedObject(doneButton, @"key", viewController, OBJC_ASSOCIATION_ASSIGN);
    
    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil action:nil];
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil action:nil];
    [keyboardDoneButtonToolBar setItems:[NSArray arrayWithObjects:spacer1, spacer2, doneButton, nil]];
    
    return keyboardDoneButtonToolBar;
    
}


#pragma mark - Calculate Label Size

+ (CGSize)getCalculateLabelSizeMethod:(NSString *)text font:(UIFont *)font sizeMake:(CGSize)sizeMake{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect textRect = [text boundingRectWithSize:sizeMake
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName: paragraphStyle.copy}
                                         context:nil];
    
    return textRect.size;
    
}

#pragma mark - Date Methods

+ (NSString *)getDateFromSecondSince1970:(NSString *)second dateFormat:(NSString *)dateFormat{
    
    NSDate *secondDate = [NSDate dateWithTimeIntervalSince1970:[second doubleValue]/1000];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"tr_TR_POSIX"];
    [formatter setDateFormat:dateFormat];
    
    NSString *stringFromDate = [formatter stringFromDate:secondDate];
    
    return stringFromDate;
    
}

+ (NSDate *)getDateFormatFromString:(NSString *)stringDate dateFormat:(NSString *)dateFormat{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"tr_TR_POSIX"];
    [formatter setDateFormat:dateFormat];
    
    NSDate *dateFromString = [formatter dateFromString:stringDate];
    
    return dateFromString;
    
}

+ (NSString *)getStringDateFromDateFormat:(NSDate *)date dateFormat:(NSString *)dateFormat{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"tr_TR_POSIX"];
    [formatter setDateFormat:dateFormat];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    return stringFromDate;
    
}

+ (NSString *)getTurkishMounthName:(int)mounth{
    
    NSString *returnMounthString = @"";
    
    if (mounth == 12) {
        
        returnMounthString = @"Aralık";
        
    }else if (mounth == 11){
        
        returnMounthString = @"Kasım";
        
    }else if (mounth == 10){
        
        returnMounthString = @"Ekim";
        
    }else if (mounth == 9){
        
        returnMounthString = @"Eylül";
        
    }else if (mounth == 8){
        
        returnMounthString = @"Ağustos";
        
    }else if (mounth == 7){
        
        returnMounthString = @"Temmuz";
        
    }else if (mounth == 6){
        
        returnMounthString = @"Haziran";
        
    }else if (mounth == 5){
        
        returnMounthString = @"Mayıs";
        
    }else if (mounth == 4){
        
        returnMounthString = @"Nisan";
        
    }else if (mounth == 3){
        
        returnMounthString = @"Mart";
        
    }else if (mounth == 2){
        
        returnMounthString = @"Şubat";
        
    }else if (mounth == 1){
        
        returnMounthString = @"Ocak";
        
    }
    
    return returnMounthString;
    
}

+ (int)getDayOfMounth:(NSDate *)date dateFormat:(NSString *)dateFormat{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    int day = (int)[components day];
    
    return day;
    
}

+ (int)getMounthOfYear:(NSDate *)date dateFormat:(NSString *)dateFormat{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    int mounth = (int)[components month];
    
    return mounth;
    
}

+ (int)getYearFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    int year = (int)[components year];
    
    return year;
    
}

@end
