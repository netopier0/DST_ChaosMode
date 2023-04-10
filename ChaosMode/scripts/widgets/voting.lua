local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"

local VoteButtonWidget = Class(Widget, function (self, mapscale)
    Widget._ctor(self, "VoteButtonWidget")
    self.owner = ThePlayer

    self.button = self:AddChild(ImageButton())

    local coords_w, coords_h = self.button:GetSize()
    coords_w, coords_h = coords_w * mapscale, coords_h * mapscale

    self.coordssize = {
        w = coords_w,
        h = coords_h
    }

    self.button:SetScale(1, 1, 1)
    self.button:SetText("My Vote Button")
    self.button:SetTextSize(25)
    self.button:SetClickable(false)
    self.button:Show()
end)

return VoteButtonWidget
