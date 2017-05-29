module Adjudicator exposing (..)

import Gameboard exposing (..)
import GameMap exposing (..)
import Map exposing (..)
import Utils exposing (..)


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


cutSupports : Gameboard -> MoveDirectives -> MoveDirectives
cutSupports gb mds =
    let
        cutIfSupporting p mds =
            case get p mds of
                Just (Support _) ->
                    set p Hold mds

                _ ->
                    mds
    in
        List.foldr cutIfSupporting mds (attackedPieces gb mds)


cutConvoys : Gameboard -> MoveDirectives -> MoveDirectives
cutConvoys gb mds =
    let
        cutIfConvoyingToOccupied p mds =
            case getCommand mds p of
                Convoy ( _, pid ) ->
                    if isOccupied gb pid then
                        set p Hold mds
                    else
                        mds

                _ ->
                    mds
    in
        List.foldr cutIfConvoyingToOccupied mds gb.pieces


calculatePowers : Gameboard -> MoveDirectives -> List ( Piece, MoveCommand, Int )
calculatePowers gb mds =
    let
        supportCommands =
            gb.pieces
                |> List.map (getCommand mds)
                |> List.filter isSupport

        destination p =
            case getCommand mds p of
                Hold ->
                    getProvinceIDOfPiece gb.gameMap p

                Advance lid ->
                    getProvinceID gb.gameMap lid

                Convoy ( _, pid ) ->
                    pid

                Support ( _, pid ) ->
                    pid

        supports supportCommand p =
            case supportCommand of
                Support ( p_, pid ) ->
                    p == p_ && destination p_ == pid

                _ ->
                    Debug.crash "supports called with non-support command!"

        countSupport p =
            List.foldr
                (\cmd ->
                    \n ->
                        if supports cmd p then
                            n + 1
                        else
                            n
                )
                0
                supportCommands

        getPower p =
            ( p, getCommand mds p, 1 + countSupport p )
    in
        List.map getPower gb.pieces


attackedPieces : Gameboard -> MoveDirectives -> List Piece
attackedPieces gb mds =
    let
        destinationOccupant p =
            case get p mds of
                Just (Advance lid) ->
                    getOccupant gb (getProvinceID gb.gameMap lid)

                _ ->
                    Nothing
    in
        gb.pieces
            |> List.map destinationOccupant
            |> List.foldr appendMaybe []


adjudicateRetreats : Gameboard -> RetreatInfo -> Gameboard
adjudicateRetreats gb rinfo =
    gb


adjudicateBuilds : Gameboard -> BuildInfo -> Gameboard
adjudicateBuilds gb binfo =
    gb
