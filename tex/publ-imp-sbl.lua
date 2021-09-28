local specification = {
    --
    -- metadata
    --
    name      = "sbl",
    version   = "1.00",
    comment   = "Society of Biblical Literature Handbook of Style, 2nd edition, specification",
    author    = "Joey McCollum",
    copyright = "ConTeXt development team",
    --
    -- derived (combinations of) fields (all share the same default set)
    --
    virtual = {
        "authortitle",
        "authoryear",
        "authoryears",
        "authornum",
        "num",
        "suffix",
    },
    --
    -- special datatypes
    --
    types = {
        --
        -- list of fields that are interpreted as names: "NAME [and NAME]" where
        -- NAME is one of the following:
        --
        -- First vons Last
        -- vons Last, First
        -- vons Last, Jrs, First
        -- Vons, Last, Jrs, First
        --
        author              = "author", -- interpreted as name(s)
        withauthor          = "author",
        editor              = "author",
        witheditor          = "author",
        translator          = "author",
        withtranslator      = "author",
        volumes             = "number",
        volume              = "range",
        part                = "range",
        doi                 = "url",        -- an external link
        url                 = "url",
        page                = "pagenumber", -- number or range: f--t
        pages               = "pagenumber",
        number              = "range",
        keywords            = "keyword",    -- comma|-|separated list
        date                = "date",       -- yyyy-mm-dd
        year                = "number",
    },
    --
    -- categories with their specific fields
    --
    categories = {
        --
        -- categories are added below
        --
    },
}

local generic = {
    --
    -- A set returns the first field (in order of position below) that is found
    -- present in an entry. A set having the same name as a field conditionally
    -- allows the substitution of an alternate field.
    --
    -- note that anything can get assigned a doi or be available online. 
    journal = { "journalxref", "shortjournal", "journal" }, -- cross-references to separate entries are preferred, then shorthand, then long forms
    series = { "seriesxref", "shortseries", "series" }, -- cross-references to separate entries are preferred, then shorthand, then long form
    location = { "location", "address" }, -- interchangeable
    institution = { "institution", "school" }, -- interchangeable
    date = { "date", "year", "pubstate" }, -- prefer the more specific field, and prefer any date to publication state (e.g., "forthcoming")
    crossref = { "crossref", "xref" }, -- the presence of any of these fields indicates that the entry is cross-referenced to a book or collection containing it
    pages = { "pages", "page" }, -- interchangeable
    reprxref = { "reprxref", "transxref" }, -- the presence of any of these fields indicates that the entry is a reprint or translation of another work
    doi = { "doi", "url" }, -- prefer DOI to arbitrary URL
}

-- Definition of recognized categories and the fields that they contain.
-- Required fields should be present; optional fields may also be rendered;
-- all other fields will be ignored.

-- Sets contain either/or in order of precedence.
--
-- For a category *not* defined here yet present in the dataset, *all* fields
-- are taken as optional. This allows for flexibility in the addition of new
-- categories.

local categories = specification.categories

-- a series
-- this can include multivolume collections published by the editor,
-- such as Migne's Patrologia Graeca or Patrologia Latina (§6.4.6)
categories.series = {
    sets = {
        location = generic.location,
        date = generic.date,
        doi = generic.doi,
    },
    required = { 
        "title",
    },
    optional = {
        "shorthand", -- to abbreviate in subcites
        "shorttitle", -- for short citations
        "subtitle",
        "editor", "editortype",
        "witheditor", "witheditortype",
        "volumes",
        "origlocation", "origpublisher", "origdate",
        "location",
        "publisher",
        "date",
        "doi",
        "type",
        "note",
    },
}

-- a journal
categories.journal = categories.series

