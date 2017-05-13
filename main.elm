module Main exposing (main)

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
    | SelectCommand Command
    | Cancel
    | LockIn
    | SelectLocation LocationID
    | SelectCapital TerritoryID  --> Bring up build options with LocationID
    | SelectBuild Piece

type alias Model =
    (Gameboard, Turn, Phase)

type alias Turn = List Empire

type Phase
    = Move MoveInfo
    | Retreat RetreatInfo
    | Build BuildInfo

type alias MoveInfo =
    { selectedPiece : Maybe Piece
    , commands : Dict Piece Command }

type alias RetreatInfo =
    { selectedPiece : Maybe Piece
    , locations : Dict Piece (Maybe LocationID) }

type alias BuildInfo =
    { selectedCapital : Maybe TerritoryID
    , pieces : Dict TerritoryID (Maybe Piece) }


init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)

initialModel : Model
initialModel =
Debug.crash "TODO"

subscriptions : Model -> Sub Msg
subscriptions model =
Debug.crash "TODO"

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case Tuple.third model of
        Move mInfo      -> moveUpdate msg model mInfo
        Retreat rInfo   -> retreatUpdate msg model rInfo
        Build bInfo     -> buildUpdate msg model bInfo


moveUpdate : Msg -> Model -> MoveInfo -> (Model, Cmd Msg)
moveUpdate msg model minfo =
    case msg of
        SelectPiece piece   ->
        SelectCommand cmd   ->
        Cancel              ->
        LockIn              ->
        _                   -> Debug.error "wrong!!"

retreatUpdate : Msg -> Model -> RetreatInfo -> (Model, Cmd Msg)
retreatUpdate msg model rinfo =
    case msg of
        SelectPiece piece   ->
        SelectLocation lid  ->
        Cancel              ->
        LockIn              ->
        _                   -> Debug.error "wrong!!"

buildUpdate : Msg -> Model -> BuildInfo -> (Model, Cmd Msg)
buildUpdate msg model binfo =
    case msg of
        SelectLocation lid  ->
        SelectBuild piece   ->
        Cancel              ->
        LockIn              ->
        _                   -> Debug.error "wrong!!"



view : Model -> Html Msg
view model =
Debug.crash "TODO"