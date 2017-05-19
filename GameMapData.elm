module GameMapData exposing (GameMapData, Empire(..), ProvinceData(..), LocationID(..), Adjacencies, Location, LandData, ProvinceData)

type Empire
    = England
    | France
    | Germany
    | Russia
    | Italy
    | Turkey
    | AustriaHungary

type alias GameMapData = List (Maybe Empire, LandData)

type alias LandData = List ProvinceData

type ProvinceData
    = Capital ProvinceInfo
    | Noncapital ProvinceInfo

type alias Location = (LocationID, Adjacencies)

type LocationID
    = Coast String
    | Land
    | Sea

type alias ProvinceInfo = (ProvinceID, List Location)
type alias ProvinceID = String
type alias Adjacencies = List (ProvinceID, LocationID)
