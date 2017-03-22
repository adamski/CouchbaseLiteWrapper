//
//  CBLWrapper.m
//  CouchbaseLiteWrapper
//
//  Created by Adam Wilson on 22/03/2017.
//
//

#import <Foundation/Foundation.h>
#import <Couchbaselite/CouchbaseLite.h>
#import "DatabaseController.h"

#include "CBLWrapper.h"

CBLWrapper::CBLWrapper (String databaseName, String serverDbURL)
{
    NSString* dbName = [NSString stringWithUTF8String: databaseName.toUTF8()];
    NSString* dbURL = [NSString stringWithUTF8String: databaseName.toUTF8()];
    
    @try
    {
        databaseController = [[DatabaseController alloc] initWithDbName:dbName andServerDbURL:dbURL];
    }
    @catch (NSException* exception)
    {
        DBG ([[exception reason] UTF8String]);
    }
    
}
