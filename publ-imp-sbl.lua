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
    origpublisher = { "origpublisher", "origlocation", "origdate" }, -- the presence of any of these fields indicates that the entry is a reprint
    date = { "date", "year", "pubstate" }, -- prefer the more specific field, and prefer any date to publication state (e.g., "forthcoming")
    bookxref = { "bookxref", "incollectionxref" }, -- the presence of any of these fields indicate that the entry is part of a titled or untitled book
    reprxref = { "reprxref", "transxref" }, -- the presence of any of these fields indicate that the entry is a reprint or translation of another work
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

-- a book with an explicit publisher (§6.2)
categories.book = {
    sets = {
        author = { "author", "editor" }, -- a book may have an editor instead of an author
        series = generic.series,
        origpublisher = generic.origpublisher,
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
        "withauthor", "withauthortype",
        "collectionxref", "volume", "part",
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "edition",
        "series", "seriesseries", "number",
        "origpublisher",
        "location",
        "date",
        "reprxref",
        "transxref",
        "eprint",
        "doi",
        "type", -- (for exceptional cases that require special formatting, like "inlineshorthand")
        "note",
    },
}

-- a single-volume encyclopedia or dictionary (§6.3.6.1; interchangeable with a book)
categories.reference = categories.book

-- a single-volume commentary (§6.4.9; interchangeable with a book)
-- a volume in a multi-volume commentary (§6.4.10; interchangeable with a book)
categories.commentary = categories.book

-- a single-volume lexicon (§7.1; interchangeable with a book)
categories.lexicon = categories.book

