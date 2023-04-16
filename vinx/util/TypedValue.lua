local _M = {

  COMPLEX_UNIT_PX = 0,

  COMPLEX_UNIT_DIP = 1,

  COMPLEX_UNIT_SP = 2,

  COMPLEX_UNIT_PT = 3,

  COMPLEX_UNIT_IN = 4,

  COMPLEX_UNIT_MM = 5

}

local function updateDisplayMetrics(metrics)

  _M.metrics = metrics

  _M.density = _M.metrics.density

  _M.scaledDensity = _M.metrics.scaledDensity

  _M.xdpi = _M.metrics.xdpi

end

local UNITS_CONVERTER = table.const {

  [0] = function(v)

    return v

  end,

  [1] = function(v)

    return v * _M.density

  end,

  [2] = function(v)

    return v * _M.scaledDensity

  end,

  [3] = function(v)

    return _M.xdpi * v * 0.013888889

  end,

  [5] = function(v)

    return _M.xdpi * v * 0.03937008

  end,

  [4] = function(v)

    return _M.xdpi * v

  end,

}

_M.applyDimension = function(unit, value, metrics)

  if (metrics && metrics ~= _M.metrics) then

    updateDisplayMetrics(metrics)

  end

  return UNITS_CONVERTER[unit](value)

end

updateDisplayMetrics(activity.resources.displayMetrics)

return _M
