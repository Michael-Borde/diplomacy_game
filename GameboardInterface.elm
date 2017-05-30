module GameboardInterface exposing (..)

import Gameboard exposing (..)
import Adjudicator exposing (..)
import GameMap exposing (..)
import Europe as TheMap
import Map exposing (..)
import Utils exposing (..)


freshGameboard : Gameboard
freshGameboard =
    let
        gmd =
            TheMap.gameMapData

        gameMap =
            GameMap.convert gmd

        turnOrder =
            GameMap.getEmpireTurnOrder gmd

        date =
            Spring 1900

        phase =
            Move { moveDirectives = Map.empty }

        turn =
            turnOrder

        pieces =
            getStartingPieces gameMap gmd

        supplyCenters =
            Map.empty
    in
        updateSupplyCenters <|
            { gameMap = gameMap
            , turnOrder = turnOrder
            , date = date
            , phase = phase
            , turn = turn
            , pieces = pieces
            , supplyCenters = supplyCenters
            }


addMoveDirective : MoveDirective -> Gameboard -> Gameboard
addMoveDirective ( p, mc ) gb =
    let
        newMoveDirectives =
            case gb.phase of
                Move minfo ->
                    { minfo | moveDirectives = Map.set p mc minfo.moveDirectives }

                _ ->
                    Debug.crash "tried to add move directives in non move phase!"
    in
        { gb | phase = Move newMoveDirectives }


addRetreatDirective : RetreatDirective -> Gameboard -> Gameboard
addRetreatDirective ( p, lid ) gb =
    let
        rinfo =
            case gb.phase of
                Retreat { retreatDirectives, retreatingPieces } ->
                    { retreatDirectives = Map.set p lid retreatDirectives
                    , retreatingPieces = retreatingPieces
                    }

                _ ->
                    Debug.crash "tried to add retreat directives in non retreat phase!"
    in
        { gb | phase = Retreat rinfo }


addBuildDirective : BuildDirective -> Gameboard -> Gameboard
addBuildDirective ( sid, mp ) gb =
    let
        binfo =
            case gb.phase of
                Build { buildDirectives, disbandDirectives } ->
                    { buildDirectives = Map.set sid mp buildDirectives
                    , disbandDirectives = disbandDirectives
                    }

                _ ->
                    Debug.crash "tried to add build directives in non build phase!"
    in
        { gb | phase = Build binfo }


addDisbandDirective : DisbandDirective -> Gameboard -> Gameboard
addDisbandDirective ( p, b ) gb =
    let
        binfo =
            case gb.phase of
                Build { buildDirectives, disbandDirectives } ->
                    { buildDirectives = buildDirectives
                    , disbandDirectives = Map.set p b disbandDirectives
                    }

                _ ->
                    Debug.crash "tried to add disband directives in non build phase!"
    in
        { gb | phase = Build binfo }


nextTurn : Gameboard -> Gameboard
nextTurn gb =
    let
        _ =
            Debug.log "Gameboard.nextTurn" Nothing
    in
        case gb.turn of
            [] ->
                Debug.crash "no empires??"

            [ _ ] ->
                nextPhase gb

            _ :: es ->
                { gb | turn = es }


nextPhase : Gameboard -> Gameboard
nextPhase gb =
    case gb.phase of
        Build binfo ->
            freshMovePhase <| adjudicateBuilds gb binfo

        Move md ->
            freshRetreatPhase <| adjudicateMoves gb md

        Retreat rinfo ->
            turnTheClock <| adjudicateRetreats gb rinfo


turnTheClock : Gameboard -> Gameboard
turnTheClock gb =
    case gb.date of
        Spring yy ->
            freshMovePhase <| { gb | date = Autumn yy }

        Autumn yy ->
            freshBuildPhase <| { gb | date = Spring (yy + 1) }


freshMovePhase : Gameboard -> Gameboard
freshMovePhase gb =
    refreshTurn { gb | phase = Move { moveDirectives = Map.empty } }


