function TypeGame(api)
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
