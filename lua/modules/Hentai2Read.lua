function Init()
	local m = NewWebsiteModule()
	m.ID                         = '053da85062184626a0a1ff6d57c3c955'
	m.Name                       = 'Hentai2Read'
	m.RootURL                    = 'https://hentai2read.com'
	m.Category                   = 'H-Sites'
	m.OnGetDirectoryPageNumber   = 'GetDirectoryPageNumber'
	m.OnGetNameAndLink           = 'GetNameAndLink'
	m.OnGetInfo                  = 'GetInfo'
	m.OnGetPageNumber            = 'GetPageNumber'
	m.OnGetImageURL              = 'GetImageURL'
	m.SortedList                 = true
end

local dirurl = '/hentai-list/all/any/all/last-added';
local cdnurl = 'http://static.hentaicdn.com/hentai';

function GetDirectoryPageNumber()
	if HTTP.GET(MODULE.RootURL .. dirurl) then
		PAGENUMBER = tonumber(CreateTXQuery(HTTP.Document).x.XPathString('//ul[starts-with(@class,"pagination")]/li[last()-1]/a')) or 1
		return no_error
	else
		return net_problem
	end
end

function GetNameAndLink()
	local s = MODULE.RootURL .. dirurl
	if URL ~= '0' then
		s = s .. '/' .. (URL + 1) .. '/'
	end
	if HTTP.GET(s) then
		local v for v in CreateTXQuery(HTTP.Document).XPath('//*[@class="img-overlay text-center"]/a').Get() do
			LINKS.Add(v.GetAttribute('href'))
			NAMES.Add(x.XPathString('h2/@data-title', v))
		end
		return no_error
	else
		return net_problem
	end
end

function GetInfo()
	MANGAINFO.URL = MaybeFillHost(MODULE.RootURL, URL)
	if HTTP.GET(MANGAINFO.URL) then
		local x = CreateTXQuery(HTTP.Document)

		MANGAINFO.CoverLink = MaybeFillHost(cdnurl, x.XPathString('//img[@class="img-responsive border-black-op"]/@src'))
		MANGAINFO.Title     = x.XPathString('//h3[@class="block-title"]/a/text()')
		MANGAINFO.Authors   = x.XPathStringAll('//ul[contains(@class,"list-simple-mini")]/li[starts-with(.,"Author")]/a')
		MANGAINFO.Artists   = x.XPathStringAll('//ul[contains(@class,"list-simple-mini")]/li[starts-with(.,"Artist")]/a')
		MANGAINFO.Genres    = x.XPathStringAll('//ul[contains(@class,"list-simple-mini")]/li/a')
		MANGAINFO.Summary   = x.XPathString('//ul[contains(@class,"list-simple-mini")]/li[starts-with(.,"Storyline")]/*[position()>1]')
		MANGAINFO.Status    = MangaInfoStatusIfPos(x.XPathString('//ul[contains(@class,"list-simple-mini")]/li[starts-with(.,"Status")]'))

		local v for v in x.XPath('//ul[contains(@class,"nav-chapters")]/li/div/a').Get() do
			MANGAINFO.ChapterLinks.Add(v.GetAttribute('href'))
			MANGAINFO.ChapterNames.Add(x.XPathString('string-join(text()," ")', v))
		end
		MANGAINFO.ChapterLinks.Reverse(); MANGAINFO.ChapterNames.Reverse()
		return no_error
	else
		return net_problem
	end
end

function GetPageNumber()
	if HTTP.GET(MaybeFillHost(MODULE.RootURL, URL)) then
		local x = CreateTXQuery(HTTP.Document)
		for v in x.XPath('json(//script[contains(.,"images\' :")]/substring-before(substring-after(.,"images\' : "),"]")||"]")()').Get() do
			TASK.PageLinks.Add(cdnurl .. v.ToString())
		end
		if TASK.PageLinks.Count == 0 then
			TASK.PageNumber = x.XPath('(//li[contains(@class, "pageDropdown")])[1]/ul/li').Count
		end
		return true
	else
		return false
	end
end

function GetImageURL()
	local s = MaybeFillHost(MODULE.RootURL, URL)
	if WORKID > 0 then s = s:gsub('/+$', '') .. '/' .. (WORKID + 1) .. '/' end
	if HTTP.GET(s) then
		TASK.PageLinks[WORKID] = MaybeFillHost(cdnurl, CreateTXQuery(HTTP.Document).XPathString('//img[@id="arf-reader"]/@src'):gsub('^/*', ''))
		return true
	end
		return false
end
