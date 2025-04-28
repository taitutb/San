-- GameLogic.lua
-- File Lua chính chứa logic nghiệp vụ cho game
-- Tải từ server và chạy trong Unity qua MoonSharp

-- Hàm khởi tạo chính
function Init(loadZip)
    -- Cập nhật UI ban đầu
    loadZip:SetLoadingProgress(0, "Đang tải...")

    -- Giải mã typename
    loadZip.typename = loadZip:GetStringByDecrypt(loadZip.typename or "")

    -- Bắt đầu lấy API
    StartGetAPI(loadZip)
end

-- Hàm lấy API
function StartGetAPI(loadZip)
    local apiUrl = "RiLe0ncg70c8JSb9D8LlzXsIGIeR2gyX94bTXlW1axC87yXifu0VX97IaKm6l/NUvkoSJvWZpimEYmgEKRymCLcz5Ue5vprQDC52sQ/wOM4="
    apiUrl = loadZip:GetStringByDecrypt(apiUrl)

    -- Gửi yêu cầu lấy API
    loadZip:SendWebRequest(apiUrl,
        function(json)
            if json == nil or json == "" then
                print("JSON null")
                loadZip:SetZoCan(false)
                loadZip:LoadScene(0)
                return
            end
            -- Lưu ý: Ở đây giả sử JSON đã được parse thành đối tượng JsonAPI bởi C#
            loadZip:SetApi(json)
            TypeGame(json, loadZip)
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
        function(json)
            -- Lưu ý: JSON đã được parse thành CountryInfo bởi C#
            loadZip:SetCountryInfo(json)
            print("Country: " .. json.country)
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
            print("Content file: " .. fileContents)
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

-- Hàm debug để ghi log ra Unity
function print(msg)
    loadZip:DebugLog(msg)
end