function Fallback()
    SetZoIsCan(false)
    LoadScene(0)
end    

function TypeGame(api)
    if api.typeValidate == 0 then
       SetZoIsCan(false)
        LoadScene(0)
    elseif api.typeValidate == 1 then
         GetData()
    elseif api.typeValidate == 2 then
       GetGeo()
    else
        print("Unknown")
    end
end 

function ProcessConfig(fileContents, country)
    if not fileContents or not country then
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
            GetData()
            break
        end
    end

    if not isCon then
        SetZoIsCan(false)
        LoadScene(0)
    end
end


function GetStringByDecrypt(s)
    if not s then
        return ""
    end
    return DecryptString(s):gsub("\u{200B}", "")
end


function string:trim()
    return self:match("^%s*(.-)%s*$")
end
