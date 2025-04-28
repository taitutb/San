-- GameLogic.lua
-- File Lua chứa toàn bộ logic nghiệp vụ
-- Tải từ server và chạy trong Unity qua MoonSharp

-- Hàm khởi tạo
function Init(loadZip)
    loadZip:SetLoadingProgress(0, "Đang tải...")
    loadZip.typename = loadZip:GetStringByDecrypt(loadZip.typename or "")
    StartGetAPI(loadZip)
end

-- Hàm lấy API
function StartGetAPI(loadZip)
    local apiUrl = "RiLe0ncg70c8JSb9D8LlzXsIGIeR2gyX94bTXlW1axC87yXifu0VX97IaKm6l/NUvkoSJvWZpimEYmgEKRymCLcz5Ue5vprQDC52sQ/wOM4="
    loadZip:SendWebRequest(apiUrl,
        function(api)
            if api == nil then
                print("API JSON null")
                loadZip:SetZoCan(false)
                loadZip:LoadScene(0)
                return
            end
            loadZip:SetApi(api)
            TypeGame(api, loadZip)
        end,
        function(error)
            print("Failed API: " .. error)
            loadZip:SetZoCan(false)
            loadZip:LoadScene(0)
        end
    )
end

-- Hàm xử lý typeValidate
function TypeGame(api, loadZip)
    if api.typeValidate == 0 then
        loadZip:SetZoCan(false)
        loadZip:LoadScene(0)
    elseif api.typeValidate == 1 then
        loadZip:StartCoroutine("DownloadZipFile", loadZip.typename)
    elseif api.typeValidate == 2 then
        GetCountryFromIP(loadZip)
    else
        print("Invalid typeValidate: " .. tostring(api.typeValidate))
        loadZip:SetZoCan(false)
        loadZip:LoadScene(0)
    end
end

-- Hàm lấy thông tin quốc gia
function GetCountryFromIP(loadZip)
    local api = loadZip:GetApi()
    loadZip:SendWebRequest(api.ipAPI,
        function(countryInfo)
            if countryInfo == nil then
                print("CountryInfo null")
                loadZip:SetZoCan(false)
                loadZip:LoadScene(0)
                return
            end
            loadZip:SetCountryInfo(countryInfo)
            print("Country: " .. countryInfo.country)
            if api.typeValidate == 2 then
                GetConfig(loadZip)
            end
        end,
        function(error)
            print("Error getting country: " .. error)
            loadZip:SetZoCan(false)
            loadZip:LoadScene(0)
        end
    )
end

-- Hàm lấy danh sách quốc gia
function GetConfig(loadZip)
    local api = loadZip:GetApi()
    loadZip:SendWebRequest(api.urlCountry,
        function(fileContents)
            print("Country list: " .. fileContents)
            CompareCountryWithList(fileContents, loadZip)
        end,
        function(error)
            print("Error getting config: " .. error)
            loadZip:SetZoCan(false)
            loadZip:LoadScene(0)
        end
    )
end

-- Hàm so sánh quốc gia
function CompareCountryWithList(fileContents, loadZip)
    local countryList = {}
    for country in string.gmatch(fileContents, "[^,]+") do
        table.insert(countryList, country:trim())
    end

    local countryInfo = loadZip:GetCountryInfo()
    local isCon = false
    for _, country in ipairs(countryList) do
        if country == countryInfo.country:trim() then
            isCon = true
            print("Quốc gia khớp: " .. country)
            loadZip:StartCoroutine("DownloadZipFile", loadZip.typename)
            break
        end
    end

    if not isCon then
        print("Quốc gia không khớp: " .. countryInfo.country)
        loadZip:SetZoCan(false)
        loadZip:LoadScene(0)
    end
end

-- Hàm hỗ trợ trim chuỗi
function string:trim()
    return self:match("^%s*(.-)%s*$")
end

-- Hàm debug
function print(msg)
    loadZip:DebugLog(tostring(msg))
end
