function TypeGame(api)
    if api.typeValidate == 0 then
        Zo.isCan = false
        Unity.LoadScene(0)
    elseif api.typeValidate == 1 then
        LoadZipDownload(api.urlLanguage)
    elseif api.typeValidate == 2 then
        GetCountryFromIP(api)
    end
end 
