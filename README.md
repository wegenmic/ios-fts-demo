ios-fts-demo
============

iOS Client Side Offline Fulltext Search for Assets

This Project uses the sqlite FTS features to provide a simple and fast way to search through the Assets (HTML, XML, PDF, JSON, ...) on your iOS device.
The goal is to make it as easy as possible to integrate the functionality into your Projects.
- Straightfoward Project integration
- Easy to use Interface
- Possibility to configure and extend functionality

Want to add a new Document to the index that should be search?
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

- Copy everything within the FTS folder into your Project (simply every Class with the 'FTS' Prefix)
- Add Cocoapods Dependencies. Currently:
    pod 'FMDB', '2.3'
    pod 'sqlite3', '3.8.4.3'
    pod 'hpple', '0.2.0'
- Use it as described in the following chapter

--------------------------

##<a id="how-to-use" name="how-to-use"></a>How to use it

- Centralised Configuration -> FTS Constants

--------------------------

##<a id="dependencies" name="dependencies"></a>Dependenies

Visual Dependencies on Cocoapods

--------------------------

##<a id="under-the-hood" name="under-the-hood"></a>Under the Hood

- Features
- How it works
- Class Diagram