//
//  RegistrationViewController.m
//  BankingAppDemo
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "TouchIdManager.h"
#import "ActivityIndicatorView.h"
#import "AppDelegate.h"
#import "UserDetail.h"
#import "MacroUtilities.h"
#import "KeychainItemWrapper.h"
#import "UserRegistrationManager.h"
#import "RegistrationViewController.h"

#define REGISTRATIONSUCCESS_ALERT_TAG 1001

@implementation RegistrationViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(320, 650);
    [self.navigationItem setHidesBackButton:YES];
}

#pragma mark - IBAction

- (IBAction) registerButtonAction:(id)sender
{
    NSString* userName = self.userNameTextField.text;
    NSString* password = self.passwordTextField.text;

    if (([userName length] > 0) && ([password length] > 0))
    {
        [self.userNameTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        if ([[TouchIdManager sharedInstance] checkForTouchIdAvailability])
        {
            [self evaluatePolicy];
        }
        else
        {
            [self registerUserToserver];
        }
    }
    else
    {
        if ([userName length] < 1)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:LocalizedString(kEmpty_Alert_Title) message:LocalizedString(kUserName_AlertTitle) delegate:nil cancelButtonTitle:LocalizedString(kOK_ButtonTitle) otherButtonTitles:nil, nil];
            [alert show];
        }
        else if ([password length] < 1)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:LocalizedString(kEmpty_Alert_Title) message:LocalizedString(kPassword_AlertTitle) delegate:nil cancelButtonTitle:LocalizedString(kOK_ButtonTitle) otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark - PrivateMethod

- (void) evaluatePolicy
{
    [ActivityIndicatorView showActivityIndicatorView];
    [[TouchIdManager sharedInstance] evaluatePolicyWithCompletion:^()
     {
         [self registerUserToserver];
         
     }failureBlock:^(NSError* error)
     {
         [ActivityIndicatorView hideActivityIndicatorView];
         NSString* alertMessage = nil;
         switch (error.code)
         {
             case LAErrorUserFallback:
                 alertMessage = LocalizedString(kTouch_Id_AlertTitle);
                 break;
             case LAErrorAuthenticationFailed:
             case LAErrorUserCancel:
             default:
                 alertMessage = [error localizedDescription];
                 break;
         }
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:LocalizedString(kEmpty_Alert_Title) message:alertMessage delegate:nil cancelButtonTitle:LocalizedString(kOK_ButtonTitle) otherButtonTitles:nil, nil];
         [alert show];
     }];
}

- (UserDetail*) getUserDetail
{
    UserDetail* user = [[UserDetail alloc] init];
    user.userName = self.userNameTextField.text;
    user.password = self.passwordTextField.text;
    [user setCredentialHashOfUser];
    [user setDeviceInfoHashOfUser];
    
    return user;
}

- (void) registerUserToserver
{
    UserDetail* user = [self getUserDetail];
    [ActivityIndicatorView showActivityIndicatorView];
    [[UserRegistrationManager sharedInstance] registerUser:user onCompletion:^()
     {
         [ActivityIndicatorView hideActivityIndicatorView];
         AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
         [delegate.keychainItem setObject:user.credentialHashInfo forKey:(__bridge id)kSecValueData];
         
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:LocalizedString(kEmpty_Alert_Title) message:LocalizedString(kRegistrationSuccess_Alert_Title) delegate:self cancelButtonTitle:LocalizedString(kOK_ButtonTitle) otherButtonTitles:nil, nil];
         [alert show];
         [alert setTag:REGISTRATIONSUCCESS_ALERT_TAG];
     }failureBlock:^(NSError * error)
     {
         [ActivityIndicatorView hideActivityIndicatorView];
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:LocalizedString(kEmpty_Alert_Title) message:[error localizedDescription] delegate:nil cancelButtonTitle:LocalizedString(kOK_ButtonTitle) otherButtonTitles:nil, nil];
         [alert show];
         NSLog(@"fail");
     }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == REGISTRATIONSUCCESS_ALERT_TAG)
    {
        if (self.registrationDelegate && [self.registrationDelegate respondsToSelector:@selector(registrationSuccessful)])
        {
            [self.registrationDelegate registrationSuccessful];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
