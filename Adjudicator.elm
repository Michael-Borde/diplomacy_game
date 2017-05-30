module Adjudicator exposing (..)

import Gameboard exposing (..)
import GameMap exposing (..)
import Map exposing (..)
import Utils exposing (..)


type alias AdjudicationInfo =
    { gameboard : Gameboard
    , powerLevels : List PowerLevel
    , dislodgedPieces : List Piece
    }


type alias PowerLevel =
    ( Int, List MoveDirective )


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
    let
        _ =
            Debug.log "Adjudicating moves!" Nothing

        withSupportCut =
            cutSupports gb minfo.moveDirectives

        _ =
            Debug.log "With support cut: " withSupportCut

        withConvoysBlocked =
            blockConvoys gb withSupportCut

        _ =
            Debug.log "withConvoysBlocked: " withConvoysBlocked

        powerLevels =
            calculatePowerLevels gb withConvoysBlocked

        -- _ =
        -- Debug.log "Initial power levels: " powerLevels
        final =
            applyUntilIdempotent adjudicationStep { gameboard = gb, powerLevels = powerLevels, dislodgedPieces = [] }

        -- _ =
        --     Debug.log "Final power levels: " final.powerLevels
    in
        ( final.gameboard, final.dislodgedPieces )


collide : Gameboard -> MoveDirective -> MoveDirective -> Bool
collide gb md1 md2 =
    let
        ( o1, d1 ) =
            toOriginDestination gb md1

        ( o2, d2 ) =
            toOriginDestination gb md2
    in
        d1 == d2 || (o1 == d2) && (o2 == d1)


toOriginDestination : Gameboard -> MoveDirective -> ( ProvinceID, ProvinceID )
toOriginDestination gb ( p, mc ) =
    ( getProvinceIDOfPiece gb.gameMap p, getDestination gb ( p, mc ) )


getTopPowerLevel : AdjudicationInfo -> PowerLevel
getTopPowerLevel adjInfo =
    Maybe.withDefault ( 1, [] ) <| List.head adjInfo.powerLevels


changeGameboard : (Gameboard -> Gameboard) -> AdjudicationInfo -> AdjudicationInfo
changeGameboard f adjInfo =
    { adjInfo | gameboard = f adjInfo.gameboard }


