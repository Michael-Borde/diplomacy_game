module Gameboard exposing (..)

import Map exposing (Map, get, set)
import GameMap exposing (..)
import Utils exposing (..)


type alias Gameboard =
    { gameMap : GameMap
    , turnOrder : Turn
    , date : Date
    , phase : Phase
    , turn : Turn
    , pieces : List Piece
    , supplyCenters : Map SupplyCenterID (Maybe Empire)
    }


type Date
    = Spring Int
    | Autumn Int


type Phase
    = Move MoveInfo
    | Retreat RetreatInfo
    | Build BuildInfo


type alias Turn =
    List Empire


type alias BuildInfo =
    { buildDirectives : BuildDirectives
    , disbandDirectives : DisbandDirectives
    }


type alias RetreatInfo =
    { retreatDirectives : RetreatDirectives
    , retreatingPieces : List Piece
    }


type alias MoveInfo =
    { moveDirectives : MoveDirectives
    }


type alias MoveDirectives =
    Map Piece MoveCommand


type alias MoveDirective =
    ( Piece, MoveCommand )


type MoveCommand
    = Hold
    | Advance LocationID
    | Support ( Piece, ProvinceID )
    | Convoy ( Piece, LocationID )


type alias RetreatDirectives =
    Map Piece LocationID


type alias RetreatDirective =
    ( Piece, LocationID )


type alias BuildDirectives =
    Map SupplyCenterID (Maybe Piece)


type alias DisbandDirectives =
    Map Piece Bool


type alias BuildDirective =
    ( SupplyCenterID, Maybe Piece )


type alias DisbandDirective =
    ( Piece, Bool )


getCurrentEmpire : Gameboard -> Empire
getCurrentEmpire gb =
    case gb.turn of
        [] ->
            Debug.crash "something went wrong - no empire!"

        e :: _ ->
            e


getPiecesOfCurrentEmpire : Gameboard -> List Piece
getPiecesOfCurrentEmpire gb =
    let
        empire =
            getCurrentEmpire gb
    in
        List.filter (owns empire) gb.pieces


getAdjacentPieces : Gameboard -> ProvinceID -> List Piece
getAdjacentPieces gb pid =
    List.filter (\p -> canMoveToProvince gb.gameMap p pid) gb.pieces


getOccupant : Gameboard -> ProvinceID -> Maybe Piece
getOccupant gb pid =
    firstTo (\p -> getProvinceIDOfPiece gb.gameMap p == pid) gb.pieces


getSupplyCenterIDsOfCurrentEmpire : Gameboard -> List SupplyCenterID
getSupplyCenterIDsOfCurrentEmpire gb =
    getSupplyCenterIDsOfEmpire gb.gameMap (getCurrentEmpire gb)
