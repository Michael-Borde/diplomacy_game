module GameMap exposing (..)

import Utils exposing (..)
import GameMapData as GMD


type Empire
    = Empire String


type alias GameMap =
    List Location


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


type SupplyCenterID
    = SupplyCenter String


getPieceInfo : Piece -> PieceInfo
getPieceInfo piece =
    case piece of
        Army po ->
            po

        Fleet po ->
            po


getAdjacencies : GameMap -> LocationID -> List LocationID
getAdjacencies gm lid =
    let
        location =
            getLocation gm lid
    in
        location.adjancies


getNaturalOwner : GameMap -> LocationID -> Maybe Empire
getNaturalOwner gm lid =
    let
        location =
            getLocation gm lid
    in
        location.empire


getLocation : GameMap -> LocationID -> Location
getLocation gm lid =
    case List.head (List.filter (\loc -> loc.lid == lid) gm) of
        Nothing ->
            let _ = Debug.log "LID: " lid in
            Debug.crash "LocationID not found"

        Just loc ->
            loc


getMoves : GameMap -> Piece -> List LocationID
getMoves gm p =
    getAdjacencies gm (getPieceInfo p).location


canMove : GameMap -> Piece -> LocationID -> Bool
canMove gm p lid =
    List.member lid <| getAdjacencies gm (getPieceInfo p).location


getMovesToProvinces : GameMap -> Piece -> List ProvinceID
getMovesToProvinces gm p =
    removeRepeats <| List.map (getProvinceID gm) (getMoves gm p)


canMoveToProvince : GameMap -> Piece -> ProvinceID -> Bool
canMoveToProvince gm p pid =
    List.any identity <| List.map (.lid >> canMove gm p) (getLocations gm pid)


getProvinceID : GameMap -> LocationID -> ProvinceID
getProvinceID gm lid =
    let
        location =
            getLocation gm lid
    in
        location.pid


isCapital : GameMap -> LocationID -> Bool
isCapital gm lid =
    let
        province =
            getProvinceID gm lid
    in
        case province of
            Capital _ ->
                True

            Noncapital _ ->
                False


getLocations : GameMap -> ProvinceID -> List Location
getLocations gm pid =
    List.filter (\loc -> loc.pid == pid) gm



-------------------------------------------------------


convert : GMD.GameMapData -> GameMap
convert gmd =
    List.concat (List.map processEmpire gmd.mapData)


processEmpire : ( Maybe GMD.EmpireID, GMD.LandData ) -> List Location
processEmpire ( maybeEmpireID, provinces ) =
    let
        locations =
            List.concat (List.map processProvinceData provinces)
    in
        List.map (\loc -> { loc | empire = Maybe.map Empire maybeEmpireID }) locations


processProvinceData : GMD.ProvinceData -> List Location
processProvinceData pdata =
    case pdata of
        GMD.Capital ( pid, locs, _ ) ->
            List.map (newLocation (Capital <| SupplyCenter pid)) locs

        GMD.Noncapital ( pid, locs, _ ) ->
            List.map (newLocation (Noncapital pid)) locs


newLocation : ProvinceID -> ( GMD.LocationID, GMD.Adjacencies ) -> Location
newLocation pid ( locid, adj ) =
    { lid = convertLocationID ( (provinceIDtoString pid), locid )
    , empire = Nothing
    , pid = pid
    , adjancies = convertAdjacencies adj
    }


convertLocationID : ( GMD.ProvinceID, GMD.LocationID ) -> LocationID
convertLocationID ( pid, lid ) =
    case lid of
        GMD.Coast "" ->
            Coast pid

        GMD.Coast name ->
            Coast (pid ++ " " ++ name)

        GMD.Land ->
            Land pid

        GMD.Sea ->
            Sea pid


convertAdjacencies : GMD.Adjacencies -> List LocationID
convertAdjacencies adj =
    List.map convertLocationID adj


provinceIDtoString : ProvinceID -> String
provinceIDtoString pid =
    case pid of
        Capital (SupplyCenter name) ->
            name

        Noncapital name ->
            name


getProvinceIDOfPiece : GameMap -> Piece -> ProvinceID
getProvinceIDOfPiece gm p =
    getProvinceID gm (getPieceInfo p).location



------------------------------------


getStartingPieces : GameMap -> GMD.GameMapData -> List Piece
getStartingPieces gm gmd =
    List.map (convertPiece gm) gmd.startingPieces


convertPiece : GameMap -> GMD.Piece -> Piece
convertPiece gm piece =
    let
        locID =
            convertLocationID piece
    in
        let
            empire =
                getNaturalOwner gm locID |> crashIfNothing
        in
            let
                pieceInfo =
                    { empire = empire, location = locID }
            in
                case locID of
                    Land _ ->
                        Army pieceInfo

                    Coast _ ->
                        Fleet pieceInfo

                    Sea _ ->
                        Fleet pieceInfo


crashIfNothing : Maybe a -> a
crashIfNothing ma =
    case ma of
        Just a ->
            a

        Nothing ->
            Debug.crash "Crash if Nothing"



------------------------------------


getEmpireTurnOrder : GMD.GameMapData -> List Empire
getEmpireTurnOrder =
    .turnOrder >> List.map Empire


getEmpireString : Empire -> String
getEmpireString (Empire e) =
    e



------------------------------------


owns : Empire -> Piece -> Bool
owns e p =
    case p of
        Fleet info ->
            info.empire == e

        Army info ->
            info.empire == e


getOwner : Piece -> Empire
getOwner p =
    (getPieceInfo p).empire


getSupplyCenterIDs : GameMap -> List SupplyCenterID
getSupplyCenterIDs gm =
    let
        partialMap l =
            case l.pid of
                Capital scid ->
                    Just scid

                _ ->
                    Nothing
    in
        removeRepeats <| List.filterMap partialMap gm


getSupplyCenterIDsOfEmpire : GameMap -> Empire -> List SupplyCenterID
getSupplyCenterIDsOfEmpire gm e =
    let
        partialMap l =
            if l.empire == Just e then
                case l.pid of
                    Capital scid ->
                        Just scid

                    _ ->
                        Nothing
            else
                Nothing
    in
        removeRepeats <| List.filterMap partialMap gm
