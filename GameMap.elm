module GameMap exposing (Piece, SupplyCenterID, ProvinceID, LocationID, canMove)

import GameMapData exposing (..)


type alias GameMap =
    {
    }

type Piece
    = Army PieceInfo
    | Fleet PieceInfo

type alias PieceInfo =
    { empire : Empire
    , location : LocationID
    }

type ProvinceID
    = Capital SupplyCenterID
    | Noncapital String

type SupplyCenterID = SupplyCenter String

type LocationID 
    = Coast String ProvinceID
    | Sea ProvinceID 
    | Land ProvinceID

getPieceInfo : Piece -> PieceInfo
getPieceInfo piece = case piece of
    Army po -> po
    Fleet po -> po

getAdjacencies : GameMap -> LocationID -> List LocationID
getAdjacencies gm lid = Debug.crash("TODO")


canMove : GameMap -> Piece -> LocationID -> Bool
canMove gm p lid = List.member lid <| getAdjacencies gm (getPieceInfo p).location


convert : GameMapData -> GameMap
convert gmd = Debug.crash "TODO"