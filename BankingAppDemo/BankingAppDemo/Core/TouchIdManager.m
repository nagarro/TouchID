//
//  TouchIdManager.m
//  BankingAppDemo
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "MacroUtilities.h"
#import "TouchIdManager.h"

@implementation TouchIdManager

kCreateSingleton(TouchIdManager)

- (BOOL) checkForTouchIdAvailability
{
    LAContext* context = [[LAContext alloc] init];
    return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
}

- (void) evaluatePolicyWithCompletion:(TouchIdSuccessBlock)successBlock
                         failureBlock:(TouchIdFailureBlock)failureBlock
{
    LAContext *context = [[LAContext alloc] init];
    [context setLocalizedFallbackTitle:LocalizedString(kEmpty_Alert_Title)];
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:LocalizedString(kTouchId_Message) reply:
     ^(BOOL success, NSError *authenticationError) {
         
         dispatch_async(dispatch_get_main_queue(), ^(void) {
             
             if (success)
             {
                 successBlock();
             }
             else
             {
                 failureBlock(authenticationError);
             }
         });
     }];
}

@end
