local plr           = game:GetService("Players").LocalPlayer
local reachamount   = 7
local props = {
    size = Vector3.new(1.75, 1.75, 1.75),
    shape = Enum.PartType.Ball,
    material = Enum.Material.SmoothPlastic
}

local table = {}
local t_bool = true
local col

local function remove(col)
    for _, c in ipairs(col:GetChildren()) do
        if c:IsA("WeldConstraint") then
            c:Destroy()
        end
    end
end

local function removecan()
    if col then
        if col.CanCollide then
            col.CanCollide = false
        end
    end
end

local function update()
    table = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Size == props.size and obj.Shape == props.shape and obj.Material == props.material then
            table.insert(table, obj)
        end
    end
end

workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Part") and obj.Size == props.size and obj.Shape == props.shape and obj.Material == props.material then
        table.insert(table, obj)
    end
end)

workspace.DescendantRemoving:Connect(function(obj)
    for i, top in ipairs(table) do
        if top == obj then
            table.remove(table, i)
            break
        end
    end
end)

local function start(character)
    col = character:WaitForChild("Collide")
    col.Anchored = true
    col.CanCollide = false
    remove(col)

    game:GetService("RunService").Heartbeat:Connect(function()
        if not col then return end

        removecan()

        if t_bool then
            local c_ball = nil
            local c_distance = reachamount

            for _, obj in ipairs(table) do
                if obj and obj.Parent then
                    local distance = (obj.Position - character.PrimaryPart.Position).Magnitude

                    if distance <= c_distance then
                        c_ball = obj
                        c_distance = distance
                    end
                end
            end

            if c_ball then
                col.CFrame = c_ball.CFrame
            end
        end
    end)
end

local function newcadded(character)
    updatetable()
    start(character)
end

if plr.Character then
    newcadded(plr.Character)
end

plr.CharacterAdded:Connect(newcadded)

print('testing')
