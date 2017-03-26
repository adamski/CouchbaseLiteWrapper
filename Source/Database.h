//
//  Database.h
//  CouchbaseLiteWrapper
//
//  Created by Adam Wilson on 22/03/2017.
//
//

#ifndef Database_h
#define Database_h

/** Note: https://github.com/couchbase/couchbase-lite-ios/wiki/JavaScript-Views
 */

#include "../JuceLibraryCode/JuceHeader.h"

namespace cbl
{
    struct DatabaseImpl;
    class Database
    {
        DatabaseImpl* impl;
    public:
        Database(String databaseName, String serverDbURL = String::empty);
        ~Database();
        String createDocument(String documentId = String::empty);
        Result updateDocument(String documentId, String jsonDocument);
        String readDocument(String documentId);
    };
}
#endif /* Database_h */