freshRetreatPhase : ( Gameboard, List Piece ) -> Gameboard
freshRetreatPhase ( gb, rps ) =
    let
        newPhase =
            Retreat
                { retreatDirectives = Map.empty
                , retreatingPieces = rps
                }
    in
        refreshTurn <| { gb | phase = newPhase }


freshBuildPhase : Gameboard -> Gameboard
freshBuildPhase gb =
    let
        newPhase =
            Build
                { buildDirectives = Map.empty
                , disbandDirectives = Map.empty
                }
    in
        refreshTurn <| updateSupplyCenters <| { gb | phase = newPhase }


refreshTurn : Gameboard -> Gameboard
refreshTurn gb =
    { gb | turn = gb.turnOrder }


countSupplyCenters : Gameboard -> Int
countSupplyCenters gb =
    let
        numSupplyCenters =
            List.length <| getSupplyCentersIDsOfCurrentEmpire gb

        _ =
            Debug.log "number supply centers: " numSupplyCenters
    in
        numSupplyCenters


countPieces : Gameboard -> Int
countPieces gb =
    let
        numPieces =
            getPiecesOfCurrentEmpire gb
                |> List.length

        _ =
            Debug.log "number pieces: " numPieces
    in
        numPieces


countDisbands : Gameboard -> Int
countDisbands gb =
    case gb.phase of
        Build binfo ->
            asList binfo.disbandDirectives
                |> List.filter (\( _, b ) -> b)
                |> List.length

        _ ->
            0


countBuilds : Gameboard -> Int
countBuilds gb =
    case gb.phase of
        Build binfo ->
            asList binfo.buildDirectives
                |> List.filter (\( _, mp ) -> mp /= Nothing)
                |> List.length

        _ ->
            0


mustDisband : Gameboard -> Bool
mustDisband gb =
    countSupplyCenters gb < countPieces gb - countDisbands gb


canBuild : Gameboard -> Bool
canBuild gb =
    countSupplyCenters gb > countPieces gb + countBuilds gb


getTurnAsString : Gameboard -> String
getTurnAsString =
    (getCurrentEmpire >> getEmpireString >> \s -> s ++ "'s Turn")


getPhaseAsString : Gameboard -> String
getPhaseAsString gb =
    let
        phase =
            case gb.phase of
                Build _ ->
                    "Build"

                Move _ ->
                    "Move"

                Retreat _ ->
                    "Retreat"
    in
        phase ++ " Phase"


getMoveCommands : Gameboard -> Piece -> List MoveCommand
getMoveCommands gb p =
    let
        moves =
            List.map Advance (getMoves gb.gameMap p)

        supportableProvinces =
            getMovesToProvinces gb.gameMap p

        isRelevant pid p_ =
            p_ /= p && (canMoveToProvince gb.gameMap p_ pid || getProvinceIDOfPiece gb.gameMap p_ == pid)

        relevantPieces pid =
            appendMaybe (getOccupant gb pid) <| List.filter (isRelevant pid) gb.pieces

        supports =
            multigraphOf supportableProvinces relevantPieces
                |> List.map (\( pid, p ) -> Support ( p, pid ))
    in
        [ Hold ] ++ moves ++ supports


getRetreatingPieces : Gameboard -> List Piece
getRetreatingPieces gb =
    case gb.phase of
        Retreat rinfo ->
            let
                empire =
                    getCurrentEmpire gb
            in
                List.filter (owns empire) rinfo.retreatingPieces

        _ ->
            Debug.crash "Call to getRetreatingPieces in non retreat phase!"


getSupplyCentersIDsOfCurrentEmpire : Gameboard -> List SupplyCenterID
getSupplyCentersIDsOfCurrentEmpire gb =
    getSupplyCenterIDs gb.gameMap
        |> List.filter (\scid -> get scid gb.supplyCenters == Just (Just (getCurrentEmpire gb)))
