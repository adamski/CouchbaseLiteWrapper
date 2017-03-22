//
//  DatabaseController.h
//  CouchbaseLiteWrapper
//
//  Created by Adam Wilson on 22/03/2017.
//
//

#ifndef DatabaseController_h
#define DatabaseController_h

@class CBLDatabase;

@interface DatabaseController: NSObject //<UIApplicationDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) CBLDatabase *database;
@property (nonatomic, strong) NSString *databaseName;
@property (nonatomic, strong) NSURL *remoteSyncURL;

//- (void)showAlert: (NSString*)message error: (NSError*)error fatal: (BOOL)fatal;

@end

#endif /* DatabaseController_h */
