Main = {
    init = function()
        setDevelopmentMode( true, true )
        fadeCamera( true )
        setPlayerHudComponentVisible( "all", false )
        showCursor(true)
        setCameraMatrix( 0, 0, 50, 111, 111, 0, 0, 180 )
    end;
}
addEventHandler("onClientResourceStart", resourceRoot, Main.init)