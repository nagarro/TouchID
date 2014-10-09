//
//  UserRegistrationManager.m
//  BankingAppDemo
//

#import "UserDetail.h"
#import "CommunicationManager.h"
#import "UserRegistrationManager.h"
#import "MacroUtilities.h"

@implementation UserRegistrationManager

kCreateSingleton(UserRegistrationManager);

-(void)registerUser:(UserDetail*)user
       onCompletion:(RegisterationSuccessBlock)success
       failureBlock:(RegisterationFailureBlock)failure
{
    CommunicationManager *manager = [CommunicationManager sharedInstance];
    CKRecord* record = [self createRecordItemForUser:user];
    [manager addItemWithRecord:record onCompletion:^(NSArray * resultArray)
     {
         if ([resultArray count]>0)
             success();
         
     }failureBlock:^(NSError * error)
     {
         failure(error);
     }];

}

-(void) checkUserCredential:(UserDetail*)user
               onCompletion:(RegisterationSuccessBlock)success
               failureBlock:(RegisterationFailureBlock)failure
{
    CommunicationManager *manager = [CommunicationManager sharedInstance];
    [manager queryItemsWithQueryString:[self createPredicateStringForQuery:user] fromTable:kUserRecordType onCompletion:^(NSArray * resultArray)
     {
         NSLog(@"Success");
         if([resultArray count]==0)
         {
             failure(nil);
         }
         else if([resultArray count] > 0)
         {
             success();
         }
     }
    failureBlock:^(NSError * error)
     {
         failure(error);
     }];
}

- (CKRecord*) createRecordItemForUser:(UserDetail*)user
{
    CKRecord* record = [[CKRecord alloc] initWithRecordType:kUserRecordType];
    record[kUser_UserName] = user.userName;
    record[kUser_Password] = user.password;
    record[kUser_SystemName] = user.systemName;
    record[kUser_DeviceName] = user.deviceName;
    record[kUser_IdentifierForVender] = user.identifierForVendor;
    record[kUser_CredentialHash] = user.credentialHashInfo;
    record[kUser_DeviceInfoHash] = user.deviceInfoHashInfo;
    
    return record;
}
     
- (NSString*) createPredicateStringForQuery:(UserDetail*) user
{
    return [NSString stringWithFormat:@"credentialHash = '%@' AND deviceInfoHash = '%@'",user.credentialHashInfo,user.deviceInfoHashInfo];
}

@end
