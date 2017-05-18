module Europe exposing (theMap)

import GameMapData exposing (..)

theMap = []

capitals : List ProvinceID
capitals =
    List.map (Capital << SupplyCenter)
    [ "Edinburgh"
    , "Liverpool"
    , "London"
    , "Brest"
    , "Paris"
    , "Marseilles"
    , "Kiel"
    , "Berlin"
    , "Munich"
    , "St. Petersburg"
    , "Moscow"
    , "Warsaw"
    , "Sevastopol"
    , "Venice"
    , "Rome"
    , "Naples"
    , "Vienna"
    , "Budapest"
    , "Trieste"
    , "Constantinople"
    , "Ankara"
    , "Smyrna"
    , "Spain"
    , "Portugal"
    , "Belgium"
    , "Holland"
    , "Denmark"
    , "Norway"
    , "Sweden"
    , "Rumania"
    , "Bulgaria"
    , "Serbia"
    , "Greece"
    , "Tunis"
    ]

noncapitals : List ProvinceID
noncapitals = List.map Noncapital
    [ "Clyde"
    , "Yorkshire"
    , "Wales"
    , "Picardy"
    , "Burgundy"
    , "Gascony"
    , "Ruhr"
    , "Silesia"
    , "Prussia"
    , "Finland"
    , "Livonia"
    , "Ukraine"
    , "Piedmont"
    , "Tuscany"
    , "Apulia"
    , "Tyrolia"
    , "Bohemia"
    , "Galicia"
    , "Armenia"
    , "Syria"
    , "North Africa"
    , "Albania"
    ]

seas : List ProvinceID
seas = List.map Noncapital
    [ "Barents Sea"
    , "Norwegian Sea"
    , "North Sea"
    , "Skaggerrack"
    , "Heligoland Bight"
    , "Baltic Sea"
    , "Gulf of Bothnia"
    , "North Atlantic Ocean"
    , "Irish Sea"
    , "English Channel"
    , "Mid-Atlantic Ocean"
    , "Western Mediterranean"
    , "Gulf of Lyons"
    , "Tyrrhenian Sea"
    , "Ionian Sea"
    , "Adriatic Sea"
    , "Aegean Sea"
    , "Black Sea"
    , "Eastern Mediterranean"
    ]

provinces : List ProvinceID
provinces =
    [
        
    ]