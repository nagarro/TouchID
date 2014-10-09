//
//  UserDetail.h
//  BankingAppDemo
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UserDetail : NSObject

@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* deviceName;
@property (nonatomic, strong) NSString* systemName;
@property (nonatomic, strong) NSString* identifierForVendor;
@property (nonatomic, strong) NSString* credentialHashInfo;
@property (nonatomic, strong) NSString* deviceInfoHashInfo;

- (void) setCredentialHashOfUser;
- (void) setDeviceInfoHashOfUser;

@end
