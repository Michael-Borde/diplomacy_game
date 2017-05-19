module GameMap exposing (Piece, SupplyCenterID, ProvinceID, LocationID(..), canMove, convert, getAdjacencies)

import GameMapData as GMD exposing (Empire)


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

convert : GMD.GameMapData -> GameMap
convert gmd =
    List.concat (List.map processEmpire gmd)

processEmpire : (Maybe Empire, GMD.LandData) -> List Location
processEmpire (empire, provinces) =
    let locations = List.concat (List.map processProvinceData provinces) in
    List.map (\loc -> { loc | empire = empire }) locations

processProvinceData : GMD.ProvinceData -> List Location
processProvinceData pdata =
    case pdata of
        GMD.Capital (pid, locs) -> List.map (newLocation (Capital <| SupplyCenter pid)) locs
        GMD.Noncapital (pid, locs) -> List.map (newLocation (Noncapital pid)) locs

newLocation : ProvinceID -> GMD.Location -> Location
newLocation pid (locid, adj) =
    { lid = convertLocationID locid (provinceIDtoString pid)
    , empire = Nothing
    , pid = pid
    , adjancies = convertAdjacencies adj }

convertLocationID : GMD.LocationID -> String -> LocationID
convertLocationID loc provinceName =
    case loc of
        GMD.Coast ""    -> Coast provinceName
        GMD.Coast name  -> Coast (provinceName ++ " " ++ name)
        GMD.Land        -> Land provinceName
        GMD.Sea         -> Sea provinceName

convertAdjacencies : GMD.Adjacencies -> List LocationID
convertAdjacencies adj =
    List.map (\x -> convertLocationID (Tuple.second x) (Tuple.first x)) adj

provinceIDtoString : ProvinceID -> String
provinceIDtoString pid =
    case pid of
        Capital (SupplyCenter name) -> name
        Noncapital name -> name