require "utf8"

local sub = utf8.sub
local find = utf8.find
local lower = utf8.lower
local match = utf8.match
local String = luajava.bindClass "java.lang.String"

string.len = utf8.len
string.length = utf8.len
string.find = utf8.find
string.gsub = utf8.gsub
string.upper = utf8.upper
string.lower = utf8.lower

string.charAt = function(self, i)
  return sub(self, i, i)
end

string.codePointAt = function(str, i)
  return String(str).codePointAt(i - 1)
end

string.codePointBefore = function(str, i)
  return String(str).codePointBefore(i - 1)
end

string.codePointCount = function(str, start, ends)
  return String(str).codePointCount(start - 1, ends)
end

string.compareTo = function(str, comp)
  return String(str).compareTo(comp)
end

string.compareToIgnoreCase = function(str, comp)
  return String(str).compareToIgnoreCase(comp)
end

string.concat = function(str, add)
  return str..add
end

string.contains = match

string.endsWith = function(str, ends)
  return find(str, ends.."$") ~= nil
end

string.startsWith = function(str, start)
  return find(str, "^"..start) ~= nil
end

string.equalsIgnoreCase = function(str, comp)
  return lower(str) == lower(comp)
end

string.hashCode = function(str)
  return String(str).hashCode()
end

string.isEmpty = function(str)
  return (str == nil) or (#str == 0)
end

string.findLast = function(str)
  -- TODO()
end

string.toCharArray = function(str)
  local t = {}
  for i = 1, utf8.len(str) do
    table.insert(t, str:charAt(i))
  end
  return t
end

string.trim = function(str)
  return (str:gsub("^%s+", ""):gsub("%s+$", ""))
end

string.trimLeading = function(str)
  return (str:gsub("^%s+", ""))
end

string.trimTrailing = function(str)
  return (str:gsub("%s+$", ""))
end

string.isBlank = function(str)
  return str:trim() == ""
end

string.repeat = function(str, count)
  local t = ""
  for i = 1, count do
    t = t..str
  end
  return t
end

string.transform = function()
  -- TODO()
end

string.indent = function(str, count)
  local indent = string.repeat(" ", count)
  return (str:gsub("^", indent)
    :gsub("\n", "\n"..indent))
end 

-- @static
string.join = function(delimiter, ...)
  local result = ""
  local args = {...}
  
  if type(args[1]) == "table" then
    args = args[1]
  end

  for i = 1, #args do
    if i > 1 then
      result = result..delimiter
    end
    result = result..args[i]
  end
  return result
end

string.capitalize = function(str)
  return (str:gsub("^%l", utf8.upper, 1))
end

string.caseFold = function()
  -- TODO()
end

string.center = function()
  -- TODO()
end

string.expandTabs = function(self, size)
  return (self:gsub("\t", string.repeat(" ", size)))
end

-- isAlnum
-- isAlpha
-- isAscii
-- isDecimal
-- isDigit
-- isIdentifier
-- isLower
-- isNumeric
-- isPrintable
-- isTitle
-- isUpper
-- ljust
-- partition
-- removePrefix
-- removeSuffix
-- splitLines
-- swapCase
-- title

string.get = string.charAt
string.at = string.charAt
string.plus = string.concat
--string.forEach

string.isNone = function(self)
  return self == ""
end

-- at
-- random
-- reverse
-- slice
-- raw
-- padStart/End
-- ellipsize
-- trimToNull
-- trimToEmpty
-- strip..
-- countMatches
-- toBuffer
-- toBuilder


