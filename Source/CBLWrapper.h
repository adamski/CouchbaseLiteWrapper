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

class CBLWrapper
{
    CBLWrapper (String databaseName, String serverDbURL);
private:
    void* database;
};

#endif /* CBLWrapper_h */