-- a multivolume work (§6.2.20)
-- a multivolume encyclopedia or dictionary (§6.3.6.2)
-- a multivolume collection (§6.4.1)
-- a multivolume commentary (§6.4.10)
-- a multivolume lexicon (§7.2)
categories.collection = {
    sets = {
        author = { "author", "editor" }, -- a collection may have an editor instead of an author
        series = generic.series,
        location = generic.location,
        date = generic.date,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = { 
        "author", -- a set
        "title",
        "volumes",
        "publisher",
    },
    optional = {
        "shorthand", -- to abbreviate in subcites
        "shorttitle", -- for short citations
        "subtitle",
        "withauthor", "withauthortype",
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "parts",
        "series", "seriesseries", "number",
        "origlocation", "origpublisher", "origdate",
        "location",
        "date",
        "reprxref",
        "eprint",
        "doi",
        "type", -- (for exceptional cases that require special formatting)
        "note",
    },
}

-- a single-volume book not in a collection (§6.2)
-- a single-volume encyclopedia or dictionary (§6.3.6.1)
-- a single-volume commentary (§6.4.9)
-- a single-volume lexicon (§7.1)
categories.book = {
    sets = {
        author = { "author", "editor" }, -- a book may have an editor instead of an author
        series = generic.series,
        location = generic.location,
        date = generic.date,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = { 
        "author", -- a set
        "title",
        "publisher",
    },
    optional = {
        "shorthand", -- to abbreviate in subcites
        "shorttitle", -- for short citations
        "subtitle",
        "withauthor", "withauthortype",
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "edition",
        "series", "seriesseries", "number",
        "origlocation", "origpublisher", "origdate",
        "location",
        "date",
        "reprxref",
        "transxref",
        "eprint",
        "doi",
        "type", -- (for exceptional cases that require special formatting, like "inlineshort")
        "note",
    },
}

-- a manual (§7.3; identical to a book, except that the author set is optional, and can consist of an author, editor, or organization) 
categories.manual = {
    sets = {
        author = { "author", "editor", "organization" },
        series = generic.series,
        location = generic.location,
        date = generic.date,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = { 
        "title",
        "publisher",
    },
    optional = {
        "shorthand", -- to abbreviate in subcites
        "shorttitle", -- for short citations
        "subtitle",
        "author",
        "withauthor", "withauthortype",
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "edition",
        "series", "seriesseries", "number",
        "origlocation", "origpublisher", "origdate",
        "location",
        "date",
        "reprxref",
        "transxref",
        "eprint",
        "doi", 
        "type", -- (for exceptional cases that require special formatting)
        "note",
    },
}

-- the published proceedings of a conference (§6.4.11)
categories.proceedings = {
    sets = {
        author = { "editor", "organization" }, -- no "author"!
        series = generic.series,
        publisher = { "publisher", "organization" },
        location = generic.location,
        date = generic.date,
        doi = generic.doi,
    },
    required = {
        "title",
        "publisher",
    },
    optional = {
        "author", -- referring to the set above
        "shorthand", -- to abbreviate in subcites
        "shorttitle", -- for short citations
        "subtitle",
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "series", "seriesseries", "number",
        "origlocation", "origpublisher", "origdate",
        "location",
        "date",
        "doi", 
        "note",
    },
}

-- a volume in a multivolume collection
-- (hence, a volume number and collection reference are required instead of a title, although a title may also be specified).
-- note that this differs from the @incollection category used by biblatex-sbl,
-- which refers to a chapter or article in an untitled multivolume work.
categories.incollection = {
    sets = {
        author = { "author", "editor" }, -- a book may have an editor instead of an author
        series = generic.series,
        location = generic.location,
        date = generic.date,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = {
        "author", -- a set
        "collectionxref", -- reference to the collection
        "volume", -- volume number of this book in the collection
        "publisher",
    },
    optional = {
        "title", -- optional for this category
        "shorttitle", -- for short citations
        "subtitle",
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "part",
        "series", "seriesseries", "number",
        "origlocation", "origpublisher", "origdate",
        "location",
        "date",
        "eprint",
        "doi",
        "type", -- (for exceptional cases that require special formatting)
        "note",
    },
}

-- a part of a book identified by an explicit page or page range
-- in either a single-volume book (§6.2.12-13) or a volume in a collection (§6.2.22-23)
-- an article or note in a study Bible (§6.4.9.1)
categories.inbook = {
    sets = {
        crossref = generic.crossref,
        pages = generic.pages,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = {
        "author", -- author of the article/chapter (or book, if the author also wrote the book)
        "title", -- title of the article/chapter
        "crossref", -- a set
        "pages", -- a set
    },
    optional = {
        "shorttitle", -- for short citations
        "subtitle",
        "withauthor", "withauthortype",
        "translator", "origlanguage",
        "withtranslator", "withtranslatortype",
        "reprxref",
        "doi",
        "type", -- (for exceptional cases that require special formatting)
        "entrysubtype", -- (for subdivisions such as "inlexicon" or "incommentary")
        "note",
    },
}

-- an article in an encyclopaedia or a dictionary (§6.3.6)
-- an article in a lexicon (§6.3.7)
-- an article in a commentary on the entire Bible (§6.4.9.2, 6.4.10.2)
categories.inreference = categories.inbook

-- a seminar paper (§6.4.11)
categories.inproceedings = categories.inbook

-- not covered by SBL, but treated as interchangeable with inproceedings in other ConTeXt citation .lua files
categories.conference = categories.inproceedings

-- an introduction, preface, or foreword to a book written by someone other than the author (§6.2.14)
-- similar to inbook, but a type is required instead of a page range (although a page range can optionally be supplied, as well)
categories.suppbook = {
    sets = {
        crossref = generic.crossref,
        pages = generic.pages,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = {
        "author", -- author of the introduction/preface/foreword (a set)
        "type", -- e.g., "introduction", "preface", "foreword"
        "crossref", -- a set
    },
    optional = {
        "withauthor", "withauthortype",
        "pages",
        "translator", "origlanguage",
        "withtranslator", "withtranslatortype",
        "doi",
        "note",
    },
}

-- a text from the Ancient Near East (or anywhere, really; see §6.4.1)
-- a papyrus or ostracon (§6.4.3)
-- almost identical to inbook, but no author is required
categories.ancienttext = {
    sets = {
        crossref = generic.crossref,
        pages = generic.pages,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = {
        "title", -- title of the ancient text
    },
    optional = {
        "shorthand", -- to abbreviate (e.g., for papyri, ostraca, and epigraphica)
        "shorttitle", -- for short citations
        "subtitle",
        "author", -- author of the ancient text (if known)
        "withauthor", "withauthortype",
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "crossref",
        "part",
        "pages",
        "location", -- for artifact provenance, not publication
        "doi",
        "type", -- (for exceptional cases that require special formatting, like "PGM", "plaintitle" or "plainshorthand")
        "note",
    },
}

-- a classical text (§6.4.2)
-- an ancient work by a church father (§6.4.4-6)
categories.classictext = {
    sets = {
        crossref = generic.crossref,
        pages = generic.pages,
        series = generic.series,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = {
        "title", -- title of the classical text
    },
    optional = {
        "shorttitle", -- for short citations
        "subtitle",
        "author", -- author of the classical text (if known)
        "withauthor", "withauthortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "series", "seriesseries", "number",
        "crossref",
        "part",
        "pages",
        "doi",
        "type", -- (for exceptional cases that require special formatting, like "seriesascollection")
        "note",
    },
}

-- an article from a journal (§6.3)
categories.article = {
    sets = {
        journal = generic.journal,
        date = generic.date,
        pages = generic.pages,
        doi = generic.doi,
    },
    required = {
        "author",
        "title",
        "journal", -- a set
    },
    optional = {
        "shorttitle", -- for short citations
        "subtitle",
        "withauthor", "withauthortype", 
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "volume", "number", "date", "pages",
        "doi", 
        "note",
    },
}

-- an article from a magazine (§6.3.9; interchangeable with an article)
categories.magazine = categories.article

-- an article in a newspaper (not covered by SBL, so treat as equivalent to an article)
categories.newspaper = categories.article

-- an article in a periodical (not covered by SBL, so treat as equivalent to an article)
categories.periodical = categories.article

-- a book review (§6.3.4)
categories.review = {
    sets = {
        journal = generic.journal,
        date = generic.date,
        pages = generic.pages,
        crossref = generic.crossref,
        doi = generic.doi,
    },
    required = {
        "author",
        "crossref", -- a set
        "journal", -- a set
    },
    optional = {
        "withauthor", "withauthortype",
        "title",
        "subtitle",
        "shorttitle", -- for short citations
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "date",
        "volume", "number", "pages",
        "doi", 
        "note",
    },
}

-- a paper presented at a professional society (but not published; see §6.3.8)
categories.conferencepaper = {
    sets = {
        location = generic.location,
        date = generic.date,
        doi = generic.doi,
    },
    required = {
        "author",
        "title",
        "conference", -- e.g., "the Annual Meeting of the New England Region of the Society of Biblical Literature"
    },
    optional = {
        "shorttitle", -- for short citations
        "subtitle",
        "withauthor", "withauthortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "location",
        "date",
        "doi", 
        "note",
    },
}

-- any type of thesis (the type can be specified as a field).
categories.thesis = {
    sets = {
        institution = generic.institution,
        location = generic.location,
        date = generic.date,
        doi = generic.doi,
    },
    required = {
        "author",
        "title",
        "institution", -- a set
        "type", -- typically a category name, like "mastersthesis" or "phdthesis"
    },
    optional = {
        "shorttitle", -- for short citations
        "subtitle",
        "withauthor", "withauthortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "location",
        "date",
        "doi", 
        "note",
    },
}

-- a Master's thesis.
categories.mastersthesis = {
    sets = {
        institution = generic.institution,
        location = generic.location,
        date = generic.date,
        doi = generic.doi,
    },
    required = {
        "author",
        "title",
        "institution", -- a set
    },
    optional = {
        "shorttitle", -- for short citations
        "subtitle",
        "withauthor", "withauthortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "location",
        "date",
        "doi", 
        "note",
    },
}

-- a PhD. thesis.
categories.phdthesis = categories.mastersthesis

-- a document having an author and title, but not formally published.
categories.unpublished = {
    sets = {
        date = generic.date,
        doi = generic.doi,
    },
    required = {
        "author",
        "title",
        "note",
    },
    optional = {
        "shorttitle", -- for short citations
        "subtitle",
        "withauthor", "withauthortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "date",
        "doi",
    },
}

-- a document published online with no print counterpart (§6.4.13),
-- an online database (§6.4.14), or
-- a website or blog entry (§6.4.15)
categories.online = {
    sets = {
        author = { "author", "organization", "editor", },
        journal = generic.journal,
        location = generic.location,
        date = generic.date,
        doi = generic.doi
    },
    required = {
        "title",
    },
    optional = {
        "shorttitle", -- for short citations
        "subtitle",
        "author", 
        "withauthor", "withauthortype",
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "journal", -- can also refer to a blog
        "eprint", "eprintdate", "eprintclass", "eprinttype",
        "date",
        "doi", 
        "note",
    },
}

-- electronic sources are not addressed by SBL, so their category will be treated as an alias of @online
categories.electronic = categories.online

-- use this type when nothing else fits.

categories.misc = {
    sets = {
        author = { "author", "editor", "organization" },
        crossref = generic.crossref,
        journal = generic.journal,
        pages = generic.pages,
        series = generic.series,
        institution = generic.institution,
        location = generic.location,
        date = generic.date,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = {
        -- nothing is really important here
    },
    optional = {
        "author", 
        "withauthor", "withauthortype",
        "title",
        "subtitle",
        "shorttitle", -- for short citations
        "shorthand", -- to abbreviate in subcites
        "collectionxref", "volume", "part",
        "crossref",
        "pages",
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "withtranslator", "withtranslatortype",
        "edition",
        "volumes",
        "series", "seriesseries", "number",
        "origlocation", "origpublisher", "origdate",
        "location",
        "publisher",
        "date",
        "journal",
        "institution",
        "howpublished",
        "reprxref",
        "eprint",
        "doi", 
        "note",
    },
}

-- if all else fails to match:

categories.literal = {
    sets = {
        author = { "key" },
        crossref = generic.crossref,
        journal = generic.journal,
        pages = generic.pages,
        series = generic.series,
        origpublisher = generic.origpublisher,
        institution = generic.institution,
        location = generic.location,
        date = generic.date,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = {
        "author",
        "text",
    },
    optional = {
        "withauthor", "withauthortype",
        "title",
        "subtitle",
        "shorttitle", -- for short citations
        "shorthand", -- to abbreviate in subcites
        "collectionxref", "volume", "part",
        "crossref",
        "pages",
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "withtranslator", "withtranslatortype",
        "edition",
        "volumes",
        "series", "seriesseries", "number",
        "origpublisher",
        "location",
        "publisher",
        "date",
        "journal",
        "institution",
        "howpublished",
        "eprint",
        "doi", 
        "note",
    },
    virtual = false,
}

-- done

return specification
