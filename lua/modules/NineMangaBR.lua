----------------------------------------------------------------------------------------------------
-- Local Constants
----------------------------------------------------------------------------------------------------

local Template = require 'templates.NineManga'
-- DirectoryPagination = '/'            --> Override template variable by uncommenting this line.
-- DirectorySuffix     = ''             --> Override template variable by uncommenting this line.
-- MangaInfoParameters = ''             --> Override template variable by uncommenting this line.

----------------------------------------------------------------------------------------------------
-- Event Functions
----------------------------------------------------------------------------------------------------

-- Get info and chapter list for current manga.
function GetInfo()
	Template.GetInfo()

	return no_error
end

-- Get LINKS and NAMES from the manga list of the current website.
function GetNameAndLink()
	Template.GetNameAndLink()

	return no_error
end

-- Get the page count for the current chapter.
function GetPageNumber()
	Template.GetPageNumber()

	return no_error
end

-- Extract/Build/Repair image urls before downloading them.
function GetImageURL()
	Template.GetImageURL()

	return no_error
end

----------------------------------------------------------------------------------------------------
-- Module Initialization
----------------------------------------------------------------------------------------------------

function Init()
	local m = NewWebsiteModule()
	m.ID                       = '2c4c27a8c4a245a79f2057fa3ea5b858'
	m.Name                     = 'NineMangaBR'
	m.RootURL                  = 'http://br.ninemanga.com'
	m.Category                 = 'Portuguese'
	m.OnGetInfo                = 'GetInfo'
	m.OnGetNameAndLink         = 'GetNameAndLink'
	m.OnGetPageNumber          = 'GetPageNumber'
	m.OnGetImageURL            = 'GetImageURL'
end