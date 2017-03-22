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
    NSURL* remoteSyncURL;
    CBLReplication* _pull;
    CBLReplication* _push;
    NSError* _syncError;
}

@synthesize database;


@end
