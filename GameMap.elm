module GameMap exposing (Piece, SupplyCenterID, ProvinceID, LocationID, canMove)

import GameMapData


type alias GameMap = List Location

type Piece
    = Army PieceInfo
    | Fleet PieceInfo

type alias PieceInfo =
    { empire : Empire
    , location : LocationID
    }

type alias Location =
    { lid : LocationID
    , empire : Maybe Empire
    , pid : ProvinceID
    , adjancies : List LocationID
    }

type LocationID
    = Coast String
    | Sea String
    | Land String

type ProvinceID
    = Capital SupplyCenterID
    | Noncapital String

type SupplyCenterID = SupplyCenter String

getPieceInfo : Piece -> PieceInfo
getPieceInfo piece = case piece of
    Army po -> po
    Fleet po -> po

getAdjacencies : GameMap -> LocationID -> List LocationID
getAdjacencies gm lid =
    let location = getLocation gm lid in
    location.adjancies

getNaturalOwner : GameMap -> LocationID -> Maybe Empire
getNaturalOwner gm lid =
    let location = getLocation gm lid in
    location.empire

getLocation : GameMap -> LocationID -> Location
getLocation gm lid =
    case List.head (List.filter (\loc -> loc.lid == lid) gm) of
        Nothing -> Debug.crash "LocationID not found"
        Just loc -> loc

getMoves : GameMap -> Piece -> List LocationID
getMoves gm p = getAdjacencies gm (getPieceInfo p).location

canMove : GameMap -> Piece -> LocationID -> Bool
canMove gm p lid = List.member lid <| getAdjacencies gm (getPieceInfo p).location

convert : GameMapData -> GameMap
convert gmd =
    List.concat (List.map processEmpire gmd)

processEmpire : (Maybe Empire, GameMapData.LandData) -> List Location
processEmpire (empire, provinces) =
    let locations = List.concat (List.map processProvinceData provinces) in
    List.map (\loc -> { loc | empire = empire }) locations

processProvinceData : ProvinceData -> List Location
processProvinceData pdata =
    case pdata of
        Capital (pid, locs) -> List.map (newLocation (Capital pid)) locs
        | Noncapital (pid, locs) -> List.map (newLocation (Noncapital pid)) locs

newLocation : ProvinceID -> GameMapData.Location -> Location
newLocation pid (locid, adj) =
    { lid = convertLocationID locid (provinceIDtoString pid)
    , empire = Nothing
    , pid = pid
    , adjancies = convertAdjacencies adj }

convertLocationID : GameMapData.LocationID -> String -> LocationId
convertLocationID loc provinceName =
    case loc of
        Coast name  -> Coast (provinceName + " " + name)
        | Land      -> Land provinceName
        | Sea       -> Sea provinceName

convertAdjacencies : GameMapData.Adjacencies -> List LocationID
convertAdjacencies adj =
    List.map (\x -> convertLocationID (Tuple.second x) (Tuple.first x)) adj

provinceIDtoString : ProvinceID -> String
provinceIDtoString pid =
    case pid of
        Capital name -> name
        Noncapital name -> name