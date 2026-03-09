local PlayerUtils = {}

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")


function PlayerUtils:GetPlayers()
  local PlayersTable = {}
  for i,v in ipairs(Players:GetPlayers()) do
    table.insert(PlayersTable,v)
  end
  return PlayersTable
end

function PlayerUtils:GetOtherPlayers()
  local PlayersTable = {}
  for i,v in ipairs(Players:GetPlayers()) do
    if v ~= Players.LocalPlayer then
      table.insert(PlayersTable,v)
    end
  end
  return PlayersTable
end

function PlayerUtils:GetPlayerByName(Name)
  for i,v in ipairs(Players:GetPlayers()) do
    if tostring(string.lower(v.Name)) == tostring(string.lower(Name)) then
      return v
    end
  end
end

function PlayerUtils:GetPlayerByPartialName(Name)
  for i,v in ipairs(Players:GetPlayers()) do
    if tostring(string.lower(v.Name)):find(tostring(string.lower(Name))) then
      return v
    end
  end
end


function PlayerUtils:GetCharacter(Player)
  local Character = Player.Character
  if Character then
    return Character
  else
    return false
  end
end

function PlayerUtils:GetHumanoid(Player)
  local Character = PlayerUtils:GetCharacter(Player)
  if Character then
    local Humanoid = Character:FindFirstChild("Humanoid")
    if Humanoid then
      return Humanoid
    else
      return false
    end
  else
    return false
  end
end

function PlayerUtils:GetRootPart(Player)
  local Character = PlayerUtils:GetCharacter(Player)
  if Character then
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart then
      return HumanoidRootPart
    else
      return false
    end
  else
    return false
  end
end

function PlayerUtils:IsAlive(Player)
  local Character = PlayerUtils:GetCharacter(Player)
  if Character then
    local Humanoid = Character:FindFirstChild("Humanoid")
    if Humanoid then
      local State = Humanoid:GetState()
      local Health = Humanoid.Health
      if Health > 0 and State ~= Enum.HumanoidStateType.Dead then
        return true
      else
        return false
      end
    else
      return false
    end
  else
    return false
  end
end

function PlayerUtils:IsLocalPlayer(Player)
  return Player == Players.LocalPlayer or false
end

function PlayerUtils:GetDistance(Player)
  local LocalPlayerRootPart = PlayerUtils:GetRootPart(Players.LocalPlayer)
  local OtherPlayerRootPart = PlayerUtils:GetRootPart(Player)
  if LocalPlayerRootPart and OtherPlayerRootPart then
    local Distance = (LocalPlayerRootPart.Position - OtherPlayerRootPart.Position).Magnitude
    if Distance ~= nil then
      return Distance
    else
      return 0
    end
  else
    return 0
  end
end

function PlayerUtils:GetDistanceFromPosition(Player,Position)
  local PlayerRootPart = PlayerUtils:GetRootPart(Player)
  if PlayerRootPart then
    local Distance = (PlayerRootPart.Position - Position).Magnitude
    if Distance ~= nil then
      return Distance
    else
      return 0
    end
    return 0
  end
end

function PlayerUtils:GetClosestPlayer()
  local PlayersTable = {}
  for i,v in ipairs(PlayerUtils:GetPlayers()) do
    local RootPart = PlayerUtils:GetRootPart(v)
    if RootPart and v ~= Players.LocalPlayer then
      table.insert(PlayersTable,{
        Player = v,
        RootPart = RootPart,
        Position = RootPart.Position
      })
    end
  end
  local ClosestPlayer = nil
  local CurrentDistance = math.huge
  for i,v in ipairs(PlayersTable) do
    local LocalPlayerRootPart = PlayerUtils:GetRootPart(Players.LocalPlayer)
    local OtherPlayerRootPart = PlayerUtils:GetRootPart(v.Player)
    if LocalPlayerRootPart and OtherPlayerRootPart and v.Player then
      local Distance = PlayerUtils:GetDistance(v.Player)
      if Distance <= CurrentDistance then
        ClosestPlayer = v.Player
        CurrentDistance = Distance
      end
    else
      return false
    end
  end
  return ClosestPlayer
end

function PlayerUtils:GetClosestCharacter()
  local ClosestPlayer = PlayerUtils:GetClosestPlayer()
  if ClosestPlayer then
    local Character = PlayerUtils:GetCharacter(ClosestPlayer)
    if Character then
      return Character
    else
      return false
    end
    return false
  end
