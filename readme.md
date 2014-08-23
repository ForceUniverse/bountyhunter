## Bounty Hunter ##

A full text search engine of unstructured documents. It is base upon a reversed index.

### Simple usage ###

Construct an instance of Hunter.

	Hunter hunter = new Hunter( cargo );

Feed document into the system so it can be indexed.

	hunter.feedDoc( "hello world", "This is a hello world document ... fix");

Search for a document and retrieve the documents containing these words.

	hunter.search( "document fix" );

### Todo ###

- Ranking system.
- Possibility to add words that can be ignored, like stop words
- Stemming

### Contributing ###
 
If you found a bug, just create a new issue or even better fork and issue a
pull request with you fix.
