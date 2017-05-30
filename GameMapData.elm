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
    ProvinceData,
    EmpireColor,
    GraphicsInfo,
    SupplyCenterData,
    TerrainType(..))

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
    , empireColors : List EmpireColor
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

type alias EmpireColor =
    { empire : EmpireID
    , color : String
    }

type alias GraphicsInfo =
    { polygon : String
    , terrainType : TerrainType
    , coordinates : (Int, Int)
    }

type TerrainType
    = L
    | W

type alias SupplyCenterData =
    { supplyCenterID : String
    , supplyCenterCoordinates : (Int, Int)
    }