require "import"

import "klass"
import "android.widget.Space"
import "android.view.MotionEvent"
import "android.view.View"
import "android.view.ViewConfiguration"
import "android.animation.ObjectAnimator"
import "android.content.res.ColorStateList"
import "androidx.interpolator.view.animation.LinearOutSlowInInterpolator"
import "androidx.interpolator.view.animation.FastOutLinearInInterpolator"
import "com.google.android.material.circularreveal.CircularRevealFrameLayout"
import "com.google.android.material.circularreveal.CircularRevealCompat"
import "com.google.android.material.circularreveal.CircularRevealWidget$CircularRevealScrimColorProperty"
import "com.google.android.material.textview.MaterialTextView"
import "com.google.android.material.switchmaterial.SwitchMaterial"
import "com.google.android.material.animation.ArgbEvaluatorCompat"
import "vinx.view.UiUtils"
import "vinx.view.Layout"

--[[
已知 Bug：
CircularReveal 动画可能在播放到一半时卡一下
SwitchMaterial 涟漪颜色存在问题
Animator 不被复用

动画参数尚在优化中…
]]

local LAYOUT = {
  CircularRevealFrameLayout,
  backgroundColor = 0xFF5F6368,
  {
    CircularRevealFrameLayout,
    layout_width = "100%w",
    layout_height = "56dp",
    visibility = "invisible",
  },
  {
    MaterialTextView,
    layout_gravity = "center|start",
    layout_marginStart="16dp",
    textColor = 0xFFFFFFFF,
    textSize = "16sp",
  },
  {
    SwitchMaterial,
    layout_gravity="center|end",
    layout_marginEnd="12dp",
    thumbTintList = ColorStateList.valueOf(0xFFFFFFFF),
    trackTintList = ColorStateList.valueOf(0x35FFFFFF),
    --enabled = false,
    --  checked=true
  },
  {
    Space,
    layout_width = "100%w",
    layout_height = "56dp",
   -- backgroundColor = 0xFF1A73E8,
    backgroundColor = 0xFF6200EE,
  },
}


local RADIUS = 1.1 * 0.5 * math.sqrt(activity.width ^ 2 + UiUtils.dp2px(56))
        
return class {
  name = "vinx.material.switchbar.SwitchBar",

  extends = CircularRevealFrameLayout,
  constructor = function(super, ...)
  
    local resId = android.R.attr.selectableItemBackground
    local drawableId = activity
      .obtainStyledAttributes({resId})
      .getResourceId(0,0)
    local drawable = activity
    .resources
    .getDrawable(drawableId)
    .setColor(ColorStateList.valueOf(0x1FFFFFFF))
  
    local view = Layout.load(LAYOUT)
    .setForeground(drawable)
    
    local materialSwitch = view.getChildAt(2)
    local space = view.getChildAt(3)
    local revealOverlay = view.getChildAt(0)
   
    local startX, startY
    local isRootClicked 
    local touchSlop = ViewConfiguration
    .get(activity).scaledTouchSlop
    
    view.onTouch = function(_, event)   
      switch event.action do
      
       case MotionEvent.ACTION_DOWN
        materialSwitch.setPressed(true)        
        startX = event.x
        startY = event.y
        
       case MotionEvent.ACTION_UP
        materialSwitch.setPressed(false)       
        local dX = event.x - startX
        local dY = event.y - startY
        
        if math.sqrt(dX ^ 2 + dY ^ 2) <= touchSlop then
          view.callOnClick()
          isRootClicked = true
          
          if materialSwitch.checked then
            CircularRevealCompat
            .createCircularReveal(revealOverlay,
             event.x, event.y, RADIUS, 0)
            .setDuration(325)
            .setInterpolator(LinearOutSlowInInterpolator())
            .start()
            .addListener {
              onAnimationEnd = function(_)
                revealOverlay.setVisibility(View.INVISIBLE)
                isRootClicked = false
              end,
            }
            
            ObjectAnimator
            .ofArgb(revealOverlay,
              CircularRevealScrimColorProperty
              .CIRCULAR_REVEAL_SCRIM_COLOR,
              {space.background.color, 0})
            .setDuration(325)
            .setEvaluator(ArgbEvaluatorCompat())
            .setInterpolator(LinearOutSlowInInterpolator())
            .start()
            
           else
            revealOverlay.setVisibility(View.VISIBLE)            
            CircularRevealCompat
            .createCircularReveal(revealOverlay,
             event.x, event.y, 0, RADIUS)
            .setDuration(325)
            .setInterpolator(FastOutLinearInInterpolator())
            .start()
            .addListener {
              onAnimationEnd = function(_)
                revealOverlay.setVisibility(View.VISIBLE)
                isRootClicked = false
              end,
            }
            
            ObjectAnimator
            .ofArgb(revealOverlay,
              CircularRevealScrimColorProperty
              .CIRCULAR_REVEAL_SCRIM_COLOR,
              {0, space.background.color})
            .setDuration(375)
            .setEvaluator(ArgbEvaluatorCompat())
            .setInterpolator(FastOutLinearInInterpolator())
            .start()
            
          end
          materialSwitch.toggle()
        end 
      end
    end
    
    view.onClick = function(_) end

    materialSwitch.setOnCheckedChangeListener(function(v, checked)    
      if isRootClicked then return end    
      local x = (v.left + v.right) / 2
      local y = (v.top + v.bottom) / 2            
    
      if !checked then
        CircularRevealCompat
        .createCircularReveal(revealOverlay,
          x, y, RADIUS, 0)
        .setDuration(425)
        .setInterpolator(LinearOutSlowInInterpolator())
        .start()
        .addListener {
          onAnimationEnd = function(_)
            revealOverlay.setVisibility(View.INVISIBLE)
          end,
        }
        
        ObjectAnimator
        .ofArgb(revealOverlay,
          CircularRevealScrimColorProperty
          .CIRCULAR_REVEAL_SCRIM_COLOR,
          {space.background.color, 0})
        .setDuration(425)
        .setEvaluator(ArgbEvaluatorCompat())
        .setInterpolator(LinearOutSlowInInterpolator())
        .start()
            
       else
        revealOverlay.setVisibility(View.VISIBLE)            
        CircularRevealCompat
        .createCircularReveal(revealOverlay,
          x, y, 0, RADIUS)
        .setDuration(325)
        .setInterpolator(FastOutLinearInInterpolator())
        .start()
        .addListener {
          onAnimationEnd = function(_)
            revealOverlay.setVisibility(View.VISIBLE)
          end,
        }
        
        ObjectAnimator
        .ofArgb(revealOverlay,
          CircularRevealScrimColorProperty
          .CIRCULAR_REVEAL_SCRIM_COLOR,
          {0, space.background.color})
        .setDuration(275)
        .setEvaluator(ArgbEvaluatorCompat())
        .setInterpolator(FastOutLinearInInterpolator())
        .start()            
      end 
    end)
    
    return view
  end,
  
  fields = {
    textView = NULL,
  },
  
  methods = {
    setText = function(self, text)
      if !self.textView self.initView() end
      self.textView.setText(text)
      return self
    end,
    
    getText = function(self)
      if !self.textView self.initView() end
      return self.textView.text
    end,
  
    setTypeface = function(self, typeface)
      if !self.textView self.initView() end
      self.textView.setTypeface(typeface)
      return self
    end,
    
    setRevealColor = function(self, color)
      self.getChildAt(3).setBackgroundColor(color)
      return self
    end,
    
    initView = function(self)
      self.textView = self.getChildAt(1)
    end, 
  }
}