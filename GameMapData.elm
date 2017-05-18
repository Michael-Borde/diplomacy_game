module GameMapData exposing (GameMapData, Empire(..))

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

type Location
    = Coast LocationID Adjacencies
    | Land LocationID Adjacencies
    | Sea LocationID Adjacencies


type alias ProvinceInfo = (ProvinceID, List Location)
type alias ProvinceID = String
type alias LocationID = String
type alias Adjacencies = List (ProvinceID, LocationID)