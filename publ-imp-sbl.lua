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
        bookauthor          = "author",
        withbookauthor      = "author",
        editor              = "author",
        witheditor          = "author",
        bookeditor          = "author",
        withbookeditor      = "author",
        maineditor          = "author",
        withmaineditor      = "author",
        translator          = "author",
        revdauthor          = "author",
        revdwithauthor      = "author",
        revdeditor          = "author",
        revdwitheditor      = "author",
        revdtranslator      = "author",
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
    series = { "shortseries", "series" }, -- prefer shorthand to long form
    journal = { "shortjournal", "journal", "journaltitle" }, -- prefer shorthand to long form
    location = { "location", "address" }, -- interchangeable
    institution = { "institution", "school" }, -- interchangeable
    origpublisher = { "origpublisher", "origlocation", "origdate" }, -- the presence of any of these fields indicates that the entry is a reprint
    date = { "date", "year", "pubstate" }, -- prefer the more specific field, and prefer any date to publication state (e.g., "forthcoming")
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
        doi = generic.doi,
    },
    required = { 
        "author", -- a set
        "title",
        "publisher",
    },
    optional = {
        "withauthor", "withauthortype",
        "editor",
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "volumes",
        "volume",
        "part",
        "maintitle",
        "maineditor",
        "withmaineditor", "withmaineditortype",
        "edition",
        "series", "seriesseries", "number",
        "origpublisher",
        "location",
        "date",
        "eprint",
        "doi", "note",
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
        author = { "author", "editor", "organization" }, -- a manual may have an editor instead of an author
        series = generic.series,
        origpublisher = generic.origpublisher,
        location = generic.location,
        date = generic.date,
        doi = generic.doi,
    },
    required = { 
        "title",
        "publisher",
    },
    optional = {
        "author",
        "withauthor", "withauthortype",
        "editor",
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "volumes",
        "volume",
        "part",
        "maintitle",
        "maineditor",
        "withmaineditor", "withmaineditortype",
        "edition",
        "series", "seriesseries", "number",
        "origpublisher",
        "location",
        "date",
        "eprint",
        "doi", "note",
    },
}

-- a multi-volume work (§6.2.20; "volumes" field is required, but otherwise identical to book)
categories.mvbook = {
    sets = {
        author = { "author", "editor" }, -- a book may have an editor instead of an author
        series = generic.series,
        origpublisher = generic.origpublisher,
        location = generic.location,
        date = generic.date,
        doi = generic.doi,
    },
    required = { 
        "author", -- a set
        "title",
        "volumes",
        "publisher",
    },
    optional = {
        "withauthor", "withauthortype",
        "editor",
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "edition",
        "series", "seriesseries", "number",
        "origpublisher",
        "location",
        "date",
        "eprint",
        "doi", "note",
    },
}

-- a multi-volume encyclopedia or dictionary (§6.3.6.2; interchangeable with a multi-volume book)
categories.mvreference = categories.mvbook

-- a multi-volume collection (§6.4.1; interchangeable with a multi-volume book)
categories.mvcollection = categories.mvbook

-- a multi-volume commentary (§6.4.10; interchangeable with a multi-volume book)
categories.mvcommentary = categories.mvbook

-- a multi-volume lexicon (§7.2; interchangeable with a multi-volume book)
categories.mvlexicon = categories.mvbook

