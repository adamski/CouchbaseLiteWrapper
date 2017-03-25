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
        void createDocument(String jsonDocument);
    };
}
#endif /* CBLWrapper_h */
