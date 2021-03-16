local gamelist = {
    [286090429] = "Arsenal"
}

for gameId, coco in pairs(gamelist) do
    if gameId == game.PlaceId then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/falseopx/coco-hub/'..coco..'.lua'))()
    end
end
