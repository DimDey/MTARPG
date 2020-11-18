Main = {
    init = function()
        outputDebugString("[JR-GMC] Starting database...")
        Database:init();
    end;
}
addEventHandler("onResourceStart", resourceRoot, Main.init)