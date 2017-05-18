module Gameboard exposing (Gameboard, Date, Phase, Turn, RetreatDirective, MoveDirective, BuildDirective, DisbandDirective, freshGameboard, nextTurn)


import GameMapData exposing (Empire(..))
import Map exposing (Map)
import GameMap exposing (..)

type alias Gameboard =
    { date : Date
    , phase : Phase
    , turn : Turn
    , pieces : List Piece
    , supplyCenters : Map SupplyCenterID (Maybe Empire)
    }

type Date
    = Spring Int
    | Autumn Int

type Phase
    = Move MoveDirectives
    | Retreat RetreatInfo
    | Build BuildInfo

type alias Turn = List Empire

type alias BuildInfo =
    { buildDirectives : BuildDirectives
    , disbandDirectives : DisbandDirectives 
    }

type alias RetreatInfo = 
    { retreatDirectives : RetreatDirectives
    , retreatingPieces : List Piece
    }

type alias MoveDirectives
    = Map Piece MoveCommand

type alias MoveDirective = (Piece, MoveCommand)

type MoveCommand
    = Hold
    | Advance LocationID 
    | Support ProvinceID

type alias RetreatDirectives
    = Map Piece LocationID

type alias RetreatDirective
    = (Piece, LocationID)

type alias BuildDirectives
    = Map SupplyCenterID (Maybe Piece)

type alias DisbandDirectives
    = Map Piece Bool

type alias BuildDirective
    =  (SupplyCenterID, Maybe Piece)

type alias DisbandDirective
    =  (Piece, Bool)

freshGameboard : Gameboard
freshGameboard =
    let
        date = Spring 1900
        phase = Move Map.empty
        turn = freshTurn
        pieces = [
        ]
        supplyCenters = Map.empty
    in
        { date = date, phase = phase, turn = turn, pieces = pieces, supplyCenters = supplyCenters}

updateMoveDirectives : MoveDirective -> MoveDirectives -> MoveDirectives
updateMoveDirectives (p, mc) = Map.set p mc

updateRetreatDirectives : RetreatDirective -> RetreatDirectives -> RetreatDirectives
updateRetreatDirectives (p, scid) = Map.set p scid

addBuildDirective : BuildDirective -> BuildDirectives -> BuildDirectives
addBuildDirective (tid, mp) = Map.set tid mp

addDisbandDirective : DisbandDirective -> DisbandDirectives -> DisbandDirectives
addDisbandDirective (p, b) = Map.set p b

nextTurn : Gameboard -> Gameboard
nextTurn gb = case gb.turn of
    [] -> nextPhase gb
    _::es -> { gb | turn = es}

nextPhase : Gameboard -> Gameboard
nextPhase gb = case gb.phase of
    Build binfo -> freshMovePhase <| applyBuildDirectives binfo gb
    Move md -> freshRetreatPhase <| applyMoveDirectives md gb
    Retreat rinfo -> turnTheClock <| applyRetreats rinfo gb


turnTheClock : Gameboard -> Gameboard
turnTheClock gb = case gb.date of
    Spring yy -> freshMovePhase <| { gb | date = Autumn yy}
    Autumn yy -> freshBuildPhase <| { gb | date = Spring (yy+1)}

freshMovePhase : Gameboard -> Gameboard
freshMovePhase gb = refreshTurn { gb | phase = Move Map.empty }

freshRetreatPhase : (Gameboard, List Piece) -> Gameboard
freshRetreatPhase (gb, rps) = 
    let
        newPhase = Retreat 
            { retreatDirectives = Map.empty 
            , retreatingPieces = rps}
    in
        refreshTurn <| { gb | phase = newPhase}

freshBuildPhase : Gameboard -> Gameboard
freshBuildPhase gb = 
    let
        newPhase = Build
            { buildDirectives = Map.empty
            , disbandDirectives = Map.empty
            }
    in
        refreshTurn { gb | phase = newPhase }


refreshTurn : Gameboard -> Gameboard
refreshTurn gb = { gb | turn = freshTurn }

freshTurn : Turn
freshTurn = [England, France, Germany, Russia, Italy, Turkey, AustriaHungary]

applyMoveDirectives : MoveDirectives -> Gameboard -> (Gameboard, List Piece)
applyMoveDirectives mds gb = (gb, []) 

applyRetreats : RetreatInfo -> Gameboard -> Gameboard
applyRetreats rinfo gb = gb

applyBuildDirectives : BuildInfo -> Gameboard -> Gameboard
applyBuildDirectives bds gb = gb