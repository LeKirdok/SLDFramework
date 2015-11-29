//
//  SLDGrandBaseViewController.m
//  SLDFramework
//
//  Created by Alper KIRDÖK on 25/11/15.
//  Copyright © 2015 Alper KIRDÖK. All rights reserved.
//

#import "SLDGrandBaseViewController.h"
#import "SLDUtils.h"

@interface SLDGrandBaseViewController ()

@end

@implementation SLDGrandBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)showErrorWithErrorCodes:(long)errorCode{
    
    NSString *errorMessage = nil;
    
    switch (errorCode) {
        case 0:
            errorMessage = @"İnternet bağlantınızı kontrol ediniz";
            break;
        case 403:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SLDUtils sharedInstance].progressHUD hide:YES];
                UIAlertView *hata403AlertView = [[UIAlertView alloc]initWithTitle:@"Hata" message:@"Giriş yapma süreniz dolmuştur. Lütfen tekrar giriş yapınız." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                hata403AlertView.delegate = self;
                hata403AlertView.tag = 8989;
                [hata403AlertView show];
            });
            
        }
            break;
            
        default:
            errorMessage = @"Bağlantı hatası";
            break;
    }
    
    if (errorCode != 403) {
        [[SLDUtils sharedInstance]informWithAlertViewWithTitle:@"Hata" andMessage:errorMessage];
    }
    
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 8989) {
        if (buttonIndex == 0) {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"keepToken"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //rootviewConroller'a donus yapilir.
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
