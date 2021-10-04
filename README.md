# context-sbl
Society of Biblical Literature (SBL) style files for ConTeXt

## About This Project

I initially began developing this bibliography rendering for my own use, but since the SBL citation style is commonly used in the humanities (particularly in religious studies), I felt that a full implementation for the ConTeXt typesetting system would be of value for other users. Thankfully, David Purton had already put together a thorough implementation of this citation style for LaTeX (https://github.com/dcpurton/biblatex-sbl), so I was able to use his category definitions as starting points instead of reinventing the wheel. At the same time, since I had to build the `.lua` and `.mkvi` files mostly from scratch, I took advantage of opportunities to simplify certain implementation details. I will summarize the changes I made below.

### Structure of the Bibliographic Database

In my opinion, one of the most useful innovations of the `biblatex` package (which Purton generally uses to good effect in `biblatex-sbl`) is its use of cross-references between BibTeX entries. This feature allows us to simplify the pool of fields used by different categories, modularize the structures of categories, and reduce redundancy of common higher-level references. In short, it allows (and encourages) users to structure their `.bib` files more like actual databases. I decided to implement this feature more generally and (for now) more strictly, eliminating the `book*`, `main*`, and `revd*` fields in favor of values in the `crossref` or `xref` fields. This is intended to be compatible with the `biblatex` cross-referencing convention, although (again) it is a bit stricter, as it does not work with entries that directly use the `book*`, `main*`, and `revd*` fields. Even separate `@journal` and `@series` entries are supported and can be cross-referenced with the `journalxref` and `seriesxref` fields (but the traditional `journal`, `shortjournal`, `series`, and `shortseries` fields are still supported).

Since some of the entry types that Purton adds on top of the basic `biblatex` types are functionally identical, I collapsed some of them to more common `biblatex` categories where this was feasible. My aim was to introduce as few new categories as possible so as to maximize compatibility with bibliographic databases already intended for use with `biblatex`. A brief summary of each category, starting from the top-level categories and working our way down, follows:

- `@series`: A set of books, including multivolume collections published by the editor, such as Migne's _Patrologia Graeca_ or _Patrologia Latina_ (§6.4.6). The only required field is `title` (although a `shorthand` will be used instead if it is also provided).
- `@journal`: A journal. The only required field is `title` (although a `shorthand` will be used instead if it is also provided). This category is structurally identical to `@series`, but their typeset representations are different. (A journal's title is italicized, while a series's title is not.)
- `@mvbook`: A multivolume work (_SBLHS_ §6.2.20) with the same author(s) or editor(s). Required fields are `author` (either a proper author or an editor), `title`, and `publisher`. The `volumes` and `parts` fields are allowed, but not required, as they may not be available for works in progress. If the work corresponds to multiple entries in a series, then this can be indicated by cross-referencing the `@series` entry in the `seriesxref` field or by repeating its title or shorthand in the `series` and `shortseries` fields.
- `@mvreference`: A multivolume encyclopedia or dictionary (§6.3.6.2), a multivolume commentary (§6.4.10), or a multivolume lexicon (§7.2) with the same author(s) or editor(s). In the SBL specification, this is functionally just an alias of `@mvbook`. Purton's `@mvcommentary` and `@mvlexicon` categories are collapsed into this one (though they can still be distinguished with the `entrysubtype` field).
- `@mvcollection`: A multivolume collection of contributions by different authors (§6.2.21-22) overseen by the same editor(s). Required fields are `author` (which in this case is just an alias for `editor`), `title`, and `publisher`. Apart from its required fields, this is functionally just an alias of `@mvbook`.
- `@mvproceedings`: A multivolume collection of published conference proceedings (§6.4.11). Required fields are `author` (either an editor or an organization), `title`, and `publisher`. Apart from its required fields, this is functionally just an alias of `@mvbook`.
- `@book`: A single-volume book, or a titled or untitled volume in a multivolume work (§6.2). Required fields are `author` (either a proper author or an editor), `title` or both `crossref`/`xref` and `volume`, and `publisher`. If the work corresponds to an entry in a series, then this can be indicated by cross-referencing the `@series` entry in the `seriesxref` field or by repeating its title or shorthand in the `series` and `shortseries` fields.
- `@reference`:  A single-volume encyclopedia or dictionary (§6.3.6.1), commentary (§6.4.9), or lexicon (§7.1). In the SBL specification, this is functionally just an alias of `@book`. Purton's `@commentary` and `@lexicon` categories are collapsed into this one (though they can still be distinguished with the `entrysubtype` field).
- `@collection`: A single-volume collection of contributions by different authors (§6.2.21-22) overseen by the same editor(s). Required fields are `author` (which in this case is just an alias for `editor`), `title`, and `publisher`. Apart from its required fields, this is functionally just an alias of `@book`.
- `@proceedings`: A single-volume collection of published conference proceedings (§6.4.11). Required fields are `author` (either an editor or an organization), `title`, and `publisher`. Apart from its required fields, this is functionally just an alias of `@book`.
- `@manual`: A manual (§7.3). Identical to `@book`, except that the `author` field is optional, and it can consist of an author, editor, or organization.
- `@inbook`: A article or chapter in a book, presumably by the same author of the entire book (although this is not required), identified by an explicit page range. Required fields are `author` (referring to author or the article or chapter), `title`, either `crossref` or `xref` (consisting of the entry tag for the book or volume containing this work), and `pages` (containing the page range for this work in the book or volume).
- `@inreference`: An article in an encyclopaedia or a dictionary (§6.3.6.1-2), an article in a lexicon (§6.3.7), an article or note in a study Bible (§6.4.9.1), or an article in a commentary on the entire Bible (§6.4.9.2, 6.4.10.2). Structurally identical to `@inbook`, but their typesetting rules are slightly different. Purton's `@incommentary`, and `@inlexicon` categories are collapsed into this one (though they can still be distinguished with the `entrysubtype` field).
- `@incollection`: A article or chapter in an edited volume (§6.2.12-13, 6.2.22-23). Structurally identical to `@inbook`, but the cross-reference in the `crossref` or `xref` field should point to a `@collection` entry. (This is not checked, though, so functionally this category is the same as `@inbook`.)
- `@inproceedings`: A paper published as part of a conference proceedings, including seminar papers (§6.4.11). Structurally identical to `@inbook`, but the cross-reference in the `crossref` or `xref` field should point to a `@proceedings` entry. (This is not checked, though, so functionally this category is the same as `@inbook`.) This category encapsulates Purton's `@seminarpaper` category.
- `@suppbook`: A named section of a book (e.g., introduction, preface, foreword) written by someone other than the author (§6.2.14). Required fields are `author` (referring to a proper author), `type` (containing a string like "introduction", "preface", or "foreword"), and either `crossref` or `xref` (consisting of the entry tag for the book or volume containing this work).
- `@ancienttext`: A text from the Ancient Near East (or anywhere, really; §6.4.1) or a papyrus or ostracon (§6.4.3). The only required field is `title`. If known, an author can be specified in the optional `author` field. Optionally, a volume or single-volume book reproducing and/or translating the text can be cross-referenced with the `crossref` or `xref` field, respectively. Entry subtypes like `PGM` (Magical Greek papyri entries), `inscription`, `chronicle`, and `manuscript` that require special typesetting are supported.
- `@classictext`: A classical text (§6.4.2), or an ancient work by a church father (§6.4.4-6). The only required field is `title`. If known, an author can be specified in the optional `author` field. Optionally, a multivolume set or single-volume book reproducing and/or translating the text can be cross-referenced with the `crossref` or `xref` field. If the text is published in a series (such as Migne's PG or PL) instead, then the series can be cross-referenced in the `seriesxref` field or in the `series` or `shortseries` field with the `type = {useseriesshorthand}` field. (**TODO**: This mechanism may be changed or least rewritten as an `options` field.)
- `@article`: An article from a journal (§6.3) or a magazine (§6.3.9). Required fields are `author` (referring to a proper author), `title`, and either `journalxref` (for a cross-reference to the appropriate `@journal` entry) or `journal` or `shortjournal` (for a reference to the journal's name or shorthand). Typically, the `volume` (and sometimes `number`), `date`, and `pages` fields will accompany the journal cross-reference, but they are not required.
- `@review`: A book review published in a journal (§6.3.4). Required fields are `author` (referring to the author of the review), either `crossref` or `xref` (cross-referencing the reviewed book), and at least one of `journalxref` (for a cross-reference to the appropriate `@journal` entry), `journal`, or `shortjournal` (for a reference to the journal's name or shorthand). If the review itself has a title, then this can be included in the `title` field. Typically,  the `volume` (and sometimes `number`), `date`, and `pages` fields will accompany the journal cross-reference, but they are not required.
- `@conferencepaper`: A paper presented at a professional society, but not published (§6.3.8). Required fields are `author` (referring to a proper author), `title`, and `conference` (the title of the conference). Typically, the `location` and `date` fields will accompany the `conference` field, but they are not required.
- `@thesis`: An unpublished dissertation or thesis (§6.3.5). Required fields are `author` (referring to a proper author), `title`, `institution` (the name of the school where the thesis was undertaken), and `type` (assumed to be the name of another thesis category, like "mastersthesis" or "phdthesis"). Typically, the `date` field will accompany the `institution` field, but they are not required.
- `@mastersthesis`: An unpublished Master's thesis (§6.3.5). Identical to `@thesis` with `type=mastersthesis`.
- `@phdthesis`: An unpublished PhD dissertation (§6.3.5). Identical to `@thesis` with `type=phdthesis`.
- `@online`: A document published online with no print counterpart (§6.4.13), an online database (§6.4.14), or a website or blog entry (§6.4.15). The only required field is `title`, although typically `doi` or `url` is included.

Other basic `biblatex` entry types, such as `@unpublished`, `@electronic`, and `@misc`, are also supported, although they should only be used if the entry does not fit into a more specific category. A relational diagram between the categories is shown below.

![Relational diagram of entry categories in SBL rendering](https://github.com/jjmccollum/context-sbl/blob/main/img/relational-diagram.png)

In the diagram above, solid lines indicate required cross-reference relationships (although in most cases, only one such relationship, if any, is required), and dashed lines indicate optional cross-reference relationships. Additional relationships can be encoded in the `related` field, such as reprints (`relatedtype = {reprintof}`) and translations (`relatedtype = {translationof}`); for the sake of space, these are not illustrated here. (For an example of both, see §6.2.5.)

### Citation Alternatives

Given the hierarchical structure just described, it is natural to handle citations of lower-level entries that cross-reference higher-level entries recursively on the ConTeXt side. Because SBL formats bibliographic list entries, long- and short-form inline citations, subcitations in list entries, and subcitations in inline citations all slightly differently, I chose to develop multiple citation alternatives for the rendering:
- `list` (or `entry`, if you want to reproduce it inline): variant for bibliographic list entries. Authors (or editors, if an entry has no authors) are printed before titles, with the first author's name in inverted order (i.e., last name first). Most fields are separated by periods and capitalized accordingly.
- `listsubcite`: variant for subcitations in bibliographic list entries. Titles are printed before authors, and authors are all printed in normal order (i.e., first name first). Most fields are separated by periods and capitalized accordingly. If the root citation includes publication information, then the subcitation typically will not do the same. This variant also coincides with the style of full-form citations in the bibliographic abbreviations list.
- `inline`: variant for initial citations of entries in the text. Authors (or editors, if an entry has no authors) are printed before titles in normal order. Most fields are separated by commas, and publisher, institution, conference, etc. blocks are parenthesized.
- `inlinesubcite`: variant for subcitations of `inline` citations. Titles are printed before authors, and authors are all printed in normal order. Most fields are separated by commas, and publisher, institution, conference, etc. blocks are parenthesized. If the root citation includes publication information, then the subcitation typically will not do the same.
- `short`: variant for short-form citations (usually the default after the initial citation of an entry). If an entry has a `shorthand`, then that will be used. Failing that, if it has a `shorttitle` field, then that will be used (usually preceded by the author/editor, if there is one). Otherwise, the full `title` field will be used (usually preceded by the author/editor, if there is one). This overwrites the existing implementation of the `short` alternative in ConTeXt, which normally cites the list number of the entry in brackets. (This should be okay, since, to my knowledge, SBL style never cites sources this way.)
- `volume`: variant for citing just the `volume` field (and `part` field, if there is one) of an entry. This was developed mostly for my convenience, since the output of this citation often prefixes page numbers for entries that are volumes in a collection.

### Special Formatting Rules

While I have tried to account for all cases in the examples using only category-based rules as much as possible, there are some types of entries within certain categories that need to be typeset slightly differently. These special `type` values are detailed below. (**TODO**: These will likely be changed to values for the `options` field, in accordance with `biblatex` conventions. Like everything else, they are subject to change as I continue to work through the issues for this project.)

| `type` value  | Description | Example(s) |
| --- | --- | --- |
| `seriesascollection`  | In short-form citations, the series to which this entry belongs should be cited as if it were a collection containing it.  | Volumes of RIMA (§6.4.1.2) and texts in Migne's PG and PL series | 
| `useseriesshorthand`  | In short-form citations, use the shorthand of the series to which this entry belongs as if it were this entry's shorthand.  | Volumes of ARM and ARMT (§6.4.1.2) and entries in the Loeb Classical Library series (§6.4.2) | 
| `plainshorthand`  | In short-form citations, do not typeset this entry's shorthand using the style associated with its category; instead, typeset it as plain text.  | Papyri and ostraca (§6.4.1.2) and works commonly abbreviated by the names of their authors (§6.4.7, 7.1) |

## Specification Coverage

The following cases (taken from https://github.com/dcpurton/biblatex-sbl/blob/master/test/biblatex-sbl-examples.ref.txt) should be covered by this rendering:

6.2 General Examples: Books

- [x] 6.2.1 A Book by a Single Author
- [x] 6.2.2 A Book by Two or Three Authors
- [x] 6.2.3 A Book by More than Three Authors
- [x] 6.2.4 A Translated Volume
- [x] 6.2.5 The Full History of a Translated Volume
- [x] 6.2.6 A Book with One Editor
- [x] 6.2.7 A Book with Two or Three Editors
- [x] 6.2.8 A Book with Four or More Editors
- [x] 6.2.9 A Book with Both Author and Editor
- [x] 6.2.10 A Book with Author, Editor, and Translator
- [x] 6.2.11 A Title in a Modern Work Citing a Nonroman Alphabet
- [x] 6.2.12 An Article in an Edited Volume
- [x] 6.2.13 An Article in a Festschrift
- [x] 6.2.14 An Introduction, Preface, or Foreword Written by Someone Other Than the Author
- [x] 6.2.15 Multiple Publishers for a Single Book
- [x] 6.2.16 A Revised Edition
- [x] 6.2.17 A Recent Reprint Title
- [x] 6.2.18 A Reprint Title in the Public Domain
- [x] 6.2.19 A Forthcoming Book
- [x] 6.2.20 A Multivolume Work
- [x] 6.2.21 A Titled Volume in a Multivolume, Edited Work
- [x] 6.2.22 A Chapter within a Multivolume Work
- [x] 6.2.23 A Chapter within a Titled Volume in a Multivolume Work
- [x] 6.2.24 A Work in a Series
- [x] 6.2.25 Electronic Book

6.3 General Examples: Journal Articles, Reviews, and Dissertations

- [x] 6.3.1 A Journal Article
- [x] 6.3.2 A Journal Article with Multiple Page Locations and Volumes
- [x] 6.3.3 A Journal Article Republished in a Collected Volume
- [x] 6.3.4 A Book Review
- [x] 6.3.5 An Unpublished Dissertation or Thesis
- [x] 6.3.6.1 An Article in a Multivolume Encyclopaedia or Dictionary
- [x] 6.3.6.2 An Article in a Single-Volume Encyclopaedia or Dictionary
- [x] 6.3.7 An Article in a Lexicon or Theological Dictionary
- [x] 6.3.8 A Paper Presented at a Professional Society
- [x] 6.3.9 An Article in a Magazine
- [x] 6.3.10 An Electronic Journal Article

6.4 Special Examples

- [x] 6.4.1.1 Citing COS
- [x] 6.4.1.2 Citing Other Texts
- [x] 6.4.2 Loeb Classical Library (Greek and Latin)
- [x] 6.4.3.1 Papyri and Ostraca in General
- [x] 6.4.3.2 Epigraphica
- [x] 6.4.3.3 Greek Magical Papyri
- [x] 6.4.4 Ancient Epistles and Homilies
- [x] 6.4.5 ANF and NPNF, First and Second Series
- [x] 6.4.6 J.-P. Migne's Patrologia Latina and Patrologia Graeca
- [x] 6.4.7 Strack-Billerbeck, Kommentar zum Neuen Testament
- [x] 6.4.8 Aufstieg und Niedergang der römischen Welt (ANRW)
- [x] 6.4.9 Bible Commentaries
- [x] 6.4.9.1 Articles and Notes in Study Bibles
- [x] 6.4.9.2 Single-Volume Commentaries on the Entire Bible
- [x] 6.4.10.1 Multivolume Commentaries on a Single Biblical Book by One Author
- [x] 6.4.10.2 Multivolume Commentaries for the Entire Bible by Multiple Authors
- [x] 6.4.11 SBL Seminar Papers
- [x] 6.4.12 A CD-ROM Reference (with a Corresponding Print Edition)
- [x] 6.4.13 Text Editions Published Online with No Print Counterpart
- [x] 6.4.14 Online Database
- [x] 6.4.15 Websites and Blogs

7 Other Examples

- [x] 7.1 BDAG, BDB, BDF
- [x] 7.2 HALOT, TLOT
- [x] 7.3 SBLHS

The `publ-imp-sbl-test.bib` file contains BibTeX entries for these examples, and the `publ-imp-sbl-test.tex` file demonstrates how to typeset them with various settings. 

## To Do

Most to-do tasks have been moved to the Issues tab. Things that others have volunteered to do are listed below:
- [ ] If possible, add a final pass over the entry to move commas and periods after right quotes to positions before them, in accordance with American style (Hans says he can take care of this)
