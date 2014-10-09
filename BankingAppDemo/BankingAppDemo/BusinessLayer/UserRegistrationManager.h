//
//  UserRegistrationManager.h
//  BankingAppDemo
//

#import <Foundation/Foundation.h>

@class UserDetail;
@interface UserRegistrationManager : NSObject

typedef void (^RegisterationSuccessBlock)(void);
typedef void (^RegisterationFailureBlock)(NSError *error);

+ (UserRegistrationManager*) sharedInstance;

- (void)registerUser:(UserDetail*)user
        onCompletion:(RegisterationSuccessBlock)success
        failureBlock:(RegisterationFailureBlock)failure;

- (void) checkUserCredential:(UserDetail*)user
                onCompletion:(RegisterationSuccessBlock)success
                failureBlock:(RegisterationFailureBlock)failure;

@end