//
//  CommunicationManager.h
//  BankingAppDemo
//

#import <Foundation/Foundation.h>
@import CloudKit;

@class CKQueryOperation;

@interface CommunicationManager : NSObject
{
    
}
typedef void (^FetchOperationSuccessBlock)(NSArray *fetchedItems);
typedef void (^OperationFailureBlock)(NSError *error);

+ (CommunicationManager*) sharedInstance;

-(void)queryItemsWithQueryString:(NSString*)queryString fromTable:(NSString*)tableName
                    onCompletion:(FetchOperationSuccessBlock)success
                    failureBlock:(OperationFailureBlock)failure;

- (void) updateItemWithRecored:(CKRecord*) record
                  onCompletion:(FetchOperationSuccessBlock)success
                  failureBlock:(OperationFailureBlock)failure;

- (void) addItemWithRecord:(CKRecord*) record
              onCompletion:(FetchOperationSuccessBlock)success
              failureBlock:(OperationFailureBlock)failure;

@end