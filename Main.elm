module Main exposing (main)

import Gameboard exposing (..)
import GameboardInterface exposing (..)
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
    , selectedSupplyCenter : Maybe SupplyCenterID
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { gameboard = freshGameboard
    , selectedPiece = Nothing
    , selectedSupplyCenter = Nothing
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EndTurn ->
            let
                gameboard =
                    nextTurn model.gameboard
            in
                ( deselect <| { model | gameboard = gameboard }, Cmd.none )

        Cancel ->
            ( deselect model, Cmd.none )

        SelectPiece p ->
            ( { model | selectedPiece = Just p }, Cmd.none )

        SelectSupplyCenter scid ->
            ( { model | selectedSupplyCenter = Just scid }, Cmd.none )

        SelectBuild bdir ->
            ( deselect { model | gameboard = addBuildDirective bdir model.gameboard }, Cmd.none )

        SelectDisband ddir ->
            ( deselect { model | gameboard = addDisbandDirective ddir model.gameboard }, Cmd.none )

        SelectMove mdir ->
            ( deselect { model | gameboard = addMoveDirective mdir model.gameboard }, Cmd.none )

        SelectRetreat rdir ->
            ( deselect { model | gameboard = addRetreatDirective rdir model.gameboard }, Cmd.none )


deselect : Model -> Model
deselect m =
    { m | selectedPiece = Nothing, selectedSupplyCenter = Nothing }


view : Model -> Html Msg
view model =
    div []
        [ div [] <|
            h1 [] [ text "View Map" ]
                :: viewGameboard model.gameboard
        , div [] <|
            h1 [] [ text "Issue Directives" ]
                :: viewCommandPanel model
        , div []
            [ endTurnButton ]
        ]


viewGameboard : Gameboard -> List (Html Msg)
viewGameboard gb =
    viewHeader gb ++ viewGameInfo gb


viewHeader : Gameboard -> List (Html Msg)
viewHeader gb =
    let
        date =
            toString gb.date

        phase =
            getPhaseAsString gb

        empire =
            getTurnAsString gb
    in
        [ date, phase, empire ]
            |> String.join " | "
            |> text
            |> List.singleton
            |> h3 []
            |> List.singleton


viewGameInfo : Gameboard -> List (Html Msg)
viewGameInfo =
    viewActors


viewActors : Gameboard -> List (Html Msg)
viewActors gb =
    case gb.phase of
        Build _ ->
            if mustDisband gb then
                getPiecesOfCurrentEmpire gb
                    |> List.map
                        (\p -> button [ onClick (SelectPiece p) ] [ text (toString p) ])
            else if mustBuild gb then
                getSupplyCenterIDsOfCurrentEmpire gb
                    |> List.map
                        (\scid -> button [ onClick (SelectSupplyCenter scid) ] [ text (toString scid) ])
            else
                [ text "You have nothing to build or disband!" ]

        Move _ ->
            getPiecesOfCurrentEmpire gb
                |> List.map
                    (\p -> button [ onClick (SelectPiece p) ] [ text (toString p) ])

        Retreat _ ->
            getRetreatingPieces gb
                |> List.map
                    (\p -> button [ onClick (SelectPiece p) ] [ text (toString p) ])


viewCommandPanel : Model -> List (Html Msg)
viewCommandPanel m =
    let
        gb =
            m.gameboard
    in
        case gb.phase of
            Move _ ->
                case m.selectedPiece of
                    Nothing ->
                        []

                    Just p ->
                        getMoveCommands gb p
                            |> List.map
                                (\mc -> button [ onClick (SelectMove ( p, mc )) ] [ text (toString mc) ])

            _ ->
                []


endTurnButton : Html Msg
endTurnButton =
    button [ onClick EndTurn ] [ text "End Turn" ]
