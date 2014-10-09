//
//  MacroUtilities.h
//  BankingAppDemo
//

#ifndef ET_MacroUtilities_h
#define ET_MacroUtilities_h

// For creating singleton classes

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define kDefineSingleton(className) \
+ (id) sharedInstance;

#define kCreateSingleton(className) \
/* initialize sharedManager as nil (first call only) */ \
__strong static id sharedManager = nil; \
static dispatch_queue_t serialQueue; \
\
+ (id) sharedInstance \
{ /* structure used to test whether the block has completed or not */\
	static dispatch_once_t onceQueue; \
	dispatch_once(&onceQueue, ^{ \
		sharedManager = [[self alloc] init]; \
	}); \
	return sharedManager; \
} \
\
+ (id)allocWithZone:(NSZone *)zone { \
	static dispatch_once_t onceQueue; \
	\
	dispatch_once(&onceQueue, ^{ \
		serialQueue = dispatch_queue_create("com.nagarro.BankingAppDemo", NULL); \
		if (sharedManager == nil) { \
			sharedManager = [super allocWithZone:zone]; \
		} \
	}); \
	\
	return sharedManager;\
} \
\
- (id)init {\
id __block obj;\
\
dispatch_sync(serialQueue, ^{\
obj = [super init];\
if (obj) {\
if([self respondsToSelector:@selector(initializeValues)])\
{\
[self performSelector:@selector(initializeValues)];\
}\
}\
});\
\
self = obj;\
return self;\
}

#define LocalizedString(key) NSLocalizedString(key, key)
#define LocalizedKeyValueString(key, prefix) LocalizedString(([NSString stringWithFormat:@"%@_%@",prefix, key]))

#endif
