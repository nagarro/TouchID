//
//  AppDelegate.h
//  BankingAppDemo
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) KeychainItemWrapper* keychainItem;


@end

