module GameMapGraphics exposing (..)

import GameMap as GM
import GameMapData as GMD

type alias GameMapGraphics =
    { empireColors : List EmpireColor
    , supplyCenters : List SupplyCenter
    , provinces : List ProvinceInfo
    }

type alias EmpireColor =
    { empire : GM.Empire
    , color : String
    }

type alias SupplyCenter =
    { supplyCenterID : String
    , supplyCenterCoordinates : (Int, Int)
    }

type alias ProvinceInfo =
    { provinceID : GM.ProvinceID
    , polygon : String
    , empire : Maybe GM.Empire
    , pieceLocation : (Int, Int)
    }

---------------------------------------

convert : GMD.GameMapData -> GameMapGraphics
convert gmd =
    Debug.crash "poop"

convertEmpireColors : List GMD.EmpireColor -> List EmpireColor
convertEmpireColors xs =
    List.map (\x -> { empire = GM.Empire x.empire
                    , color = x.color }) xs

convertSupplyCenters : List GMD.SupplyCenterData -> List SupplyCenter
convertSupplyCenters xs =
    List.map (\x -> { supplyCenterID = x.supplyCenterID
                    , supplyCenterCoordinates = x.supplyCenterCoordinates}) xs

convertProvinces : List (Maybe GMD.EmpireID, GMD.LandData) -> List ProvinceInfo
convertProvinces xs =
    List.concat (List.map convertProvince xs)

convertProvince : (Maybe GMD.EmpireID, GMD.LandData) -> List ProvinceInfo
convertProvince (eid, land) =
    List.map
    (\province ->
        case province of
            GMD.Capital (pid, _, ginfo)     ->
                createProvinceInfo eid (provinceDataToPID province) ginfo
            GMD.Noncapital (pid, _, ginfo)  ->
                createProvinceInfo eid (provinceDataToPID province) ginfo
        )
    land

createProvinceInfo : Maybe GMD.EmpireID -> GM.ProvinceID -> GMD.GraphicsInfo -> ProvinceInfo
createProvinceInfo eid pid ginfo =
    { provinceID = pid
    , polygon = ginfo.polygon
    , empire = Maybe.map GM.Empire eid
    , pieceLocation = ginfo.coordinates
    }

provinceDataToPID : GMD.ProvinceData -> GM.ProvinceID
provinceDataToPID province =
    case province of
        GMD.Capital (pid, _, _)     -> GM.Capital (GM.SupplyCenter pid)
        GMD.Noncapital (pid, _, _)  -> GM.Noncapital pid