end

function PlayerUtils:GetClosestPlayerFromPosition(Position)
  local PlayersTable = {}
  for i,v in ipairs(PlayerUtils:GetPlayers()) do
    local RootPart = PlayerUtils:GetRootPart(v)
    if RootPart and v ~= Players.LocalPlayer then
      table.insert(PlayersTable,{
        Player = v,
        RootPart = RootPart,
        Position = RootPart.Position
      })
    end
  end
  local ClosestPlayer = nil
  local CurrentDistance = math.huge
  for i,v in ipairs(PlayersTable) do
    local PlayerRootPart = PlayerUtils:GetRootPart(v and v.Player)
    if PlayerRootPart and v.Player then
      local Distance = (PlayerRootPart.Position - Position).Magnitude
      if Distance <= CurrentDistance then
        ClosestPlayer = v.Player
        CurrentDistance = Distance
      end
    else
      return false
    end
  end
  return ClosestPlayer
end

function PlayerUtils:GetPlayersInRadius(Radius)
  local PlayersTable = {}
  for i,v in ipairs(PlayerUtils:GetPlayers()) do
    local RootPart = PlayerUtils:GetRootPart(v)
    if RootPart and v ~= Players.LocalPlayer then
      table.insert(PlayersTable,{
        Player = v,
        RootPart = RootPart,
        Position = RootPart.Position
      })
    end
  end
  local InRadiusPlayers = {}
  for i,v in ipairs(PlayersTable) do
    local Distance = PlayerUtils:GetDistance(v and v.Player)
    if Distance ~= false and Distance ~= nil then
      if Distance <= Radius then
        table.insert(InRadiusPlayers,v and v.Player)
      end
    end
  end
  return InRadiusPlayers
end

function PlayerUtils:GetAlivePlayers()
  local AlivePlayers = {}
  for i,v in ipairs(PlayerUtils:GetPlayers()) do
    if v and PlayerUtils:IsAlive(v) then
      table.insert(AlivePlayers,v)
    end
  end
  return AlivePlayers
end

function PlayerUtils:GetTeamPlayers()
  local TeamPlayers = {}
  for i,v in ipairs(PlayerUtils:GetPlayers()) do
    local Team = v.Team
    local LocalPlayerTeam = Players.LocalPlayer.Team
    if Team == LocalPlayerTeam then
      table.insert(TeamPlayers,v)
    end
  end
  return TeamPlayers
end

function PlayerUtils:GetEnemyPlayers()
  local EnemyPlayers = {}
  for i,v in ipairs(PlayerUtils:GetPlayers()) do
    local Team = v.Team
    local LocalPlayerTeam = Players.LocalPlayer.Team
    if Team ~= LocalPlayerTeam then
      table.insert(EnemyPlayers,v)
    end
  end
  return EnemyPlayers
end

function PlayerUtils:TeleportToPlayer(Player)
  local LocalPlayerRootPart = PlayerUtils:GetRootPart(Players.LocalPlayer)
  local OtherPlayerRootPart = PlayerUtils:GetRootPart(Player)
  if OtherPlayerRootPart and LocalPlayerRootPart then
    LocalPlayerRootPart.CFrame = OtherPlayerRootPart.CFrame
  else
    return false
  end
end

function PlayerUtils:LookAtPlayer(Player)
  local LocalPlayerRootPart = PlayerUtils:GetRootPart(Players.LocalPlayer)
  local OtherPlayerRootPart = PlayerUtils:GetRootPart(Player)
  if OtherPlayerRootPart and LocalPlayerRootPart then
    LocalPlayerRootPart.CFrame = CFrame.lookAt(LocalPlayerRootPart.Position,OtherPlayerRootPart.Position)
  else
    return false
  end
end

function PlayerUtils:GetHealth(Player)
  local Humanoid = PlayerUtils:GetHumanoid(Player)
  if Humanoid then
    local Health = Humanoid.Health
    return Health
  end
  return false
end

function PlayerUtils:GetMaxHealth(Player)
  local Humanoid = PlayerUtils:GetHumanoid(Player)
  if Humanoid then
    local MaxHealth = Humanoid.MaxHealth
    return MaxHealth
  end
  return false
end

