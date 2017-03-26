//
//  Database.h
//  CouchbaseLiteWrapper
//
//  Created by Adam Wilson on 22/03/2017.
//
//

#ifndef Database_h
#define Database_h

#include <string>

/** Note: https://github.com/couchbase/couchbase-lite-ios/wiki/JavaScript-Views
 */

namespace cbl
{
    struct DatabaseImpl;
    class Database
    {
        DatabaseImpl* impl;
    public:
        Database(std::string databaseName, std::string serverDbURL = "");
        ~Database();
        std::string createDocument(std::string documentId = "");
        std::pair<bool,std::string> updateDocument(std::string documentId, std::string jsonDocument);
        std::string readDocument(std::string documentId);
    };
}
#endif /* Database_h */
