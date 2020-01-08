# canonical-greekLit

Development is happening over at
[damos](https://damos.fruitopology.net/agoragreekLit). This
is just a mirror.

## setup
The repository includes the canonical greekLit collection from perseus
as a submodule so before you proceed with any parsing/indexing please
init/update the submodule:

```
git submodule update --init
```

# Elasticsearch Indexing

We parse the works of prose as follows:

We separate indexing of books, lines and words. What this means is that the table containing all the words of the work is separate from the table containing all the lines and separate from the table containing the whole book content as 1 entry. This gives us the appropriate flexibility to search through and produce analytics in different areas.

Let take homer's odyssey as an example:
The generic index pattern for the whole book would be corpus-ancient-greek-homer-odyssey-book
The generic index pattern for the odyssey's lines would be corpus-ancient-greek-homer-odyssey-line
The generic index pattern for the odyssey's words would be corpus-ancient-greek-homer-odyssey-word

Say for example you want to search for a specific passage in the odyssey, i.e. multiple lines, you can use the `corpus-ancient-greek-homer-odyssey-book` index.
Say as an another example you want to render the whole book, line by line for reading in an application, you would use the `corpus-ancient-greek-homer-odyssey-line` index.
Lastly, you can use the `corpus-ancient-greek-homer-odyssey-word` index to start conducting various statistics, like word-clouds on each book of the odyssey. Or you could render the book, line by line for reading it in an application using the `corpus-ancient-greek-homer-odyssey-line` index, but then when a user hovers over the words in the app, use the `corpus-ancient-greek-homer-odyssey-word` index to start providing the appropriate context for that word.

## The schemas for each index type

### book
```
{
	type: "book",
	author: The author's name in english,
	title: The work's title in english,
	author_grc: The author's name in ancient greek, 
	title_grc: The work's title in ancient greek,
	name: The books name (Some books have them some don't, in case not it would be the books number as a string, i.e. book one,
	number: The number of the book
}
```
### line
```
{
	type: "line",
	author: The author's name in english,
	title: The work's title in english,
	author_grc: The author's name in ancient greek, 
	title_grc: The work's title in ancient greek,
	number: The number of the line,
	book: The number of the book the line is in,
	content: The contents of the line,
	content_stripped: The contents of the lines, stripped of diacritics
}
```
### word
```
{
	type: "word",
	author: The author's name in english,
	title: The work's title in english,
	author_grc: The author's name in ancient greek, 
	title_grc: The work's title in ancient greek,
	content: The word itself,
	content_stripped: The word itself, stripped of diacritics,
	number: The index of the word within the line,
	book: The number of the book,
	book: The number of the line the word is in
}
```

# Rake tasks

You can index and print the books running rake tasks. Run `rake -T` to see the available rake tasks.

For example to print out homer's odyssey book 1, you can run:

`rake homer:print_book[odyssey,1]` or,

`rake homer:print_book[iliad,4]`





TODO:

- move on to generalize the parser to all authors of prose
- move on to include different categories of text
- add syllable indexing support
- add index templating
- add elasticsearch language support
- add elasticsearch stopword support for ancient-greek