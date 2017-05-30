module GameMapGraphics exposing (..)

import GameMap as GM
import GameMapData as GMD
import Europe as TheMap

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
    , terrainType : GMD.TerrainType
    }

---------------------------------------

convert : GMD.GameMapData -> GameMapGraphics
convert gmd =
    { empireColors = convertEmpireColors gmd.empireColors
    , supplyCenters = convertSupplyCenters gmd.supplyCenters
    , provinces = convertProvinces (List.reverse gmd.mapData)  -- Reverse to get seas first
    }

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
    , terrainType = ginfo.terrainType
    }

provinceDataToPID : GMD.ProvinceData -> GM.ProvinceID
provinceDataToPID province =
    case province of
        GMD.Capital (pid, _, _)     -> GM.Capital (GM.SupplyCenter pid)
        GMD.Noncapital (pid, _, _)  -> GM.Noncapital pid

-----------------------------

freshGraphics : GameMapGraphics
freshGraphics = convert TheMap.gameMapData
