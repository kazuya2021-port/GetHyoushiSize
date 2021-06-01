-- PhotoshopController.applescript
-- TrimmingTool

-- Created by 内山　和也 on 平成27/04/20.
-- Copyright 2015 __MyCompanyName__. All rights reserved.

script PhotoshopController
	property parent : class "NSObject"
	property _params : class "NSArray"
	property _dpi : 0
    property _spath : ""
	
	on setParams_(p)
		set _params to p
	end setParams_
	
	-- 解像度
	on setDPI(d)
		set dd to d as text
		set _dpi to dd as number
	end setDPI
	
    on setSavePath(p)
        set _spath to p
    end setSavePath
	
	-- 内部関数 ------------------------------------------------------------------
	-- PhotoShopの定規単位を設定
	-- パラメータ：cm units/inch units/mm units/percent units/pixel units/point units
	on setRulerPref_(myRuler)
		tell application "Adobe Photoshop CS5.1"
			set ruler units of settings to myRuler
		end tell
	end setRulerPref_
	
	on ChangeRulerToPXL_()
		tell application "Adobe Photoshop CS5.1" to setRulerPref_(pixel units) of me
		return true
	end ChangeRulerToPXL_
	
	on pointTomm(p)
		return (p * 0.35278) as text
	end pointTomm
	
	on open_image_(filePath)
		set aFile to filePath as text
		set aexpitem to do shell script "fpath=" & quoted form of aFile & ";fext=\"${fpath##*.}\" ; echo $fext"
		
		with timeout of (1 * 60 * 60) seconds
        tell application "Adobe Photoshop CS5.1"
            set display dialogs to never
            open alias aFile with options {class:PDF open options, mode:grayscale, resolution:_dpi, use antialias:false, page:1, constrain proportions:true, crop page:media box}
        end tell
    end timeout
end open_image_
-- 公開関数 ------------------------------------------------------------------
on saveImage_(filePath)
    with timeout of (1 * 60 * 60) seconds
    setDPI(item 1 of _params)
    setSavePath(item 2 of _params)
    --set fname to filePath as string
    
    tell application "Adobe Photoshop CS5.1"
        display dialogs filePath
        my open_image_(filePath)
        set saveFile to (_spath & "/tmp.tif") as string
        set myOptions to {class:TIFF save options, byte order:Mac OS, embed color profile:false, image compression:LZW, save layers:true, save spot colors:true}
        save in file saveFile as TIFF with options myOptions with copying
        close without saving
    end tell
    end timeout
end saveImage_

end script
