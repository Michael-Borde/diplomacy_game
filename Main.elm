module Main exposing (main)

import Gameboard exposing (..)
import GameMap exposing (..)
-- import GameMapData exposing (..)

import Html exposing (Html)

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
    | SelectCapital ProvinceID 
    | SelectBuild BuildDirective
    | SelectDisband DisbandDirective
    | SelectMove MoveDirective
    | SelectRetreat RetreatDirective
    | Cancel
    | LockIn

type alias Model =
    { gameboard : Gameboard }

init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)

initialModel : Model
initialModel =
    { gameboard : freshGameboard }

subscriptions : Model -> Sub Msg
subscriptions model =
    Debug.crash "TODO"

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    Debug.crash "TODO"

view : Model -> Html Msg
view model =
    Debug.crash "TODO"