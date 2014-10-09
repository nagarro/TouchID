//
//  UserDetail.m
//  BankingAppDemo
//

#import "UserDetail.h"

@implementation UserDetail

- (id) init
{
    if (self = [super init])
    {
        UIDevice* device = [UIDevice currentDevice];
        self.deviceName = [device name];
        self.systemName = [device systemName];
        self.identifierForVendor = [[device identifierForVendor] UUIDString];
    }
    return self;
}

- (void) setCredentialHashOfUser
{
    NSUInteger credentialHash = [[NSString stringWithFormat:@"%@,%@", self.userName, self.password] hash];
    self.credentialHashInfo = [NSString stringWithFormat:@"%ld", (long)credentialHash];
}

- (void) setDeviceInfoHashOfUser
{
    NSUInteger deviceInfoHash = [[NSString stringWithFormat:@"%@,%@,%@", self.deviceName, self.systemName, self.identifierForVendor] hash];
    self.deviceInfoHashInfo = [NSString stringWithFormat:@"%ld", (long)deviceInfoHash];
}

@end
