module GameMapData exposing (
    GameMapData,
    ProvinceData(..),
    LocationID(..),
    ProvinceID,
    EmpireID,
    Piece,
    MapData,
    Adjacencies,
    Location,
    LandData,
    ProvinceData)

type alias ProvinceID = String
type alias EmpireID = String
type LocationID
    = Coast String
    | Land
    | Sea

type alias Piece = (ProvinceID, LocationID)

type alias GameMapData =
    { mapData : MapData
    , startingPieces : List Piece
    , turnOrder : List EmpireID
    , empireColors : List (EmpireID, String)
    , supplyCenters : List SupplyCenterData
    }

type alias MapData = List (Maybe EmpireID, LandData)

type alias LandData = List ProvinceData

type ProvinceData
    = Capital ProvinceInfo
    | Noncapital ProvinceInfo

type alias ProvinceInfo = (ProvinceID, List Location, GraphicsInfo)
type alias Location = (LocationID, Adjacencies)
type alias Adjacencies = List (ProvinceID, LocationID)

type alias GraphicsInfo =
    { polygon : String
    , coordinates : (Int, Int)
    }

type alias SupplyCenterData =
    { supplyCenterID : String
    , supplyCenterCoordinates : (Int, Int)
    }