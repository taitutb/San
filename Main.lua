function TypeGame(api)
    if api.typeValidate == 0 then
        print("typeValidate: " .. api.typeValidate)
    elseif api.typeValidate == 1 then
        print("typeValidate: " .. api.typeValidate)
    elseif api.typeValidate == 2 then
        print("typeValidate: " .. api.typeValidate)
        LoadLua.LoadMyScene()
    else
        print("typeValidate: Unknown (" .. api.typeValidate .. ")")
    end
end 
