module Adjudicator exposing (..)

import Gameboard exposing (..)
import GameMap exposing (..)
import Map exposing (..)


updateSupplyCenters : Gameboard -> Gameboard
updateSupplyCenters gb =
    let
        update p scs =
            case getProvinceID gb.gameMap <| (getPieceInfo p).location of
                Capital scid ->
                    set scid (Just (getOwner p)) scs

                _ ->
                    scs

        supplyCenters =
            List.foldr update gb.supplyCenters gb.pieces
    in
        { gb | supplyCenters = supplyCenters }


adjudicateMoves : Gameboard -> MoveInfo -> ( Gameboard, List Piece )
adjudicateMoves gb minfo =
    ( gb, [] )


adjudicateRetreats : Gameboard -> RetreatInfo -> Gameboard
adjudicateRetreats gb rinfo =
    gb


adjudicateBuilds : Gameboard -> BuildInfo -> Gameboard
adjudicateBuilds gb binfo =
    gb
