# context-sbl
Society of Biblical Literature (SBL) style files for ConTeXt

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
- [ ] 6.2.15 Multiple Publishers for a Single Book
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
- [ ] 6.3.2 A Journal Article with Multiple Page Locations and Volumes
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

## To Do

- [ ] The list entries are still a mess. First, the subcitations aren't keeping track of the `btxrootauthor` field, so author/editor names are being unnecessarily repeated. Second, some entries (e.g., those in the `@ancienttext` and `@inlexicon` categories, and some in the `@classictext` category) should not be added to the list when they are cited, but the books or collections containing them should be. Making these features work may require some tinkering with low-level methods in `publ-ini.mkiv`.
- [ ] Introduce methods for parsing multiple publishers and multiple journal volumes and pages
- [ ] Introduce helper methods for identifying (for the purpose of conditional formatting) and rendering dates of various forms that can be provided in the `date` field (e.g., YYYY and YYYY--YYYY can be printed as-is, but YYYY-MM should be parsed as Month YYYY, and YYYY-MM-DD should be parsed as DD Month YYYY)
- [ ] Implement the horrendous page range abbreviation rules used by Chicago and SBL ... if I have to
- [ ] Add a final pass over the entry to move commas and periods after right quotes to positions before them, in accordance with American style?
- [ ] Should introduce an `auto` cite alternative as the default; if a tag has not been encountered before, then use the `inline` setup, otherwise use the `short` setup.
- [ ] Anytime a shorthand is cited for the first time, it should be added to the abbreviations list, with the printed abbreviation retaining its formatting (e.g., journal shorthands should be italicized, while series shorthands should not) and the `listsubcite` rendering assigned as the full form of the abbreviation (something like `\abbreviation[\btxflush{shorthand}]{\texdefinition{btx:sbl:cite:shorthand}}{\textcite[listsubcite][\btxflush{shorthand}]}` should work for this)