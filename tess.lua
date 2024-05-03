-- Load the DrRay library from the GitHub repository Library
local DrRayLibrary = loadstring(gameHttpGet(httpsraw.githubusercontent.comAZYsGithubDrRay-UI-LibrarymainDrRay.lua))()

-- Create a new window and set its title and theme
local window = DrRayLibraryLoad(ENZO, Default)

-- Create the first tab with an image ID
local tab1 = DrRayLibrary.newTab(Tab 1, 😍)

-- Add elements to the first tab
tab1.newLabel(Hello, this is Tab 1.)
tab1.newButton(Button, Prints Hello!, function()
    print('Hello!')
end)
tab1.newToggle(Toggle, Toggle! (prints the state), true, function(toggleState)
    if toggleState then
        print(On)
    else
        print(Off)
    end
end)
tab1.newInput(Input, Prints your input., function(text)
    print(Entered text in Tab 1  .. text)
end)

-- Add a Sell button to Tab 1
tab1.newButton(Sell, Sells the item, function()
    local args = {
        [1] = TeleportToLastHarborShopChannel
    }
    gameGetService(ReplicatedStorage)WaitForChild(CommonLibrary)WaitForChild(Tool)WaitForChild(RemoteManager)WaitForChild(Funcs)WaitForChild(DataPullFunc)InvokeServer(unpack(args))
end)

-- Create the second tab with a different image ID
local tab2 = DrRayLibrary.newTab(Tab 2, ImageIdLogoHere)

-- Add elements to the second tab
tab2.newLabel(Hello, this is Tab 2.)
tab2.newButton(Button, Prints Hello!, function()
    print('Hello!')
end)

-- Create the dropdown and toggle
local dropdownOptions = {water, dog, air, bb, airplane, wohhho, yeay, delete, garden}
local dropdown = tab2.newDropdown(Dropdown, Select one of these options!, dropdownOptions, function(selectedOption)
    print(selectedOption)
    if selectedOption == garden and toggleGetState() then
        local args = {
            [1] = player_gacha_pet,
            [2] = {
                [1] = 59,
                [3] = {},
                [2] = 1
            }
        }
        gameGetService(ReplicatedStorage)WaitForChild(RemoteFunction)InvokeServer(unpack(args))
    end
end)
local toggle = tab2.newToggle(Toggle, Toggle! (Run selected option), false)

-- Add functionality to toggle
toggle.callback = function(toggleState)
    if toggleState then
        local selectedOption = dropdownGetValue()
        if selectedOption == garden then
            local args = {
                [1] = player_gacha_pet,
                [2] = {
                    [1] = 59,
                    [3] = {},
                    [2] = 1
                }
            }
            gameGetService(ReplicatedStorage)WaitForChild(RemoteFunction)InvokeServer(unpack(args))
        else
            print(Selected option, selectedOption)
        end
    end
end
