ios-fts-demo
============

iOS Client Side Offline Fulltext Search for Assets

This Project uses the [sqlite FTS](http://www.sqlite.org/fts3.html) features to provide a simple and fast way to search through the Assets (HTML, XML, PDF, JSON, ...) on your iOS device.
The goal is to make it as easy as possible to integrate the functionality into your Projects.
- Straightfoward Project integration
- Easy to use Interface
- Possibility to configure and extend functionality

Want to add a new Document to the index that should be available for the search?
    
    -(void)addDocument:(NSURL *)documentPath;

that returns via delegate
    
    -(void)ftsDocumentAction:(FTSAddDocumentAction *)action didAddDocument:(NSURL *)pathToDocument;


Want to find a Document?

    -(void)findDocuments:(NSString *)searchText;

that returns via delegate

    -(void)ftsDocumentAction:(FTSFindDocumentAction *)action didFindDocuments:(NSArray *)documentPaths forSearch:(NSString *)query;


It is as easy as that!


--------------------------

##<a id="run-demo" name="run-demo"></a>Run the Demo

After getting the source code, the first thing you should do, is to install the Pods.
New to CocoaPods? Install CocoaPods from [cocoapods](http://guides.cocoapods.org/using/getting-started.html)

Switch into the project root and install the Pods.

    pod install

When the Pods are successfully installed, use only the *.xcworkspace to open the project in Xcode.
Now you are ready to run the project.

--------------------------

##<a id="embed-into-project" name="embed-into-project"></a>Embed the Fulltext Search into your Project

1. Copy everything within the FTS folder into your Project (simply every Class with the **FTS** Prefix)
2. Add Cocoapods Dependencies. Currently:
  - pod 'FMDB', '2.3'
  - pod 'hpple', '0.2.0'
3. Use it as described in the following chapter

--------------------------

##<a id="how-to-use" name="how-to-use"></a>How to use it

**Access the complete functional range via the FTSDocumentHandler**

Instantiate a Singleton of **FTSDocumentHandler** and you are ready to go crazy. Notice that you have to pass a delegate.
All the calls are asynchronous that will give feedback via their delegate callbacks.

    FTSDocumentHandler *documentHandler = [FTSDocumentHandler sharedFTSDocumentHandlerWithDelegate:self];

With a working instance of FTSDocumentHandler you can add (or update), delete and find Documents (Assets) on you iOS Device.
Examples:
Adding a Document

    NSURL* documentUrl = [[NSBundle mainBundle] URLForResource:@"myFilename" withExtension:@"txt"];
    [documentHandler addDocument:documentUrl];

and finding it by searching for content

    [documentHandler findDocuments:@"I am your father"];

When searching, each word separated by a space will be searched independently. So the order of the typed words doesn't matter.
Additionally after every word a wildcard (*) will be added. That means a search for "tra sal" will match for example
- travelling salesman
- salesman travelling
- a weary salesman that likes to travel

**Centralised Configuration**

Within the context of **FTSConstants** all configurable options are available at one place.
All SQL Queries and further Configurations can be adapted here if needed.

--------------------------

##<a id="dependencies" name="dependencies"></a>Cocoapods Dependencies

<img src="/documentation/fts_cocoa_dependencies.png?raw=true">

--------------------------

##<a id="under-the-hood" name="under-the-hood"></a>Under the Hood

**How it works**

- **FTSDocumentHandler**
  is the entry point for the use of the fulltext search. With the help of the FTSActions (FTSAddDocumentAction, FTSRemoveDocumentAction, FTSFindDocumentAction) it has complete access to all the needed operations on the document index. The delegate that can be passed will be forwarded to the specific actions, so the callback via delegate can be handled properly because all calls are asynchronous.
- **FTSAddDocumentAction**
  adds or updates (if the document is already part of the index) the content of a document to the index. The content (including the metadata like filetype) will be parsed and extracted by the Extractor construct. It will notify the delegate if the operation was completed successfully or not.
- **FTSContentExtractor**
  provides the ability to parse documents and extract the content and the metadata. Thanks to its subclasses, the following file formats can successfully processed:
    PDF
    XML
    HTML
    JSON
    Plaintext
  If a certain file format is unknown, it will be treated as plaintext.
- **FTSRemoveDocumentAction**
  removes an existing document from the index and notifies the delegate if the operation was completed successfully or not.
- **FTSFindDocumentAction**
  takes the search input and generates a database query. All found documents will be returned to the delegate.
- **FTSQueryProcessor**
  gives us the ability to process / enhance the search input before the database query will be generated. The Default behaviour is, that after each word (separated by space) the wildcard character '*' will be added.
- **FTSDatabaseHandler**
  provides basic database funtionality such as setting up the db queue and locks.

**Restrictions**

Currently the content extraction regarding PDF is very minimalistic and simple. This approach has been chosen to avoid a dependency
on a big fat PDF Library from which only one small functionality would be used (Text parsing / extraction). But it seems inevitable as a next step. Latex generated documents for example have currently no chance to be indexed correctly at all.

**Class Diagram**

<img src="/documentation/fts_class_diagram.png?raw=true">

--------------------------

##<a id="next-steps" name="next-steps"></a>Next Steps

- Turn into a Cocoapod
- Heavy Refactoring for Facets
- Add reliable PDF content extraction