-- a multi-volume series published by the author or editor (such as Migne's Patrologia Graeca or Patrologia Latina; see §6.4.6)
categories.series = {
    sets = {
        author = { "author", "editor" }, -- a series may have an editor instead of an author
        origpublisher = generic.origpublisher,
        location = generic.location,
        date = generic.date,
        doi = generic.doi,
    },
    required = { 
        "author", -- a set
        "title",
        "volumes",
    },
    optional = {
        "withauthor", "withauthortype",
        "editor",
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "origpublisher",
        "publisher",
        "location",
        "date",
        "eprint",
        "doi", "note",
    },
}

-- an introduction, preface, or foreword to a book written by someone other than the author (§6.2.14)
-- This category should also contain either a booktitle 
-- or a maintitle with a volume number (§6.2.22)
categories.suppbook = {
    sets = {
        series = generic.series,
        origpublisher = generic.origpublisher,
        location = generic.location,
        date = generic.date,
        doi = generic.doi,
    },
    required = {
        "author", -- author of the introduction/preface/foreword (a set)
        "bookauthor", -- author of the book
        "publisher",
        "type", -- e.g., "introduction", "preface", "foreword"
    },
    optional = {
        "withauthor", "withauthortype",
        "withbookauthor", "withbookauthortype",
        "editor",
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "booktitle",
        "bookeditor",
        "withbookeditor", "withbookeditortype",
        "volume",
        "part",
        "maintitle",
        "maineditor",
        "withmaineditor", "withmaineditortype",
        "edition",
        "series", "seriesseries", "number",
        "origpublisher",
        "location",
        "date",
        "pages",
        "eprint",
        "doi", "note",
    },
}

-- a part of a book, which may be a chapter and/or a range of pages.
-- article or note in a study Bible (§6.4.9.1)
-- This category should also contain either a booktitle 
-- or a maintitle with a volume number (§6.2.22)
categories.inbook = {
    sets = {
        series = generic.series,
        origpublisher = generic.origpublisher,
        location = generic.location,
        date = generic.date,
        doi = generic.doi,
    },
    required = {
        "author", -- author of the article (or book, if the author also wrote the book)
        "title", -- title of the article
        "publisher",
    },
    optional = {
        "withauthor", "withauthortype",
        "editor",
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "booktitle",
        "bookeditor",
        "withbookeditor", "withbookeditortype",
        "volume",
        "part",
        "maintitle",
        "maineditor",
        "withmaineditor", "withmaineditortype",
        "edition",
        "series", "seriesseries", "number",
        "origpublisher",
        "location",
        "date",
        "pages",
        "eprint",
        "doi", "note",
    },
}

-- an article in an encyclopaedia or a dictionary (§6.3.6; same fields as inbook)
categories.inreference = categories.inbook

-- an article in a lexicon (§6.3.7; same fields as inbook, although only the lexicon should be cited in the list)
categories.inlexicon = categories.inbook

-- an article in a single-volume commentary on the entire Bible (§6.4.9.2)
categories.incommentary = categories.inbook

-- a seminar paper (§6.4.11)
categories.seminarpaper = categories.inbook

-- a text from the Ancient Near East (or anywhere, really; see §6.4.1)
-- a papyrus or ostracon (§6.4.3)
-- this is almost identical to inbook, but no author is required, and rendering for inline citations is slightly different
categories.ancienttext = {
    sets = {
        series = generic.series,
        origpublisher = generic.origpublisher,
        location = generic.location,
        date = generic.date,
        doi = generic.doi,
    },
    required = {
        "title", -- title of the ancient text
        "publisher",
    },
    optional = {
        "author", -- author of the ancient text (if known)
        "booktitle",
        "editor",
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "booktitle",
        "bookeditor",
        "withbookeditor", "withbookeditortype",
        "volume",
        "part",
        "maintitle",
        "maineditor",
        "withmaineditor", "withmaineditortype",
        "edition",
        "series", "seriesseries", "number",
        "origpublisher",
        "location",
        "date",
        "pages",
        "eprint",
        "doi", "note",
    },
}

-- a classical text (§6.4.2; same fields as ancienttext, although rendering for inline and list citations is slightly different)
categories.classictext = categories.ancienttext

-- a book that is itself part of a collection.
-- (like inbook, but the entry in question is one or more volumes of a multi-volume work )
-- note that biblatex-sbl uses @collection to refer to this entry type.
categories.incollection = {
    sets = {
        author = { "author", "editor" },
        booktitle = { "title" }, -- an alias so that entries are printed correctly
        series = generic.series,
        origpublisher = generic.origpublisher,
        location = generic.location,
        date = generic.date,
        doi = generic.doi,
    },
    required = {
        "author", -- a set
        "title", -- the title of this book
        "volume", -- volume number of this book in the collection
        "maintitle", -- title of the collection
        "publisher",
    },
    optional = {
        "withauthor", "withauthortype", 
        "editor", 
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "bookeditor",
        "withbookeditor", "withbookeditortype",
        "maineditor",
        "withmaineditor", "withmaineditortype",
        "part",
        "edition",
        "series", "seriesseries", "number",
        "location",
        "date",
        "origpublisher",
        "eprint",
        "doi", "note",
    },
}

-- a volume in a collection (§6.4.1; interchangeable with a book in a collection)
categories.collection = categories.incollection

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
        "withauthor", "withauthortype", 
        "translator", "origlanguage",
        "date",
        "volume", "number", "pages",
        "doi", "note",
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
        revdtitle = { "revdtitle", "revdbooktitle", }, -- interchangeable
        journal = generic.journal,
        date = generic.date,
        doi = generic.doi,
    },
    required = {
        "author",
        "revdtitle", -- a set
        "journal", -- a set
    },
    optional = {
        "withauthor", "withauthortype", -- for the review
        "translator", "origlanguage", -- for the review
        "revdauthor", "revdwithauthor", "revdwithauthortype", -- for the book
        "revdeditor", "revdwitheditor", "revdwitheditortype", -- for the book
        "revdtranslator", "revdoriglanguage", -- for the book
        "revdedition", -- for the book
        "date", -- for the journal
        "volume", "number", "pages", -- for the journal
        "doi", "note",
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
        "author", -- referring to the set above
        "title",
        "publisher",
    },
    optional = {
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "series", "seriesseries", "number",
        "location",
        "date",
        "origpublisher",
        "doi", "note",
    },
}

