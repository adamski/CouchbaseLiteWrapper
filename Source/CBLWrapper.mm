//
//  CBLWrapper.m
//  CouchbaseLiteWrapper
//
//  Created by Adam Wilson on 22/03/2017.
//
//

#import <Foundation/Foundation.h>
#import <Couchbaselite/CouchbaseLite.h>

#include "CBLWrapper.h"

CBLWrapper::CBLWrapper (String databaseName, String serverDbURL)
{
    NSError* error;
    NSString* dbName = [NSString stringWithUTF8String: databaseName.toUTF8()];
    database = [[CBLManager sharedInstance] databaseNamed: dbName  error: &error];
}
