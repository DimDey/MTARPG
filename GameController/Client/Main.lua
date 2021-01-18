Main = {
    init = function()
        setDevelopmentMode( true, true )
        setPlayerHudComponentVisible( "all", false )
    end;
}
addEventHandler("onClientResourceStart", resourceRoot, Main.init)