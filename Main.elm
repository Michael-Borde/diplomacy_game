module Main exposing (main)

import Gameboard exposing (..)
import GameboardInterface exposing (..)
import GameMap exposing (..)
import GameMapGraphics as GMG
import GameMapData as GMD

import Html exposing (..)
import Html.Attributes as HA
import Html.Events exposing (onClick)

import Svg
import Svg.Attributes exposing (..)


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
    , graphics : GMG.GameMapGraphics
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )

-------

-------


initialModel : Model
initialModel =
    { gameboard = freshGameboard
    , selectedPiece = Nothing
    , selectedSupplyCenter = Nothing
    , graphics = GMG.freshGraphics
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

--------------------------------------

test : Html.Html msg
test =
     Svg.svg
      [ width "120", height "120", viewBox "0 0 120 120" ]
      [ Svg.rect [ x "10", y "10", width "100", height "100", rx "15", ry "15" ] [] ]


buildMap : Model -> Html.Html msg
buildMap model =
    let
        provincePolygons = List.map buildProvincePolygon model.graphics.provinces
        scPolygons = List.map (buildSCPolygon model) model.graphics.supplyCenters
        css = HA.style [ ("margin", "auto"), ("display", "block")]
        svgStyle = [ height "100vh", viewBox "0 0 610 560", css ]
        polygons = provincePolygons ++ scPolygons
    in
    Svg.svg svgStyle polygons

buildProvincePolygon : GMG.ProvinceInfo -> Svg.Svg msg
buildProvincePolygon prov =
    let
        color = provinceColor prov
    in
    Svg.polygon
        [ points prov.polygon
        , fill color
        , stroke "black"
        , strokeLinejoin "round"
        ] []

provinceColor : GMG.ProvinceInfo -> String
provinceColor prov =
    case prov.empire of
        Just emp -> empireToColor emp
        Nothing ->
            case prov.terrainType of
                GMD.L -> "#FFFFDD"
                GMD.W -> "#99CCFF"

-- Hard code for now
empireToColor : Empire -> String
empireToColor empire =
    case empire of
        Empire "England" -> "#8E8AC0"
        Empire "France" -> "#98C9D6"
        Empire "Germany" -> "#ADA08F"
        Empire "Russia" -> "#E19289"
        Empire "Italy" -> "#92CA74"
        Empire "Austria-Hungary" -> "#D9A679"
        Empire "Turkey" -> "#D7C94B"
        _ -> Debug.crash "Not an empire"

occupantToColor : Maybe Piece -> String
occupantToColor piece =
    case piece of
        Just (Army pinfo) -> empireToColor pinfo.empire
        Just (Fleet pinfo) -> empireToColor pinfo.empire
        Nothing -> "grey"

buildSCPolygon : Model -> GMG.SupplyCenter -> Svg.Svg msg
buildSCPolygon model sc =
    let
        occupant = getOccupant model.gameboard (Capital (SupplyCenter sc.supplyCenterID))
        color = occupantToColor occupant
        x = toString (Tuple.first sc.supplyCenterCoordinates)
        y = toString (Tuple.second sc.supplyCenterCoordinates)
    in
    Svg.circle
        [ r "4"
        , cx x
        , cy y
        , fill color
        , stroke "black"
        ] []

-----------------------------------------

view : Model -> Html Msg
view model =
    div [class "row"]
        [ div [class "col-md-8"]
            [ buildMap model ]
        , div [class "col-md-4"]
            [ div [] <|
                h1 [] [ text "View Map" ]
                    :: viewGameboard model.gameboard
            , div [] <|
                h1 [] [ text "Issue Directives" ]
                    :: viewCommandPanel model
            , div []
                [ endTurnButton ]
            ]
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
            else if canBuild gb then
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
