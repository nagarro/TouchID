//
//  LoginViewController.m
//  BankingAppDemo
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "TouchIdManager.h"
#import "UserDetail.h"
#import "KeychainItemWrapper.h"
#import "AppDelegate.h"
#import "ActivityIndicatorView.h"
#import "MacroUtilities.h"
#import "UserRegistrationManager.h"
#import "RegistrationViewController.h"
#import "LoginViewController.h"

static NSString* const kCydiaPkgUrlString = @"cydia://package/com.example.package";
static NSString* const kFilePath = @"/private/var/lib/apt/";

#define CREDENTIAL_NOTVALID_ALERT_TAG 1002

@interface LoginViewController()<RegistrationViewControllerDelegate>

@end

@implementation LoginViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
//    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
//    [delegate.keychainItem resetKeychainItem];
//
//    return;
//    
    if([self checkJailbreak])
    {
        [self performSegueWithIdentifier:@"AccessDeniedSegue" sender:self];
    }
    else
    {
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        NSString* credentialHash = [delegate.keychainItem objectForKey:(__bridge id)kSecValueData];
        if ([credentialHash length]>0)
        {
            if ([[TouchIdManager sharedInstance] checkForTouchIdAvailability])
            {
                [self.scrollView setHidden:YES];
                [self evaluatePolicy];
            }
            else
            {
                [self.scrollView setContentSize:CGSizeMake(320, 650)];
            }
        }
        else
        {
            [self.scrollView setHidden:YES];
            [self performSegueWithIdentifier:@"RegistrationSegue" sender:self];
        }
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.userNameTextField.text = @"";
    self.passwordTextField.text = @"";
}

#pragma mark - PrivateMethod

- (void) evaluatePolicy
{
    [ActivityIndicatorView showActivityIndicatorView];
    [[TouchIdManager sharedInstance] evaluatePolicyWithCompletion:^()
     {
         UserDetail* user = [self getUserDetail:NO];
         [[UserRegistrationManager sharedInstance] checkUserCredential:user onCompletion:^()
          {
              [ActivityIndicatorView hideActivityIndicatorView];
              [self performSegueWithIdentifier:@"AccountSummarySegue" sender:self];
              
          }failureBlock:^(NSError * error)
          {
              [ActivityIndicatorView hideActivityIndicatorView];
              [self showErrorToUser:error];
          }];
     }
    failureBlock:^(NSError* error)
     {
         [ActivityIndicatorView hideActivityIndicatorView];
         switch (error.code)
         {
             case LAErrorUserFallback:
             {
                 [self.scrollView setHidden:NO];
                 [self.scrollView setContentSize:CGSizeMake(320, 650)];
                 break;
             }
             case LAErrorAuthenticationFailed:
             case LAErrorUserCancel:
             default:
             {
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:LocalizedString(kEmpty_Alert_Title) message:[error localizedDescription] delegate:nil cancelButtonTitle:LocalizedString(kOK_ButtonTitle) otherButtonTitles:nil, nil];
                 [alert show];
                 break;
             }
         }
     }];
}

- (UserDetail*) getUserDetail:(BOOL) isLoginManually
{
    UserDetail* user = [[UserDetail alloc] init];
    if (isLoginManually)
    {
        user.userName = self.userNameTextField.text;
        user.password = self.passwordTextField.text;
        [user setCredentialHashOfUser];
    }
    else
    {
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        user.credentialHashInfo = [delegate.keychainItem objectForKey:(__bridge id)kSecValueData];
    }
    [user setDeviceInfoHashOfUser];
    return user;
}

- (void) showErrorToUser:(NSError*) error
{
    NSString* title = nil;
    if (error)
        title = [error localizedDescription];
    else
        title = LocalizedString(kEmpty_Alert_Title);
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:LocalizedString(kCredential_NotValid_AlertTitle) delegate:self cancelButtonTitle:LocalizedString(kOK_ButtonTitle) otherButtonTitles:nil, nil];
    [alert show];
    [alert setTag:CREDENTIAL_NOTVALID_ALERT_TAG];
}

#pragma mark - IBAction

- (IBAction) loginButtonAction:(id)sender
{
    NSString* userName = self.userNameTextField.text;
    NSString* password = self.passwordTextField.text;
    
    if (([userName length] > 0) && ([password length] > 0))
    {
        [self.userNameTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        UserDetail* user = [self getUserDetail:YES];
        [ActivityIndicatorView showActivityIndicatorView];
        [[UserRegistrationManager sharedInstance] checkUserCredential:user onCompletion:^()
         {
             [ActivityIndicatorView hideActivityIndicatorView];
             [self performSegueWithIdentifier:@"AccountSummarySegue" sender:self];
             
         }failureBlock:^(NSError * error)
         {
             [ActivityIndicatorView hideActivityIndicatorView];
             [self showErrorToUser:error];
         }];
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

- (BOOL) checkCydiaUrlOpenable
{
    NSURL* url = [NSURL URLWithString:kCydiaPkgUrlString];
    return [[UIApplication sharedApplication] canOpenURL:url];
}

- (BOOL) checkFileExist
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:kFilePath];
}

- (BOOL) checkJailbreak
{
    BOOL isJailBroken = NO;
    FILE *f = fopen("/bin/bash", "r");
    if (f != NULL)
    {
        //Device is jailbroken
        isJailBroken = YES;
        fclose(f);
    }
    else if ([self checkCydiaUrlOpenable])
    {
        isJailBroken = YES;
    }
    else if ([self checkFileExist])
    {
        isJailBroken = YES;
    }
    fclose(f);
    return isJailBroken;
}

#pragma Mark - PrepareForSegue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RegistrationSegue"])
    {
        RegistrationViewController* registration = segue.destinationViewController;
        registration.registrationDelegate = self;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CREDENTIAL_NOTVALID_ALERT_TAG)
    {
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        [delegate.keychainItem resetKeychainItem];
        [self.scrollView setHidden:YES];
        [self performSegueWithIdentifier:@"RegistrationSegue" sender:self];
    }
}

#pragma Mark - RegistrationDelegate

- (void) registrationSuccessful
{
    if ([[TouchIdManager sharedInstance] checkForTouchIdAvailability])
    {
        [self evaluatePolicy];
    }
    else
    {
        [self.scrollView setHidden:NO];
        [self.scrollView setContentSize:CGSizeMake(320, 650)];
    }
}

@end
