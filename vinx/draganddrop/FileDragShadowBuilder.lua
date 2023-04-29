require "import"
local Paint              = import "android.graphics.Paint"
local FrameLayout        = import "android.widget.FrameLayout"
local MeasureSpec        = import "android.view.View$MeasureSpec"
local DragShadowBuilder  = import "android.view.View$DragShadowBuilder"
local AppCompatImageView = import "androidx.appcompat.widget.AppCompatImageView"
local MaterialTextView   = import "com.google.android.material.textview.MaterialTextView"
local MaterialCardView   = import "com.google.android.material.card.MaterialCardView"
local UiUtils            = import "vinx.view.UiUtils"
local Layout             = import "vinx.view.Layout"

local SCREEN_HEIGHT = activity.height

local RADIUS = UiUtils.dp2px(4)
local MARGIN = UiUtils.dp2px(16)
local WIDTH  = UiUtils.dp2px(192)
local HEIGHT = UiUtils.dp2px(48)

local CONTAINER_WIDTH = WIDTH + MARGIN * 2
local CONTAINER_HEIGHT = HEIGHT + MARGIN * 2

local SHADOW_RADIUS_START = UiUtils.dp2px(2)
local SHADOW_RADIUS       = UiUtils.dp2px(4 - 2)
local KEY_SHADOW_DY_START = UiUtils.dp2px(2)
local KEY_SHADOW_DY       = UiUtils.dp2px(6 - 2)
local AMBIENT_SHADOW_DY_START = UiUtils.dp2px(0)
local AMBIENT_SHADOW_DY       = UiUtils.dp2px(2 - 0)

local PAINT_KEY_SHADOW = Paint()
.setAntiAlias(true)
.setColor(0xFFFFFFFF)
.setStyle(Paint.Style.FILL)

local PAINT_AMBIENT_SHADOW = Paint()
.setAntiAlias(true)
.setColor(0xFFFFFFFF)
.setStyle(Paint.Style.FILL)

local LAYOUT = {
  FrameLayout,
  layout_width = WIDTH,
  layout_height = HEIGHT,
  {
    AppCompatImageView,
    layout_width = "24dp",
    layout_height = "24dp",
    layout_margin = "12dp",
    src = "images/file-code-outline.png",
    colorFilter = 0xff1a73e8,
  },
  {
    MaterialTextView,
    layout_width = "match",
    layout_height = "match",
    layout_marginStart = HEIGHT,
    layout_marginEnd = "12dp",
    gravity = "center|start",
    singleLine = true,
    textSize = "16sp",
    text = "Copy main.lua",
    textColor = 0xFF000000,
    typeface = Fonts.text500,
  },
  {
    MaterialCardView,
    layout_width = "4dp",
    layout_height = "match",
    layout_margin = "8dp",
    layout_gravity = "center|end",
    cardBackgroundColor = 0xFFE0E0E0,
    radius = "2dp",
    elevation = 0,
  }
}
        
return function()
  --import "com.google.android.material.card.MaterialCardView"  
  local view = Layout.load(LAYOUT)
  
  return luajava.override(DragShadowBuilder, {
    onProvideShadowMetrics = function(_, point, point2)
      point.set(CONTAINER_WIDTH, CONTAINER_HEIGHT)
      point2.set(CONTAINER_WIDTH - MARGIN - UiUtils.dp2px(8),
        CONTAINER_HEIGHT - MARGIN - UiUtils.dp2px(8))
    end,

    onDrawShadow = function(_, canvas)
      local bounds = canvas.clipBounds
      local left = bounds.left + MARGIN
      local top = bounds.top + MARGIN
      local right = bounds.right - MARGIN
      local bottom = bounds.bottom - MARGIN
      
      --local posY = 0.5 * (bounds.top + bounds.bottom) / SCREEN_HEIGHT
      --print(bounds.bottom)
   --   posY = 9
  --    print(posY)
      
      PAINT_KEY_SHADOW.setShadowLayer(
        SHADOW_RADIUS_START + SHADOW_RADIUS * posY,
        0,
        KEY_SHADOW_DY_START + KEY_SHADOW_DY * posY,
        0x15000000
      )    
      PAINT_AMBIENT_SHADOW.setShadowLayer(
        SHADOW_RADIUS_START + SHADOW_RADIUS * posY,
        0,
        AMBIENT_SHADOW_DY_START + AMBIENT_SHADOW_DY * posY,
        0x35000000
      )    
    
      canvas
      .translate(0, 0)
      .drawRoundRect(
        left, top, right, bottom,
        RADIUS, RADIUS, PAINT_KEY_SHADOW
      )
      .drawRoundRect(
        left, top, right, bottom,
        RADIUS, RADIUS, PAINT_AMBIENT_SHADOW
      )
      .translate(MARGIN, MARGIN)  
          
      view
      .measure(
        MeasureSpec.makeMeasureSpec(WIDTH, MeasureSpec.EXACTLY),
        MeasureSpec.makeMeasureSpec(HEIGHT, MeasureSpec.EXACTLY)
      )
      .layout(left, top, right, bottom)
      .draw(canvas)       
    end
   -- getView = function(_)
  --    return view
--    end
  }, view)  
end