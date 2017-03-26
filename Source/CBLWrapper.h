//
//  CBLWrapper.h
//  CouchbaseLiteWrapper
//
//  Created by Adam Wilson on 22/03/2017.
//
//

#ifndef CBLWrapper_h
#define CBLWrapper_h

#include "../JuceLibraryCode/JuceHeader.h"

namespace adamski
{
    struct CBLWrapperImpl;
    class CBLWrapper
    {
        CBLWrapperImpl* impl;
    public:
        CBLWrapper(String databaseName, String serverDbURL);
        ~CBLWrapper();
        String createDocument(String documentId = String::empty);
        Result updateDocument(String documentId, String jsonDocument);
    };
}
#endif /* CBLWrapper_h */
