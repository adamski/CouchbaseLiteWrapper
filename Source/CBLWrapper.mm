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

namespace adamski
{
    struct CBLWrapperImpl
    {
        CBLDatabase* database;
        NSURL *remoteSyncURL;
        CBLReplication* pull;
        CBLReplication* push;
        NSError* syncError;
    };
    
    CBLWrapper::CBLWrapper(String databaseName, String serverDbURL) : impl (new CBLWrapperImpl)
    {
        NSError* error;
        NSString *dbName = [NSString stringWithUTF8String:databaseName.toUTF8()];
        

        impl->database = [[CBLManager sharedInstance] databaseNamed: dbName error: &error];
        if (!impl->database)
        {
            const char* errorMessage = [error.localizedDescription UTF8String];
            DBG ("Could not open database " << databaseName << ": " << errorMessage);
            // Not sure if an exception is the best way to go but should do for now..
            //[NSException raise:@"Couldn't open database" format:@"Database named %@ could not be opened: %@", databaseName, error];
        }
        
        if (serverDbURL.isNotEmpty())
        {
            NSString *serverDbURLString = [NSString stringWithUTF8String:serverDbURL.toUTF8()];
            impl->remoteSyncURL = [NSURL URLWithString:[serverDbURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            impl->pull = [impl->database createPullReplication: impl->remoteSyncURL];
            impl->push = [impl->database createPushReplication: impl->remoteSyncURL];
            impl->pull.continuous = impl->push.continuous = YES;
            
            // Observe replication progress changes, in both directions:
            NSNotificationCenter* nctr = [NSNotificationCenter defaultCenter];

            /** Original code from example:
            [nctr addObserver: this selector: @selector(replicationProgress:)
                         name: kCBLReplicationChangeNotification object: impl->pull];
            [nctr addObserver: this selector: @selector(replicationProgress:)
                         name: kCBLReplicationChangeNotification object: impl->push];
            */
            
            [nctr addObserverForName:kCBLReplicationChangeNotification object:impl->pull queue:nil
                          usingBlock: ^ (NSNotification * note)
            {
                // First check whether replication is currently active:
                BOOL active = (impl->pull.status == kCBLReplicationActive) || (impl->push.status == kCBLReplicationActive);

                /*
                self.activityIndicator.state = active;
                // Now show a progress indicator:
                self.progressBar.hidden = !active;
                 */
                if (active) {
                    double progress = 0.0;
                    double total = impl->push.changesCount + impl->pull.changesCount;
                    if (total > 0.0) {
                        progress = (impl->push.completedChangesCount + impl->pull.completedChangesCount) / total;
                    }
                    std::cout << "\r" << progress;
                    //self.progressBar.progress = progress;
                }

            }];

            [impl->push start];
            [impl->pull start];
        }
    }
    
    CBLWrapper::~CBLWrapper()
    {
        if (impl)
        {
            [impl->database release];
            [impl->pull release];
            [impl->push release];
            [impl->remoteSyncURL release];
            [impl->syncError release];
        }
        
        delete impl;
    }
    
    void CBLWrapper::createDocument(String jsonDocument)
    {
        NSError* jsonError;
        NSString* jsonNSString = [NSString stringWithUTF8String:jsonDocument.toUTF8()];
        NSData* objectData = [jsonNSString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* documentProperties = [NSJSONSerialization JSONObjectWithData:objectData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        CBLDocument* document = [impl->database createDocument];
        
        NSError* error;
        if (![document putProperties: documentProperties error: &error]) {
            const char* errorMessage = [error.localizedDescription UTF8String];
            DBG ("Could not save document: " << errorMessage);
        }
    }
}
