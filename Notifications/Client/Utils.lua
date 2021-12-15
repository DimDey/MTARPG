function dxDrawBorderedText (outline, outlineColor, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    for oX = (outline * -1), outline, 2 do
        for oY = (outline * -1), outline, 2 do
            local outlineAlpha = outlineColor.a / 12
            dxDrawText (text, left + oX, top + oY, right + oX, bottom + oY, tocolor(outlineColor.r, outlineColor.g, outlineColor.b, outlineAlpha), scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
end

function math.clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end