module Main exposing (main)

import Gameboard exposing (..)

import Html exposing (Html)
import Dict exposing (Dict, insert)

main : Program Never Model Msg
main =
    Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type Msg
    = SelectPiece Piece
    | SelectCapital TerritoryID 
    | SelectDirective Directive
    | Cancel
    | LockIn

type alias Model =
    { gameboard : Gameboard
    , turn: Turn
    , phase: Phase
    }

type alias Turn = List Empire

type Phase
    = Move MoveInfo
    | Retreat RetreatInfo
    | Build BuildInfo

type alias MoveInfo =
    { selectedPiece : Maybe Piece
    , directives : Directives }

type alias RetreatInfo =
    { selectedPiece : Maybe Piece
    , directives : Directives }

type alias BuildInfo =
    { selectedCapital : Maybe TerritoryID
    , directives : Directives }


init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)

initialModel : Model
initialModel =
    Debug.crash "TODO"

subscriptions : Model -> Sub Msg
subscriptions model =
    Debug.crash "TODO"

updateTheDirectives m newDirective = case m.phase of
    Move minfo -> Gameboard.updateDirectives 

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case model.phase of
        Move minfo      -> moveUpdate msg model minfo
        Retreat rinfo   -> retreatUpdate msg model rinfo
        Build binfo     -> buildUpdate msg model binfo


moveUpdate : Msg -> Model -> MoveInfo -> (Model, Cmd Msg)
moveUpdate msg model minfo =
    case msg of
        SelectPiece piece   ->
            let 
                newMinfo = {minfo | selectedPiece = Just piece} 
            in 
                ({ model | phase = Move newMinfo }, Cmd.none)
        SelectMove mord   ->
            let 
                newMinfo = {minfo | Directives = updateMoveDirectives mord minfo.Directives} 
            in 
                ({ model | phase = Move newMinfo }, Cmd.none)
        Cancel              ->
            let
                newMinfo = { minfo | selectedPiece = Nothing}
            in
                ({ model | phase = Move newMinfo}, Cmd.none)
        LockIn              ->
            case List.tail model.turn of
                Nothing -> 
                    Debug.crash "TODO"
                Just xs ->
                    let
                        newTurn = xs
                        newMinfo = { minfo | selectedPiece = Nothing }
                    in
                        ({ model | turn = newTurn, phase = Move newMinfo }, Cmd.none)

        _                   -> Debug.crash "Bad message during move phase!"

retreatUpdate : Msg -> Model -> RetreatInfo -> (Model, Cmd Msg)
retreatUpdate msg model rinfo =
    case msg of
        SelectPiece piece   -> 
            let 
                newRinfo = {rinfo | selectedPiece = Just piece} 
            in 
                ({ model | phase = Retreat newRinfo }, Cmd.none)
        SelectRetreat rcom  ->
            ({ model | phase = Retreat (updateRetreat rcom rinfo) }, Cmd.none) 
        Cancel              ->
            let
                newRinfo = {rinfo | selectedPiece = Nothing}
            in
                ({model | phase = Retreat newRinfo}, Cmd.none)
        LockIn              ->
            case List.tail model.turn of
                Nothing -> Debug.crash "TODO"
                Just xs ->
                    let
                        newRinfo = {rinfo | selectedPiece = Nothing }
                        newTurn = xs
                    in
                        ({ model | turn = newTurn, phase = Retreat newRinfo }, Cmd.none)
        _                   -> Debug.crash "Bad message during retreat phase!"

buildUpdate : Msg -> Model -> BuildInfo -> (Model, Cmd Msg)
buildUpdate msg model binfo =
    case msg of
        SelectCapital tid  ->
            let
                newBinfo = { binfo | selectedCapital = Just tid }
            in
                ({model | phase = Build newBinfo}, Cmd.none)
        SelectBuild bcom   ->
            ({ model | phase = Build (updateBuild bcom binfo) }, Cmd.none) 
        Cancel              ->
            let
                newBinfo = {binfo | selectedCapital = Nothing}
            in
                ({model | phase = Build newBinfo}, Cmd.none)
        LockIn              ->
            case List.tail model.turn of
                Nothing -> Debug.crash "TODO"
                Just xs ->
                    let
                        newBinfo = {binfo | selectedPiece = Nothing }
                        newTurn = xs
                    in
                        ({ model | turn = newTurn, phase = Build newBinfo }, Cmd.none)
        _                   -> Debug.crash "Bad message during build phase!"



view : Model -> Html Msg
view model =
    Debug.crash "TODO"