-- an article in a conference proceedings.
categories.inproceedings = {
    sets     = categories.incollection.sets,
    required = categories.incollection.required,
    optional = {
        "withauthor", "withauthortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "year", "date", "origdate",
        "edition", 
        "series", "seriesseries", "number",
        "location",
        "date",
        "origpublisher",
        "doi", "note",
    },
}

-- not covered by SBL, but treated as interchangeable with inproceedings in other ConTeXt citation .lua files
categories.conference = categories.inproceedings

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
        "withauthor", "withauthortype",
        "translator", "origlanguage",
        "location",
        "date",
        "doi", "note",
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
        "withauthor", "withauthortype",
        "translator", "origlanguage",
        "location",
        "doi", "note",
    },
}

-- a Master's thesis.
categories.mastersthesis = {
    sets = categories.thesis.sets,
    required = {
        "author",
        "title",
        "institution", -- a set
        "date", -- a set
    },
    optional = {
        "withauthor", "withauthortype",
        "translator", "origlanguage",
        "location",
        "doi", "note",
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
        "withauthor", "withauthortype",
        "translator", "origlanguage",
        "file",
        "date",
        "doi",
    },
}

-- a document published online with no print counterpart (§6.4.13),
-- an online database (§6.4.14), or
-- a website or blog (§6.4.15)
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
        "author", 
        "withauthor", "withauthortype",
        "translator", "origlanguage",
        "journal",
        "eprint", "eprintdate", "eprintclass", "eprinttype",
        "date",
        "doi", "note",
    },
}

-- electronic sources are not addressed by SBL, so their category will be treated as an alias of @online
categories.electronic = categories.online

-- use this type when nothing else fits.

categories.misc = {
    sets = {
        author = { "author", "editor", "organization" },
        location = generic.location,
        date = generic.date,
        doi  = generic.doi,
    },
    required = {
        -- nothing is really important here
    },
    optional = {
        "author", 
        "withauthor", "withauthortype",
        "title",
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "edition", 
        "volumes",
        "volume",
        "maintitle",
        "maineditor",
        "withmaineditor", "withmaineditortype",
        "series", "seriesseries", "number",
        "howpublished",
        "location",
        "publisher",
        "date",
        "doi", "note",
    },
}

-- if all else fails to match:

categories.literal = {
    sets = {
        author = { "key" },
        doi    = generic.doi,
    },
    required = {
        "author",
        "text"
    },
    optional = {
        "withauthor", "withauthortype",
        "witheditor", "witheditortype",
        "translator", "origlanguage",
        "edition", 
        "volumes",
        "volume",
        "maintitle",
        "maineditor",
        "withmaineditor", "withmaineditortype",
        "series", "seriesseries", "number",
        "howpublished",
        "location",
        "publisher",
        "date",
        "doi", "note",
    },
    virtual = false,
}

-- done

return specification
