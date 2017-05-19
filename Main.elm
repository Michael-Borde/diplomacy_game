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
    | SelectSupplyCenter SupplyCenterID 
    | SelectBuild BuildDirective
    | SelectDisband DisbandDirective
    | SelectMove MoveDirective
    | SelectRetreat RetreatDirective
    | Cancel
    | EndTurn

type alias Model =
    { gameboard : Gameboard 
    , selectedPiece : Maybe Piece
    , selectedSupplyCenter : Maybe SupplyCenterID}

init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)

initialModel : Model
initialModel =
    { gameboard = freshGameboard
    , selectedPiece = Nothing
    , selectedSupplyCenter = Nothing }

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
    SelectPiece p ->
        ({ model | selectedPiece = Just p}, Cmd.none)
    SelectSupplyCenter scid ->
        ({ model | selectedSupplyCenter = Just scid}, Cmd.none)
    _ -> Debug.crash "TODO: other messages"

view : Model -> Html Msg
view model =
        div []
            [ div [] 
                <| h1 [] [text "View Map"] ::  viewGameboard model.gameboard
            , div []
                <| h1 [] [text "Issue Directives"] :: viewCommandPanel model
            , div []
                [ endTurnButton ]
            ]


viewGameboard : Gameboard -> List (Html Msg)
viewGameboard gb =
    viewHeader gb ++ viewGameInfo gb

viewHeader : Gameboard -> List (Html Msg)
viewHeader gb =
    let
        date = toString gb.date 
        phase = getPhaseAsString gb
        empire = getTurnAsString gb
    in
        [date, phase, empire]
            |> String.join " | "
            |> text
            |> List.singleton
            |> h3 []
            |> List.singleton


viewGameInfo : Gameboard -> List (Html Msg)
viewGameInfo = viewActors 

viewActors : Gameboard -> List (Html Msg)
viewActors gb = 
    case gb.phase of
        Move _ ->
            getPieces gb |> List.map
                 (\p -> button [ onClick (SelectPiece p)] [ text (toString p)])
        _ ->
            Debug.crash "TODO"

viewCommandPanel : Model -> List (Html Msg)
viewCommandPanel m =
    let gb = m.gameboard in
    case gb.phase of
        Move _ ->
            case m.selectedPiece of
            Nothing -> []
            Just p -> getMoveCommands gb p |> List.map
                 (\mc -> button [ onClick (SelectMove (p, mc))] [ text (toString mc)])
        _ ->
            Debug.crash "TODO"

endTurnButton : Html Msg
endTurnButton = button [ onClick EndTurn ] [ text "End Turn" ]