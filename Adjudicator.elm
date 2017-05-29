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


wantsToFight : Gameboard -> MoveDirectives -> ProvinceID -> ProvinceID -> Piece -> Bool
wantsToFight gb mds origin destination p =
    case getCommand mds p of
        Hold ->
            getProvinceIDOfPiece gb.gameMap p == destination

        Advance lid ->
            (getProvinceIDOfPiece gb.gameMap p
                == destination
                && getProvinceID gb.gameMap lid
                == origin
            )
                || getProvinceID gb.gameMap lid
                == destination

        Convoy _ ->
            getProvinceIDOfPiece gb.gameMap p == destination

        _ ->
            False


adjudicateRetreats : Gameboard -> RetreatInfo -> Gameboard
adjudicateRetreats gb rinfo =
    let
        movePieces ( gb, ps ) =
            case ps of
                [] ->
                    gb

                p :: ps_ ->
                    if existsConflict p ps_ then
                        movePieces <| ( gb, filterConflicts p ps_ )
                    else
                        movePiece p <| movePieces ( gb, ps_ )

        movePiece p gb =
            case get p rinfo.retreatDirectives of
                Nothing ->
                    gb

                Just lid ->
                    let
                        newPiece =
                            case p of
                                Army pinfo ->
                                    Army { pinfo | location = lid }

                                Fleet pinfo ->
                                    Fleet { pinfo | location = lid }

                        pieces =
                            newPiece :: gb.pieces
                    in
                        { gb | pieces = pieces }

        getDestination p =
            Maybe.map (getProvinceID gb.gameMap) <| get p rinfo.retreatDirectives

        conflicts p1 p2 =
            getDestination p1 == getDestination p2

        existsConflict p ps =
            List.any (conflicts p) ps

        filterConflicts p ps =
            List.filter (\p_ -> not <| conflicts p p_) ps
    in
        movePieces ( gb, rinfo.retreatingPieces )


adjudicateBuilds : Gameboard -> BuildInfo -> Gameboard
adjudicateBuilds gb binfo =
    gb
