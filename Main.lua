-- Hàm khởi tạo
function Init()
    SetUI()
end

-- Hàm cập nhật UI
function SetUI()
    if loadingLabel == nil or spritebar == nil then
        print("Lỗi: loadingLabel hoặc spritebar là nil")
        return
    end
    loadingLabel.text = "Đang tải..."
end

-- Hàm kiểm tra typeValidate
function TypeGame(api)
    if api == nil or api.typeValidate == nil then
        print("Lỗi: api hoặc api.typeValidate là nil")
        return
    end

    if api.typeValidate == "0" then
        SetZoIsCan(false)
        LoadScene(0)
    elseif api.typeValidate == "1" then
        DownloadZipFile(typename)
    elseif api.typeValidate == "2" then
        GetCountryFromIP()
    else
        print("typeValidate không hợp lệ: " .. api.typeValidate)
    end
end

-- Hàm xử lý config (thay cho CompareCountryWithList)
function ProcessConfig(fileContents, country)
    if fileContents == nil or country == nil then
        print("Lỗi: fileContents hoặc country là nil")
        return
    end

    -- Tách chuỗi thành danh sách
    local countryList = {}
    for countryItem in fileContents:gmatch("[^,]+") do
        table.insert(countryList, countryItem)
    end

    local isCon = false
    for i = 1, #countryList do
        if countryList[i]:trim() == country:trim() then
            isCon = true
            DownloadZipFile(typename)
            print("Quốc gia khớp: " .. countryList[i])
            break
        end
    end

    if not isCon then
        SetZoIsCan(false)
        LoadScene(0)
        print("Quốc gia không khớp: " .. country)
    end
end

-- Hàm xử lý chuỗi giải mã
function GetStringByDecrypt(s)
    if s == nil then
        print("Lỗi: Chuỗi đầu vào là nil")
        return ""
    end
    local decrypted = DecryptString(s)
    return decrypted:gsub("\u{200B}", "")
end

-- Hàm tiện ích để trim chuỗi
function string:trim()
    return self:match("^%s*(.-)%s*$")
end
