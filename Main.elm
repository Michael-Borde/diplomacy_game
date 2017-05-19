module Main exposing (main)

import Gameboard exposing (..)
import GameMap exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)

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
    | EndTurn

type alias Model =
    { gameboard : Gameboard }

init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)

initialModel : Model
initialModel =
    { gameboard = freshGameboard }

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    EndTurn -> 
        let
            gameboard = nextTurn model.gameboard
        in
            ({ model | gameboard = gameboard}, Cmd.none)
    _ -> Debug.crash "TODO: any message but EndTurn"

view : Model -> Html Msg
view model =
    let
        date 
            = model.gameboard.date
            |> toString
            |> text
            |> List.singleton
            |> h3 []
        phase 
            = model.gameboard
            |> getPhaseAsString
            |> text
            |> List.singleton
            |>  h3 []
            
        empire 
            = model.gameboard
            |> getTurnAsString
            |> text
            |> List.singleton
            |> h3 []

        endTurnButton = 
            button [ onClick EndTurn ] [ text "End Turn" ]
    in  
        div []
            [ div [] 
                [ date
                , phase
                , empire
                ]
            , endTurnButton
            ]