adjudicationStep : AdjudicationInfo -> AdjudicationInfo
adjudicationStep adjInfo =
    let
        -- withinPowerLevelStep powerLevel adjInfo =
        _ =
            Debug.log "adjudication step!" adjInfo.powerLevels

        stayingPut ( p, mc ) =
            isHold mc || isConvoy mc

        collide_ =
            collide adjInfo.gameboard

        fail md powerLevels =
            case powerLevels of
                [] ->
                    []

                ( n, mds ) :: pls ->
                    ( n, List.filter ((/=) md) mds ) :: pls

        hold ( p, _ ) powerLevels =
            case powerLevels of
                [] ->
                    [ ( 1, [ ( p, Hold ) ] ) ]

                ( 1, mds ) :: _ ->
                    [ ( 1, ( p, Hold ) :: mds ) ]

                pl :: pls ->
                    pl :: hold ( p, Hold ) pls

        dropDirective : MoveDirective -> AdjudicationInfo -> AdjudicationInfo
        dropDirective md adjInfo =
            let
                dropDirective__ : MoveDirective -> PowerLevel -> PowerLevel
                dropDirective__ md ( n, mds ) =
                    case mds of
                        [] ->
                            ( n, [] )

                        md_ :: mds_ ->
                            if md == md_ then
                                dropDirective__ md ( n, mds_ )
                            else
                                dropDirective__ md ( n, mds_ )
                                    |> \( n, mds ) -> ( n, md_ :: mds )

                dropDirective_ md pls =
                    case pls of
                        [] ->
                            []

                        pl :: pls_ ->
                            dropDirective__ md pl :: dropDirective_ md pls_
            in
                { adjInfo | powerLevels = dropDirective_ md adjInfo.powerLevels }

        failAndHold md =
            fail md >> hold md

        wrappedFailAndHold md adjInfo =
            -- let
            --     _ =
            --         Debug.log "wrappedFailAndHold" md
            -- in
            { adjInfo | powerLevels = failAndHold md adjInfo.powerLevels }

        wrappedFail md adjInfo =
            { adjInfo | powerLevels = failAndHold md adjInfo.powerLevels }

        forEachDirective : (MoveDirective -> AdjudicationInfo -> AdjudicationInfo) -> AdjudicationInfo -> AdjudicationInfo
        forEachDirective f adjInfo =
            let
                -- _ =
                --     Debug.log "forEachDirective" f
                foo powerLevels adjInfo =
                    case powerLevels of
                        [] ->
                            adjInfo

                        ( n, mds ) :: pls ->
                            case mds of
                                [] ->
                                    foo pls adjInfo

                                md :: mds_ ->
                                    foo (( n, mds_ ) :: pls) <| f md adjInfo
            in
                foo adjInfo.powerLevels adjInfo

        registerHolds : AdjudicationInfo -> AdjudicationInfo
        registerHolds adjInfo =
            let
                ( power, mds ) =
                    getTopPowerLevel adjInfo

                -- _ =
                --     Debug.log "registerHolds" mds
                foo md1 =
                    if stayingPut md1 then
                        registerMove md1
                            << forEachDirective
                                (\md2 ->
                                    if md1 /= md2 && collide_ md1 md2 then
                                        wrappedFailAndHold md2
                                    else
                                        identity
                                )
                    else
                        identity
            in
                case mds of
                    [] ->
                        adjInfo

                    md1 :: mds ->
                        registerHolds <|
                            foo md1 adjInfo

        registerStandoffs adjInfo =
            let
                ( n, mds ) =
                    getTopPowerLevel adjInfo

                zipped =
                    List.map (\x -> ( x, False )) mds

                findStandoffs md mdbs =
                    ( List.any (collide_ md) <| List.map (Tuple.first) mdbs
                    , List.map (\( md_, b ) -> ( md_, b || collide_ md md_ )) mdbs
                    )

                withStandoffs mdbs =
                    case mdbs of
                        [] ->
                            []

                        ( md, b ) :: mdbs ->
                            let
                                ( b_, mdbs_ ) =
                                    findStandoffs md mdbs
                            in
                                ( md, b || b_ ) :: withStandoffs mdbs_

                powerLevels =
                    List.foldr
                        (\( md, b ) ->
                            if b then
                                failAndHold md
                            else
                                identity
                        )
                        adjInfo.powerLevels
                        (withStandoffs zipped)
            in
                { adjInfo | powerLevels = powerLevels }

        registerAdvances adjInfo =
            let
                ( n, mds ) =
                    getTopPowerLevel adjInfo

                -- dislodges the piece at md2 if md2 is a counter-move
                -- applies fail if md2 fails because of standoff
                dislodge md1 md2 adjInfo =
                    case md1 of
                        ( p, Advance lid ) ->
                            let
                                ( o1, d1 ) =
                                    toOriginDestination adjInfo.gameboard md1

                                ( o2, d2 ) =
                                    toOriginDestination adjInfo.gameboard md2
                            in
                                if d1 == d2 then
                                    wrappedFailAndHold md2 adjInfo
                                else if (o1 == d2) && (o2 == d1) then
                                    dislodgePiece (Tuple.first md2) <| wrappedFailAndHold md2 adjInfo
                                else
                                    adjInfo

                        _ ->
                            adjInfo

                dislodgePiece p adjInfo =
                    { adjInfo | dislodgedPieces = p :: adjInfo.dislodgedPieces }

                registerAdvance md adjInfo =
                    if isAdvance (Tuple.second md) then
                        adjInfo
                            |> registerMove md
                            |> forEachDirective (dislodge md)
                    else
                        adjInfo

                result =
                    List.foldr registerAdvance adjInfo mds

                _ =
                    Debug.log "result of registerAdvances: " result.powerLevels
            in
                List.foldr registerAdvance adjInfo mds

        lopOffHeadIfEmpty : AdjudicationInfo -> AdjudicationInfo
        lopOffHeadIfEmpty adjInfo =
            case adjInfo.powerLevels of
                ( _, [] ) :: pls ->
                    { adjInfo | powerLevels = pls }

                _ ->
                    adjInfo

        registerMove : MoveDirective -> AdjudicationInfo -> AdjudicationInfo
        registerMove ( p, mc ) adjInfo =
            case mc of
                Advance lid ->
                    adjInfo
                        |> changeGameboard (movePiece p lid)
                        |> dropDirective ( p, mc )

                _ ->
                    dropDirective ( p, mc ) adjInfo
    in
        case adjInfo.powerLevels of
            [] ->
                adjInfo

            powerLevel :: powerLevels_ ->
                adjInfo
                    |> applyUntilIdempotent (registerHolds >> registerStandoffs)
                    |> registerAdvances
                    |> lopOffHeadIfEmpty


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


blockConvoys : Gameboard -> MoveDirectives -> MoveDirectives
blockConvoys gb mds =
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


calculatePowerLevels : Gameboard -> MoveDirectives -> List PowerLevel
calculatePowerLevels gb mds =
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

        incrementIfSupports p cmd n =
            if supports cmd p then
                n + 1
            else
                n

        countSupport p =
            List.foldr (incrementIfSupports p) 0 supportCommands

        getPower p =
            ( p, getCommand mds p, 1 + countSupport p )
    in
        List.map getPower gb.pieces
            |> partitionBy (\( _, _, n ) -> n) (\( p, mc, _ ) -> ( p, mc ))
            |> List.sortBy Tuple.first
            |> List.reverse


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
