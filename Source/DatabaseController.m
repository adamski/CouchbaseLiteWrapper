//
//  DatabaseController.m
//  CouchbaseLiteWrapper
//
//  Created by Adam Wilson on 22/03/2017.
//
//

#import <Foundation/Foundation.h>

#import <Couchbaselite/CouchbaseLite.h>

#import "DatabaseController.h"

@implementation DatabaseController
{
    //NSURL* remoteSyncURL;
    CBLReplication* _pull;
    CBLReplication* _push;
    NSError* _syncError;
}

@synthesize database;

- (id) initWithDbName: (NSString*) databaseName
{
    NSError* error;
    self = [super init];
    self.database = [[CBLManager sharedInstance] databaseNamed: databaseName error: &error];
    if (!self.database)
    {
        // Not sure if an exception is the best way to go but should do for now..
        [NSException raise:@"Couldn't open database" format:@"Database named %@ could not be opened: %@", databaseName, error];
    }
    return self;
}

- (id) initWithDbName: (NSString*) dbName andSarverDbURL: (NSString*) serverDbURL
{
    self = [self initWithDbName:dbName];
    if (self)
    {
        self.remoteSyncURL = [NSURL URLWithString:[serverDbURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        _pull = [database createPullReplication: self.remoteSyncURL];
        _push = [database createPushReplication: self.remoteSyncURL];
        _pull.continuous = _push.continuous = YES;
        // Observe replication progress changes, in both directions:
        NSNotificationCenter* nctr = [NSNotificationCenter defaultCenter];
        [nctr addObserver: self selector: @selector(replicationProgress:)
                     name: kCBLReplicationChangeNotification object: _pull];
        [nctr addObserver: self selector: @selector(replicationProgress:)
                     name: kCBLReplicationChangeNotification object: _push];
        [_push start];
        [_pull start];
    }
    return self;
}




@end
