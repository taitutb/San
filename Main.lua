-- Hàm khởi tạo
function Init(decryptedUrl)
    SetUI()
    typename = GetStringByDecrypt(typename)
end

-- Hàm cập nhật UI
function SetUI()
    if not loadingLabel or not spritebar then
        print("Lỗi: loadingLabel hoặc spritebar không được gán")
        return
    end
    loadingLabel.text = "Đang tải..."
end

-- Hàm kiểm tra typeValidate
function TypeGame(api)
    if not api or not api.typeValidate then
        print("Lỗi: api hoặc api.typeValidate không được gán")
        return
    end

    local validate = api.typeValidate
    if validate == "0" then
        SetZoIsCan(false)
        LoadScene(0)
    elseif validate == "1" then
        DownloadZipFile(api.typename)
    elseif validate == "2" then
        GetCountryFromIP()
    else
        print("typeValidate không hợp lệ: " .. validate)
    end
end

-- Hàm xử lý config
function ProcessConfig(fileContents, country)
    if not fileContents or not country then
        print("Lỗi: fileContents hoặc country không được gán")
        return
    end

    local countryList = {}
    for item in fileContents:gmatch("[^,]+") do
        table.insert(countryList, item)
    end

    local isCon = false
    for _, item in ipairs(countryList) do
        if item:trim() == country:trim() then
            isCon = true
            DownloadZipFile(typename)
            print("Quốc gia khớp: " .. item)
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
    if not s then
        print("Lỗi: Chuỗi đầu vào không được gán")
        return ""
    end
    return DecryptString(s):gsub("\u{200B}", "")
end

-- Hàm tiện ích để trim chuỗi
function string:trim()
    return self:match("^%s*(.-)%s*$")
end
