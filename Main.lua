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


function TypeGame(api)
    if api.typeValidate == 0 then
       SetZoIsCan(false)
        LoadScene(0)
    elseif api.typeValidate == 1 then
         DownloadZipFile(api.typename)
    elseif api.typeValidate == 2 then
       GetCountryFromIP()
    else
        print("typeValidate: Unknown (" .. api.typeValidate .. ")")
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
