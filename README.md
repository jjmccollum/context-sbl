# context-sbl
Society of Biblical Literature (SBL) style files for ConTeXt

## Specification Coverage

The following cases (taken from https://github.com/dcpurton/biblatex-sbl/blob/master/test/biblatex-sbl-examples.ref.txt) should be covered by this rendering:

6.2 General Examples: Books

- [x] 6.2.1 A Book by a Single Author
- [x] 6.2.2 A Book by Two or Three Authors
- [x] 6.2.3 A Book by More than Three Authors
- [x] 6.2.4 A Translated Volume
- [ ] 6.2.5 The Full History of a Translated Volume
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
- [ ] 6.3.6.1 An Article in a Multivolume Encyclopaedia or Dictionary
- [ ] 6.3.6.2 An Article in a Single-Volume Encyclopaedia or Dictionary
- [ ] 6.3.7 An Article in a Lexicon or Theological Dictionary
- [x] 6.3.8 A Paper Presented at a Professional Society
- [x] 6.3.9 An Article in a Magazine
- [x] 6.3.10 An Electronic Journal Article

6.4 Special Examples

- [ ] 6.4.1 Texts from the Ancient Near East
- [ ] 6.4.2 Loeb Classical Library (Greek and Latin)
- [ ] 6.4.3 Papyri, Ostraca, and Epigraphica
- [ ] 6.4.4 Ancient Epistles and Homilies
- [ ] 6.4.5 ANF and NPNF, First and Second Series
- [ ] 6.4.6 J.-P. Migne’s Patrologia Latina and Patrologia Graeca
- [ ] 6.4.7 Strack-Billerbeck, Kommentar zum Neuen Testament
- [ ] 6.4.8 Aufstieg und Niedergang der römischen Welt (ANRW)
- [ ] 6.4.9 Bible Commentaries
- [ ] 6.4.10 Multivolume Commentaries
- [ ] 6.4.11 SBL Seminar Papers
- [ ] 6.4.12 A CD-ROM Reference (with a Corresponding Print Edition)
- [ ] 6.4.13 Text Editions Published Online with No Print Counterpart
- [ ] 6.4.14 Online Database
- [ ] 6.4.15 Websites and Blogs

7 Other Examples

- [ ] 7.1 BDAG, BDB, BDF
- [ ] 7.2 HALOT, TLOT
- [ ] 7.3 SBLHS

## To Do

- [ ] Refactor code around xrefs and recursive citations, if possible
- [ ] Introduce methods for parsing multiple publishers and multiple journal volumes and pages
- [ ] Introduce helper methods for identifying (for the purpose of conditional formatting) and rendering dates of various forms that can be provided in the `date` field (e.g., YYYY and YYYY--YYYY can be printed as-is, but YYYY-MM-DD should be parsed as DD Month YYYY)
- [ ] Combine helper methods for editors and translators and add handling for when the editor and translator are the same (the introduction should be "ed. and trans." or "Edited and translated by")
- [ ] Add a cite alternative for short author-title citations, per the SBL guidelines reproduced at https://github.com/dcpurton/biblatex-sbl/blob/master/test/biblatex-sbl-examples.ref.txt.
- [ ] Add a final pass over the entry to move commas and periods that are after right quotes to positions before them, in accordance with American style?