function PlayerUtils:IsOnSameTeam(Player)
  return Player and Player.Team == Players.LocalPlayer.Team or false
end

function PlayerUtils:GetRandomEnemy()
  local EnemyPlayers = PlayerUtils:GetEnemyPlayers()

  if #EnemyPlayers == 0 then
    return false
  end

  local Number = math.random(1,#EnemyPlayers)
  local Player = EnemyPlayers[Number]
  if Player then
    return Player
  else
    return false
  end
end

function PlayerUtils:GetRandomPlayer()
  local PlayersTable = PlayerUtils:GetPlayers()

  if #PlayersTable == 0 then
    return false
  end

  local Number = math.random(1,#PlayersTable)
  local Player = PlayersTable[Number]
  if Player then
    return Player
  else
    return false
  end
end

function PlayerUtils:RespawnCharacter()
  local Humanoid = PlayerUtils:GetHumanoid(Players.LocalPlayer)
  if Humanoid then
    Humanoid:TakeDamage(PlayerUtils:GetMaxHealth(Players.LocalPlayer) + 10)
  else
    return false
  end
end

function PlayerUtils:RespawnCharacterInSamePosition()
  local Humanoid = PlayerUtils:GetHumanoid(Players.LocalPlayer)
  local OldRootPart = PlayerUtils:GetRootPart(Players.LocalPlayer)
  if Humanoid and OldRootPart then
    local OldCF = OldRootPart.CFrame
    Humanoid:TakeDamage(PlayerUtils:GetMaxHealth(Players.LocalPlayer) + 10)
    task.wait(Players.RespawnTime + 2)
    for i = 1,100,1 do task.wait(0.01)
      local NewRootPart = PlayerUtils:GetRootPart(Players.LocalPlayer)
      if NewRootPart then
        NewRootPart.CFrame = OldCF
      end
    end
  else
    return false
  end
end

function PlayerUtils:IsVisible(Player)
  local LocalPlayerRootPart = PlayerUtils:GetRootPart(Players.LocalPlayer)
  local OtherPlayerRootPart = PlayerUtils:GetRootPart(Player)
  if LocalPlayerRootPart and OtherPlayerRootPart then
    local Direction = (OtherPlayerRootPart.Position - LocalPlayerRootPart.Position)

    local Params = RaycastParams.new()
    Params.FilterDescendantsInstances = {Players.LocalPlayer.Character}
    Params.FilterType = Enum.RaycastFilterType.Blacklist


    local Result = Workspace:Raycast(LocalPlayerRootPart.Position,Direction,Params)

    if Result then
      local Character = PlayerUtils:GetCharacter(Player)
      if Character then
        if Result and Result.Instance and Result.Instance:IsDescendantOf(Character) then
          return true
        end
        return false
      end
      return false
    end
    return false
  end
  return false
end

function PlayerUtils:GetClosestEnemy()
  local ClosestEnemy = nil
  local CurrentDistance = math.huge
  for i,v in ipairs(PlayerUtils:GetEnemyPlayers()) do
    local Distance = PlayerUtils:GetDistance(v)
    if Distance <= CurrentDistance and PlayerUtils:IsAlive(v) then
      ClosestEnemy = v
      CurrentDistance = Distance
    end
  end
  return ClosestEnemy
end

function PlayerUtils:GetPlayerTeam(Player)
  return Player and Player.Team or false
end

function PlayerUtils:IsEnemy(Player)
  return GetPlayerTeam(Player) ~= GetPlayerTeam(Players.LocalPlayer)
end

function PlayerUtils:CameraLookAtPlayer(Player)
  local Camera = Workspace.CurrentCamera
  local OtherPlayerRootPart = PlayerUtils:GetRootPart(Player)
  if Camera and OtherPlayerRootPart then
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position,OtherPlayerRootPart.Position)
  end
end

function PlayerUtils:GetPlayerPosition(Player)
  local OtherPlayerRootPart = PlayerUtils:GetRootPart(Player)
  if OtherPlayerRootPart then
    return OtherPlayerRootPart.Position
  end
end

function PlayerUtils:GetPlayerCFrame(Player)
  local OtherPlayerRootPart = PlayerUtils:GetRootPart(Player)
  if OtherPlayerRootPart then
    return OtherPlayerRootPart.CFrame
  end
end

return PlayerUtils