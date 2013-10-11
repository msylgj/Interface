Qulight = { }

_, myclass = UnitClass("player") 
myname, _ = UnitName("player")
resolution = GetCurrentResolution()
getscreenresolution = select(resolution, GetScreenResolutions())
version = GetAddOnMetadata("oUF_Qulight", "Version")
dummy = function() return end
client = GetLocale() 
incombat = UnitAffectingCombat("player")
patch = GetBuildInfo()
level = UnitLevel("player")
myrealm = GetRealmName()