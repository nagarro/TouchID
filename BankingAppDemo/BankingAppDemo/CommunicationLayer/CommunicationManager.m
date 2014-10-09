//
//  CommunicationManager.m
//  BankingAppDemo
//

#import <Foundation/Foundation.h>
#import "MacroUtilities.h"
#import "CommunicationManager.h"

@interface CommunicationManager ()

@property (readonly) CKContainer *container;
@property (readonly) CKDatabase *publicDatabase;

@end

@implementation CommunicationManager

kCreateSingleton(CommunicationManager);

-(void)initializeValues
{
    _container = [CKContainer defaultContainer];
    _publicDatabase = [_container publicCloudDatabase];
}

-(void)queryItemsWithQueryString:(NSString*)queryString fromTable:(NSString*)tableName
                    onCompletion:(FetchOperationSuccessBlock)success
                    failureBlock:(OperationFailureBlock)failure
{
    CKQuery *query = [[CKQuery alloc]initWithRecordType:tableName predicate:[NSPredicate predicateWithFormat:queryString]];
    
    CKQueryOperation *queryOperation = [[CKQueryOperation alloc] initWithQuery:query];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    queryOperation.recordFetchedBlock = ^(CKRecord *record) {
        [results addObject:record];
    };
    
    queryOperation.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
        
        if (error)
        {
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                failure(error);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                success(results);
            });
        }
    };
    [self.publicDatabase addOperation:queryOperation];
}

- (void) updateItemWithRecored:(CKRecord*) record
                  onCompletion:(FetchOperationSuccessBlock)success
                  failureBlock:(OperationFailureBlock)failure
{
    CKModifyRecordsOperation *modifyOperation = [[CKModifyRecordsOperation alloc]initWithRecordsToSave:[NSArray arrayWithObjects:record, nil] recordIDsToDelete:nil];
    modifyOperation.savePolicy = CKRecordSaveAllKeys;
    
    [modifyOperation setPerRecordProgressBlock:^(CKRecord *record, double progress) {
        
    }];
    
    [modifyOperation setPerRecordCompletionBlock:^(CKRecord *record, NSError *error) {
        
        if (error)
         {
             
             NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
         }
     }];
    
    [modifyOperation setModifyRecordsCompletionBlock:^(NSArray *savedRecords, NSArray *deleteRecordIds, NSError *error) {
        
         if (error)
         {
             NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                 failure(error);
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                 success(savedRecords);
            });
         }
     }];
    [self.publicDatabase addOperation:modifyOperation];
}


- (void) addItemWithRecord:(CKRecord*) record
              onCompletion:(FetchOperationSuccessBlock)success
              failureBlock:(OperationFailureBlock)failure
{
    [self.publicDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
        
        if (error)
        {
            // In your app, handle this error like a pro.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
            dispatch_async(dispatch_get_main_queue(), ^(void){
                failure(error);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                NSArray* array = [[NSArray alloc] initWithObjects:record, nil];
                success(array);
            });
        }
    }];
}

@end