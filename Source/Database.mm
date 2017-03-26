//
//  Database.mm
//  CouchbaseLiteWrapper
//
//  Created by Adam Wilson on 22/03/2017.
//
//

#import <Foundation/Foundation.h>
#import <Couchbaselite/CouchbaseLite.h>

#include "Database.h"
#include <iostream>

namespace cbl {
    struct DatabaseImpl {
        CBLDatabase *database;

        NSURL *remoteSyncURL;
        CBLReplication *pull;
        CBLReplication *push;
        NSError *syncError;
    };

    Database::Database(std::string databaseName, std::string serverDbURL /* = "" */) : impl(new DatabaseImpl) {
        NSError *error;
        NSString *dbName = [NSString stringWithUTF8String:databaseName.c_str()];


        impl->database = [[CBLManager sharedInstance] databaseNamed:dbName error:&error];
        if (!impl->database) {
            const char *errorMessage = [error.localizedDescription UTF8String];
            std::cerr << "Could not open database " << databaseName << ": " << errorMessage;

            // Not sure if an exception is the best way to go but might do for now..
            //[NSException raise:@"Couldn't open database" format:@"Database named %@ could not be opened: %@", databaseName, error];
        }

        if (! serverDbURL.empty()) {
            NSString *serverDbURLString = [NSString stringWithUTF8String:serverDbURL.c_str()];
            impl->remoteSyncURL = [NSURL URLWithString:[serverDbURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

            impl->pull = [impl->database createPullReplication:impl->remoteSyncURL];
            impl->push = [impl->database createPushReplication:impl->remoteSyncURL];
            impl->pull.continuous = impl->push.continuous = YES;

            // Observe replication progress changes, in both directions:
            NSNotificationCenter *nctr = [NSNotificationCenter defaultCenter];

            /** Original code from example:
            [nctr addObserver: this selector: @selector(replicationProgress:)
                         name: kCBLReplicationChangeNotification object: impl->pull];
            [nctr addObserver: this selector: @selector(replicationProgress:)
                         name: kCBLReplicationChangeNotification object: impl->push];
            */

            [nctr addObserverForName:kCBLReplicationChangeNotification object:impl->pull queue:nil
                          usingBlock:^(NSNotification *note) {
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

    Database::~Database() {
        if (impl) {
            [impl->database release];

            [impl->remoteSyncURL release];
            [impl->pull release];
            [impl->push release];
            [impl->syncError release];
        }

        delete impl;
    }

    std::string Database::createDocument(std::string documentId /* = "" */) {
        CBLDocument *document = [impl->database createDocument];
        return std::string([[document documentID] UTF8String]);
    }

    // Return _revID as part of tuple?
    std::pair<bool, std::string> Database::updateDocument(std::string documentId, std::string jsonDocument) {
        NSString *docId = [NSString stringWithUTF8String:documentId.c_str()];
        CBLDocument *document = [impl->database documentWithID:docId];

        NSError *jsonError;
        NSString *jsonNSString = [NSString stringWithUTF8String:jsonDocument.c_str()];
        NSData *objectData = [jsonNSString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *documentProperties = [NSJSONSerialization JSONObjectWithData:objectData
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&jsonError];
        NSError *error;
        if (![document putProperties:documentProperties error:&error]) {
            const char *errorMessage = [error.localizedDescription UTF8String];
            std::cerr << "Could not save document: " << errorMessage;
            return {false, errorMessage};
        }

        return {true, ""};
    }
    
    
}
