# context-sbl
Society of Biblical Literature (SBL) style files for ConTeXt

## About This Project

I initially began developing this bibliography rendering for my own use, but since the SBL citation style is commonly used in the humanities (particularly in religious studies), I felt that a full implementation for the ConTeXt typesetting system would be of value for other users. Thankfully, David Purton had already put together a thorough implementation of this citation style for LaTeX (https://github.com/dcpurton/biblatex-sbl), so I was able to use his category definitions as starting points instead of reinventing the wheel. At the same time, since I had to build the `.lua` and `.mkvi` files mostly from scratch, I took advantage of opportunities to simplify certain implementation details. I will summarize the changes I made below.

### Structure of the Bibliographic Database

In my opinion, one of the smartest innovations of Purton's `biblatex-sbl` package was its use of cross-references between BibTeX entries. This feature allows us to simplify the pool of fields used by different categories, modularize the structures of categories, and reduce redundancy of common higher-level references. In short, it allows (and encourages) users to structure their `.bib` files more like actual databases. I decided to implement this feature more broadly, eliminating the `book*`, `main*`, and `revd*` fields in favor of cross-references to separate entries. On the ConTeXt side, citations of lower-level entries that cross-reference higher-level entries are handled recursively.

Since some of Purton's entry categories are functionally identical, I collapsed many of them to their most common BibTeX counterparts. My aim was to introduce as few new categories as possible. A brief summary of each category, starting from the top-level categories and working our way down, follows:

- `@series`: A set of books, including multivolume collections published by the editor, such as Migne's _Patrologia Graeca_ or _Patrologia Latina_ (§6.4.6). The only required field is `title` (although a `shorthand` will be used instead if it is also provided).
- `@journal`: A journal. The only required field is `title` (although a `shorthand` will be used instead if it is also provided). This category is structurally identical to `@series`, but their typeset representations are different. (A journal's title is italicized, while a series's title is not.)
- `@collection`: A multivolume work (_SBLHS_ §6.2.20), a multivolume encyclopedia or dictionary (§6.3.6.2), a multivolume collection (§6.4.1), a multivolume commentary (§6.4.10), or a multivolume lexicon (§7.2). Required fields are `author` (either a proper author or an editor), `title`, `publisher`, and `volumes`. If the work corresponds to multiple entries in a series, then this can be indicated by cross-referencing the `@series` entry in the `seriesxref` field or by repeating its title or shorthand in the `series` and `shortseries` fields. This category encapsulates Purton's `@mvbook`, `@mvreference`, `@mvcollection`, `@mvcommentary`, and `@mvlexicon` categories.
- `@book`: A single-volume book not in a collection (§6.2), a single-volume encyclopedia or dictionary (§6.3.6.1), a single-volume commentary (§6.4.9), or a single-volume lexicon (§7.1). Required fields are `author` (either a proper author or an editor), `title`, and `publisher`. If the work corresponds to an entry in a series, then this can be indicated by cross-referencing the `@series` entry in the `seriesxref` field or by repeating its title or shorthand in the `series` and `shortseries` fields. This category encapsulates Purton's `@book`, `@reference`, `@commentary`, and `@lexicon` categories for entries that are not part of a multivolume collection.
- `@manual`: A manual (§7.3). Identical to `@book`, except that the `author` field is optional, and it can consist of an author, editor, or organization.
- `@proceedings`: The published proceedings of a conference (§6.4.11). Identical to `@book`, except that the `author` field is optional, and it can only consist of an editor or organization.
- `@incollection`: A volume, titled or untitled, in a multivolume collection (§6.2.22-23). Required fields are `author` (either a proper author or an editor), `collectionxref` (consisting of the entry tag for the collection containing this volume), `volume` (containing the volume number), and `publisher`. The `title` field is optional. If the work corresponds to an entry in a series, then this can be indicated by cross-referencing the `@series` entry in the `seriesxref` field or by repeating its title or shorthand in the `series` and `shortseries` fields. This category encapsulates Purton's `@book`, `@reference`, `@commentary`, and `@lexicon` categories for entries that are part of a multivolume collection. (**NOTE**: This differs from the `@incollection` category used by `biblatex-sbl`, which refers to a chapter or article in an untitled multivolume work!)
- `@inbook`: A article or chapter in a single-volume book (§6.2.12-13), an article or chapter in a collection volume (§6.2.22-23), or an article or note in a study Bible (§6.4.9.1), identified by an explicit page range. Required fields are `author` (referring to a proper author), `title`, either `bookxref` or `incollectionxref` (consisting of the entry tag for the book or volume containing this work), and `pages` (containing the page range for this work in the book or volume). This category encapsulates Purton's `@inbook` and `@incollection` categories.
- `@inreference`: An article in an encyclopaedia or a dictionary (§6.3.6.1-2). Structurally identical to `@inbook`, but their typesetting rules are slightly different.
- `@inlexicon`: An article in a lexicon (§6.3.7). Structurally identical to `@inbook`, but their typesetting rules are slightly different.
- `@incommentary`: An article in a commentary on the entire Bible (§6.4.9.2, 6.4.10.2). Structurally identical to `@inbook`, but their typesetting rules are slightly different.
- `@inproceedings`: A seminar paper (§6.4.11). Structurally identical to `@inbook`, but the cross-reference in the `bookxref` field should point to a `@proceedings` entry. (This is not checked, though, so functionally this category is the same as `@inbook`.) This category encapsulates Purton's `@seminarpaper` category.
- `@suppbook`: A named section of a book (e.g., introduction, preface, foreword) written by someone other than the author (§6.2.14). Required fields are `author` (referring to a proper author), `type` (containing a string like "introduction", "preface", or "foreword"), and either `bookxref` or `incollectionxref` (consisting of the entry tag for the book or volume containing this work). A page range can optionally be specified.
- `@ancienttext`: A text from the Ancient Near East (or anywhere, really; §6.4.1) or a papyrus or ostracon (§6.4.3). The only required field is `title`. If known, an author can be specified in the optional  `author` field. Optionally, a volume or single-volume book reproducing and/or translating the text can be cross-referenced with the `@incollectionxref` or `@bookxref` field, respectively.
- `@classictext`: A classical text (§6.4.2), or an ancient work by a church father (§6.4.4-6). The only required field is `title`. If known, an author can be specified in the optional  `author` field. Optionally, multivolume collection, volume, or single-volume book reproducing and/or translating the text can be cross-referenced with the `@collectionxref`, `@incollectionxref`, or `@bookxref` field, respectively. If the text is published in a series (such as Migne's PG or PL) instead, then the series can be cross-referenced in the `seriesxref` field or in the `series` or `shortseries` field.
- `@article`: An article from a journal (§6.3) or a magazine (§6.3.9). Required fields are `author` (referring to a proper author), `title`, and either `journalxref` (for a cross-reference to the appropriate `@journal` entry) or `journal` or `shortjournal` (for a reference to the journal's name or shorthand). Typically, the `volume` (and sometimes `number`), `year`, and `pages` fields will accompany the journal cross-reference, but they are not required.
- `@review`: A book review published in a journal (§6.3.4). Required fields are `author` (referring to the author of the review), either `bookxref` or `@incollectionxref` (cross-referencing the reviewed book), and either `journalxref` (for a cross-reference to the appropriate `@journal` entry) or `journal` or `shortjournal` (for a reference to the journal's name or shorthand). If the review itself has a title, then this can be included in the `title` field. Typically,  the `volume` (and sometimes `number`), `year`, and `pages` fields will accompany the journal cross-reference, but they are not required.
- `@conferencepaper`: A paper presented at a professional society, but not published (§6.3.8). Required fields are `author` (referring to a proper author), `title`, and `conference` (the title of the conference). Typically, the `location` and `date` fields will accompany the `conference` field, but they are not required.
- `@thesis`: An unpublished dissertation or thesis (§6.3.5). Required fields are `author` (referring to a proper author), `title`, `institution` (the name of the school where the thesis was undertaken), and `type` (assumed to be the name of another thesis category, like "mastersthesis" or "phdthesis"). Typically, the `date` field will accompany the `institution` field, but they are not required.
- `@mastersthesis`: An unpublished Master's thesis (§6.3.5). Identical to `@thesis` with `type=mastersthesis`.
- `@phdthesis`: An unpublished PhD dissertation (§6.3.5). Identical to `@thesis` with `type=phdthesis`.
- `@online`: A document published online with no print counterpart (§6.4.13), an online database (§6.4.14), or a website or blog entry (§6.4.15). The only required field is `title`, although typically `doi` or `url` is included.

Other categories supported by other ConTeXt renderings, such as `@unpublished` and `@misc`, are also supported, although they should only be used if the entry does not fit into a more specific category. A relational diagram between the categories is shown below.

![Relational diagram of entry categories in SBL rendering](https://github.com/jjmccollum/context-sbl/blob/main/img/relational-diagram.png)

In the diagram above, solid lines indicate required cross-reference relationships (although in some cases, such as categories that have a `bookxref` and `incollectionxref` field, only one such relationship is required), and dashed lines indicate optional cross-reference relationships. Additional types of cross-references not pictured here include reprint (`reprxref`) and translation (`transxref`) relationships. (For an example of both, see §6.2.5.)

### Special Formatting Rules

While I have tried to account for all cases in the examples using only category-based rules as much as possible, there are some types of entries within certain categories that need to be typeset slightly differently. Where Purton's `biblatex-sbl` package typically does this using the `options` field, I have opted to repurpose the existing `type` field for this. (I may have to revisit later, but simplicity has been my goal for this stage of development.) These special `type` values are detailed below.

| `type` value  | Description | Example(s) |
| --- | --- | --- |
| `inlineshort`  | The short form of this entry should always be cited in inline citations, even the first time it is cited.  | _COS_ (§6.4.1.1) and other books so well-known that they do not need to be introduced in long form (§7.1-3) |
| `seriesascollection`  | In short-form citations, the series to which this entry belongs should be cited as if it were a collection containing it.  | Volumes of RIMA (§6.4.1.2) and texts in Migne's PG and PL series | 
| `useseriesshorthand`  | In short-form citations, use the shorthand of the series to which this entry belongs as if it were this entry's shorthand.  | Volumes of ARM and ARMT (§6.4.1.2) and entries in the Loeb Classical Library series (§6.4.2) | 
| `plaintitle`  | In long- and short-form citations, do not typeset this entry's title or shorthand using the style associated with its category; instead, typeset it as plain text. | Inscriptions and chronicles (§6.4.1.2) | 
| `plainshorthand`  | In short-form citations, do not typeset this entry's shorthand using the style associated with its category; instead, typeset it as plain text.  | Papyri and ostraca (§6.4.1.2) and Strack-Billerbeck (§6.4.7) | 

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

The `publ-imp-sbl-test.bib` file contains BibTeX entries for these examples, and the `bib_mwe.tex` file demonstrates how to typeset them with various settings. 

## To Do

- [ ] The list entries are still a mess. First, the subcitations aren't keeping track of the `btxrootauthor` field, so author/editor names are being unnecessarily repeated. Second, some entries (e.g., those in the `@ancienttext` and `@inlexicon` categories, and some in the `@classictext` category) should not be added to the list when they are cited, but the books or collections containing them should be. Making these features work may require some tinkering with low-level methods in `publ-ini.mkiv`.
- [ ] Implement the horrendous page range abbreviation rules used by Chicago and SBL ... if I have to
- [ ] If possible, add a final pass over the entry to move commas and periods after right quotes to positions before them, in accordance with American style
- [ ] Introduce an `auto` cite alternative as the default; if a tag has not been encountered before, then use the `inline` setup, otherwise use the `short` setup.
- [ ] Anytime a shorthand is cited for the first time, it should be added to the abbreviations list, with the printed abbreviation retaining its formatting (e.g., journal shorthands should be italicized, while series shorthands should not) and the `listsubcite` rendering assigned as the full form of the abbreviation (something like `\abbreviation[\btxflush{shorthand}]{\texdefinition{btx:sbl:cite:shorthand}}{\textcite[listsubcite][\btxflush{shorthand}]}` should work for this)