//
//  TouchIdManager.h
//  BankingAppDemo
//

#import <Foundation/Foundation.h>

@interface TouchIdManager : NSObject

typedef void (^TouchIdSuccessBlock)(void);
typedef void (^TouchIdFailureBlock)(NSError *error);

+ (TouchIdManager*) sharedInstance;
- (BOOL) checkForTouchIdAvailability;
- (void) evaluatePolicyWithCompletion:(TouchIdSuccessBlock)successBlock
                         failureBlock:(TouchIdFailureBlock)failureBlock;

@end