-- a manual (§7.3; no author/editor required, and an organization can be specified instead, 
-- but otherwise identical to a book)
categories.manual = {
    sets = {
        author = { "author", "editor", "organization" },
        series = generic.series,
        origpublisher = generic.origpublisher,
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
        "author",
        "withauthor", "withauthortype",
        "collectionxref", "volume", "part",
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "edition",
        "series", "seriesseries", "number",
        "origpublisher",
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

-- an untitled volume in a multivolume collection
-- (hence, a volume number and collection reference are required instead of a title).
-- note that this differs from the @incollection category used by biblatex-sbl,
-- which refers to a chapter or article in an untitled multivolume work.
categories.incollection = {
    sets = {
        author = { "author", "editor" }, -- a book may have an editor instead of an author
        series = generic.series,
        origpublisher = generic.origpublisher,
        location = generic.location,
        date = generic.date,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = {
        "collectionxref", -- reference to the collection
        "volume", -- volume number of this book in the collection
        "publisher",
    },
    optional = {
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "part",
        "series", "seriesseries", "number",
        "origpublisher",
        "location",
        "date",
        "eprint",
        "doi", 
        "note",
    },
}

-- a multivolume collection with an editor
categories.collection = {
    sets = {
        author = { "editor" },
        series = generic.series,
        origpublisher = generic.origpublisher,
        location = generic.location,
        date = generic.date,
        doi = generic.doi,
    },
    required = { 
        "author", -- just an alias for the editor
        "title",
        "volumes",
        "publisher",
    },
    optional = {
        "shorthand", -- to abbreviate in subcites
        "shorttitle", -- for short citations
        "editortype",
        "witheditor", "witheditortype",
        "series", "seriesseries", "number",
        "origpublisher",
        "location",
        "date",
        "doi",
        "type", -- (for exceptional cases that require special formatting)
        "note",
    },
}

-- a multivolume work (§6.2.20)
categories.mvbook = {
    sets = {
        author = { "author", "editor" }, -- a book may have an editor instead of an author
        series = generic.series,
        origpublisher = generic.origpublisher,
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
        "withauthor", "withauthortype",
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "withtranslator", "withtranslatortype",
        "edition",
        "series", "seriesseries", "number",
        "origpublisher",
        "location",
        "date",
        "reprxref",
        "transxref",
        "eprint",
        "doi",
        "type", -- (for exceptional cases that require special formatting, like "Str-B")
        "note",
    },
}

-- a multivolume encyclopedia or dictionary (§6.3.6.2)
categories.mvreference = categories.mvbook

-- a multivolume collection (§6.4.1)
categories.mvcollection = categories.mvbook

-- a multivolume commentary (§6.4.10)
categories.mvcommentary = categories.mvbook

-- a multivolume lexicon (§7.2)
categories.mvlexicon = categories.mvbook

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
        "editor", "editortype",
        "witheditor", "witheditortype",
        "volumes",
        "location",
        "publisher",
        "date",
        "doi",
        "type",
        "note",
    },
}

-- a part of a book identified by an explicit page or page range.
-- article or note in a study Bible (§6.4.9.1)
-- This category should also contain a reference to either a titled book 
-- or an untitled volume in a collection (§6.2.22)
categories.inbook = {
    sets = {
        bookxref = generic.bookxref,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = {
        "author", -- author of the article/chapter (or book, if the author also wrote the book)
        "title", -- title of the article/chapter
        "bookxref", -- a set
        "pages",
    },
    optional = {
        "shorttitle", -- for short citations
        "withauthor", "withauthortype",
        "translator", "origlanguage",
        "withtranslator", "withtranslatortype",
        "reprxref",
        "doi",
        "type", -- (for exceptional cases that require special formatting, like "ANRW")
        "note",
    },
}

-- an introduction, preface, or foreword to a book written by someone other than the author (§6.2.14)
-- This category should also contain a reference to either a book or a volume in a collection (§6.2.22)
categories.suppbook = {
    sets = {
        bookxref = generic.bookxref,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = {
        "author", -- author of the introduction/preface/foreword (a set)
        "type", -- e.g., "introduction", "preface", "foreword"
        "bookxref", -- a set
    },
    optional = {
        "withauthor", "withauthortype",
        "translator", "origlanguage",
        "withtranslator", "withtranslatortype",
        "doi",
        "note",
    },
}

-- an article in an encyclopaedia or a dictionary (§6.3.6)
categories.inreference = categories.inbook

-- an article in a lexicon (§6.3.7)
categories.inlexicon = categories.inbook

-- an article in a single-volume commentary on the entire Bible (§6.4.9.2)
categories.incommentary = categories.inbook

-- a text from the Ancient Near East (or anywhere, really; see §6.4.1)
-- a papyrus or ostracon (§6.4.3)
-- almost identical to inbook, but no author is required
categories.ancienttext = {
    sets = {
        bookxref = generic.bookxref,
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = {
        "title", -- title of the ancient text
        "bookxref", -- a set
    },
    optional = {
        "shorttitle", -- for short citations
        "shorthand", -- to abbreviate (e.g., for papyri, ostraca, and epigraphica)
        "author", -- author of the ancient text (if known)
        "withauthor", "withauthortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "part",
        "pages",
        "location", -- for artifact provenance, not publication
        "doi",
        "type", -- (for exceptional cases that require special formatting, like "COS", "PGM", "inscription" or "chronicle")
        "note",
    },
}

-- a classical text (§6.4.2)
categories.classictext = {
    sets = {
        bookxref = { "collectionxref", "incollectionxref", "bookxref", "seriesxref" }, -- classical texts can span multiple volumes of multivolume collections
        reprxref = generic.reprxref,
        doi = generic.doi,
    },
    required = {
        "title", -- title of the classical text
    },
    optional = {
        "shorttitle", -- for short citations
        "author", -- author of the classical text (if known)
        "withauthor", "withauthortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "bookxref",
        "number",
        "part",
        "pages",
        "doi",
        "type", -- (for exceptional cases that require special formatting, like "LCL" or "churchfather")
        "note",
    },
}

-- a journal
categories.journal = categories.series

-- an article from a journal (§6.3)
categories.article = {
    sets = {
        journal = generic.journal,
        date = generic.date,
        doi = generic.doi,
    },
    required = {
        "author",
        "title",
        "journal", -- a set
    },
    optional = {
        "shorttitle", -- for short citations
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
        bookxref = generic.bookxref,
        doi = generic.doi,
    },
    required = {
        "author",
        "bookxref", -- a set
        "journal", -- a set
    },
    optional = {
        "withauthor", "withauthortype",
        "title",
        "shorttitle", -- for short citations
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "date",
        "volume", "number", "pages",
        "doi", 
        "note",
    },
}

-- the proceedings of a conference (not covered by SBL)
categories.proceedings = {
    sets = {
        author = { "editor", "organization" }, -- no "author"!
        series = generic.series,
        origpublisher = generic.origpublisher,
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
        "editor", "editortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "series", "seriesseries", "number",
        "location",
        "date",
        "doi", 
        "note",
    },
}

-- an article in a conference
-- not covered by SBL, but treated as interchangeable with an article in a published book
categories.inproceedings = categories.inbook

-- not covered by SBL, but treated as interchangeable with inproceedings in other ConTeXt citation .lua files
categories.conference = categories.inproceedings

-- a seminar paper (§6.4.11)
categories.seminarpaper = categories.inproceedings

-- a paper presented at a professional society (but not published; see §6.3.8)
categories.conferencepaper = {
    sets = {
        location = { "location", "address", "venue" }, -- interchangeable
        date = { "date", "eventdate", "year" }, -- "date" and "eventdate" are interchangeable, and both are preferable to the less specific "year"
        doi = generic.doi,
    },
    required = {
        "author",
        "title",
        "eventtitle", -- e.g., "the Annual Meeting of the New England Region of the Society of Biblical Literature"
    },
    optional = {
        "shorttitle", -- for short citations
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
        "date", -- a set
        "type", -- typically a category name, like "mastersthesis" or "phdthesis"
    },
    optional = {
        "shorttitle", -- for short citations
        "withauthor", "withauthortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "location",
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
        "date", -- a set
    },
    optional = {
        "shorttitle", -- for short citations
        "withauthor", "withauthortype",
        "translator", "origlanguage", 
        "withtranslator", "withtranslatortype",
        "location",
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
        bookxref = generic.bookxref,
        journal = generic.journal,
        series = generic.series,
        origpublisher = generic.origpublisher,
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
        "shorthand", -- to abbreviate in subcites
        "shorttitle", -- for short citations
        "xref", "volume", "part",
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
        bookxref = generic.bookxref,
        journal = generic.journal,
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
        "text"
    },
    optional = {
        "withauthor", "withauthortype",
        "title",
        "shorthand", -- to abbreviate in subcites
        "shorttitle", -- for short citations
        "bookxref", "volume", "part",
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
