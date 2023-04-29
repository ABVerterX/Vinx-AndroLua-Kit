local Configuration = luajava.bindClass "android.content.res.Configuration"
local AppCompatActivity = luajava.bindClass "androidx.appcompat.app.AppCompatActivity"
local AppCompatDelegate = luajava.bindClass "androidx.appcompat.app.AppCompatDelegate"

local _M = {}

_M.isDarkThemeEnabled = function()
  local currentUiMode = activity.configuration.uiMode
    & Configuration.UI_MODE_NIGHT_MASK
  switch currentUiMode do
    case Configuration.UI_MODE_NIGHT_NO
      return false
    case Configuration.UI_MODE_NIGHT_YES
      return true
  end
end

_M.getDarkThemeMode = function()
  if luajava.instanceof(activity, AppCompatActivity) then
    return AppCompatDelegate.defaultNightMode
   else
    error("The Activity is not an AppCompat Activity! ", 0)
  end
end

return _M