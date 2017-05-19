module Europe exposing (theMapData)

import GameMapData exposing (GameMapData, Empire(..), LocationID(..), ProvinceData(..))

theMapData : GameMapData
theMapData = 
    [ (Just England, englandData)
    , (Just France, franceData)
    , (Just Germany, germanyData)
    , (Just Russia, russiaData)
    , (Just Italy, italyData)
    , (Just AustriaHungary, austriaHungaryData)
    , (Just Turkey, turkeyData)
    , (Nothing, nothingData ++ seas)
    ]

englandData = 
    [ Capital ("Edinburgh",
        [ (Coast "", 
            [ ("Clyde", Coast "")
            , ("Yorkshire", Coast "")
            , ("North Sea", Sea)
            , ("Norwegian Sea", Sea)
            ])
        , (Land,
            [ ("Clyde", Land)
            , ("Liverpool", Land)
            , ("Yorkshire", Land)
            ])]
        )
    , Capital ("Liverpool",
        [ (Coast "",
            [ ("Clyde", Coast "")
            , ("Wales", Coast "")
            , ("Irish Sea", Sea)
            , ("North Atlantic Ocean", Sea)
            ])
        , (Land,
            [ ("Clyde", Land)
            , ("Edinburgh", Land)
            , ("Yorkshire", Land)
            , ("Wales", Land)
            ])]
        )
    , Capital ("London",
        [ (Coast "",
            [ ("Wales", Coast "")
            , ("Yorkshire", Coast "")
            , ("English Channel", Sea)
            , ("North Sea", Sea)
            ])
        , (Land,
            [ ("Yorkshire", Land)
            , ("Wales", Land)
            ])]
        )
    , Noncapital ("Clyde",
        [ (Coast "",
            [ ("Edinburgh", Coast "")
            , ("Liverpool", Coast "")
            , ("Atlantic Ocean", Sea)
            , ("Norwegian Sea", Sea)
            ])
        , (Land,
            [ ("Edinburgh", Land)
            , ("Liverpool", Land)
            ])]
        )
    , Noncapital ("Yorkshire",
        [ (Coast "",
            [ ("Edinburgh", Coast "")
            , ("London", Coast "")
            , ("North Sea", Sea)
            ])
        , (Land,
            [ ("Edinburgh", Land)
            , ("Liverpool", Land)
            , ("Wales", Land)
            , ("London", Land)
            ])]
        )
    , Noncapital ("Wales",
        [ (Coast "",
            [ ("Liverpool", Coast "")
            , ("London", Coast "")
            , ("Irish Sea", Sea)
            , ("English Channel", Sea)
            ])
        , (Land,
            [ ("Liverpool", Land)
            , ("Yorkshire", Land)
            , ("London", Land)
            ])]
        )
    ]

franceData = 
    [ Capital ("Brest",
        [ (Coast "",
            [ ("Picardy", Coast "")
            , ("Gascony", Coast "")
            , ("English Channel", Sea)
            , ("Mid-Atlantic Ocean", Sea)
            ])
        , (Land,
            [ ("Picardy", Land)
            , ("Gascony", Land)
            , ("Paris", Land)
            ])
        ])
    , Capital ("Marseilles",
        [ (Coast "",
            [ ("Piedmont", Coast "")
            , ("Spain", Coast "South")
            , ("Gulf of Lyons", Sea)
            ])
        , (Land,
            [ ("Piedmont", Land)
            , ("Spain", Land)
            , ("Gascony", Land)
            , ("Burgundy", Land)
            ])
        ])
    , Capital ("Paris",
        [ (Land,
            [ ("Picardy", Land)
            , ("Brest", Land)
            , ("Burgundy", Land)
            , ("Gascony", Land)
            ])
        ])
    , Noncapital ("Picardy",
        [ (Coast "",
            [ ("Belgium", Coast "")
            , ("Brest", Coast "")
            , ("English Channel", Sea)
            ])
        , (Land,
            [ ("Belgium", Land)
            , ("Brest", Land)
            , ("Paris", Land)
            , ("Burgundy", Land)
            ])
        ])
    , Noncapital ("Gascony",
        [ (Coast "",
            [ ("Spain", Coast "North")
            , ("Brest", Coast "")
            , ("Mid-Atlantic Ocean", Sea)
            ])
        , (Land,
            [ ("Brest", Land)
            , ("Paris", Land)
            , ("Burgundy", Land)
            , ("Marseilles", Land)
            , ("Spain", Land)
            ])
        ])
    , Noncapital ("Burgundy",
        [ (Land,
            [ ("Paris", Land)
            , ("Gascony", Land)
            , ("Marseilles", Land)
            , ("Piedmont", Land)
            , ("Munich", Land)
            , ("Ruhr", Land)
            , ("Belgium", Land)
            , ("Picardy", Land)
            ])
        ])
    ]

germanyData = 
    [ Capital ("Kiel",
        [ (Coast "",
            [ ("Berlin", Coast "")
            , ("Holland", Coast "")
            , ("Denmark", Coast "")
            , ("Heligoland Bight", Sea)
            , ("Baltic Seas", Sea)
            ])
        , (Land,
            [ ("Berlin", Land)
            , ("Denmark", Land)
            , ("Holland", Land)
            , ("Ruhr", Land)
            , ("Munich", Land)
            ])
        ])
    , Capital ("Berlin",
        [ (Coast "",
            [ ("Kiel", Coast "")
            , ("Prussia", Coast "")
            , ("Baltic Sea", Sea)
            ])
        , (Land,
            [ ("Prussia", Land)
            , ("Silesia", Land)
            , ("Munich", Land)
            , ("Kiel", Land)
            ])
        ])
    , Capital ("Munich",
        [ (Land,
            [ ("Burgundy", Land)
            , ("Ruhr", Land)
            , ("Kiel", Land)
            , ("Berlin", Land)
            , ("Silesia", Land)
            , ("Bohemia", Land)
            , ("Tyrolia", Land)
            ])
        ])
    , Noncapital ("Ruhr",
        [ (Land,
            [ ("Burgundy", Land)
            , ("Belgium", Land)
            , ("Holland", Land)
            , ("Kiel", Land)
            , ("Munich", Land)
            ])
        ])
    , Noncapital ("Silesia",
        [ (Land,
            [ ("Berlin", Land)
            , ("Prussia", Land)
            , ("Warsaw", Land)
            , ("Galicia", Land)
            , ("Bohemia", Land)
            , ("Munich", Land)
            ])
        ])
    , Noncapital ("Prussia",
        [ (Coast "",
            [ ("Livonia", Coast "")
            , ("Belrin", Coast "")
            , ("Baltic Sea", Sea)
            ])
        , (Land,
            [ ("Berlin", Land)
            , ("Silesia", Land)
            , ("Warsaw", Land)
            , ("Livonia", Land)
            ])
        ])
    ]

russiaData =
    [ Capital ("St. Petersburg",
        [ (Coast "North",
            [ ("Norway", Coast "")
            , ("Barents Sea", Sea)
            ])
        , (Coast "South",
            [ ("Finland", Coast "")
            , ("Livonia", Coast "")
            , ("Gulf of Bothnia", Sea)
            ])
        , (Land,
            [ ("Finland", Land)
            , ("Norway", Land)
            , ("Livonia", Land)
            , ("Moscow", Land)
            ])
        ])
    , Capital ("Moscow",
        [ (Land,
            [ ("St. Petersburg", Land)
            , ("Livonia", Land)
            , ("Warsaw", Land)
            , ("Ukraine", Land)
            , ("Sevastopol", Land)
            ])
        ])
    , Capital ("Warsaw",
        [(Land,
            [ ("Prussia", Land)
            , ("Livonia", Land)
            , ("Moscow", Land)
            , ("Ukraine", Land)
            , ("Galicia", Land)
            , ("Silesia", Land)
            ])
        ])
    , Capital ("Sevastopol",
        [ (Coast "",
            [ ("Rumania", Coast "")
            , ("Armenia", Coast "")
            , ("Black Sea", Sea)
            ])
        , (Land,
            [ ("Finland", Land)
            , ("Norway", Land)
            , ("Livonia", Land)
            , ("Moscow", Land)
            ])
        ])
    , Noncapital ("Finland",
        [ (Coast "",
            [ ("Sweden", Coast "")
            , ("St. Petersburg", Coast "South")
            , ("Gulf of Bothnia", Sea)
            ])
        , (Land,
            [ ("Sweden", Land)
            , ("Norway", Land)
            , ("St. Petersburg", Land)
            ])
        ])
    , Noncapital ("Livonia",
        [ (Coast "",
            [ ("Prussia", Coast "")
            , ("St. Petersburg", Coast "South")
            , ("Gulf of Bothnia", Sea)
            , ("Baltic Sea", Sea)
            ])
        , (Land,
            [ ("Prussia", Land)
            , ("Warsaw", Land)
            , ("Moscow", Land)
            , ("St. Petersburg", Land)
            ])
        ])
    , Noncapital ("Ukraine",
        [ (Land,
            [ ("Galicia", Land)
            , ("Warsaw", Land)
            , ("Moscow", Land)
            , ("Sevastopol", Land)
            , ("Rumania", Land)
            ])
        ])
    ]

italyData = 
    [ Capital ("Venice",
        [ (Coast "",
            [ ("Trieste", Coast "")
            , ("Apulia", Coast "")
            , ("Adriatic Sea", Sea)
            ])
        , (Land,
            [ ("Trieste", Land)
            , ("Tyrolia", Land)
            , ("Piedmont", Land)
            , ("Tuscany", Land)
            , ("Rome", Land)
            ])
        ])
    , Capital ("Rome",
        [ (Coast "",
            [ ("Tuscany", Coast "")
            , ("Naples", Coast "")
            , ("Tyrrhenian Sea", Sea)
            ])
        , (Land,
            [ ("Tuscany", Land)
            , ("Venice", Land)
            , ("Apulia", Land)
            , ("Naples", Land)
            ])
        ])
    , Capital ("Naples",
        [ (Coast "",
            [ ("Rome", Coast "")
            , ("Apulia", Coast "")
            , ("Tyrrhenian Sea", Sea)
            , ("Ionian Sea", Sea)
            ])
        , (Land,
            [ ("Apulia", Land)
            , ("Rome", Land)
            ])
        ])
    , Noncapital ("Piedmont",
        [ (Coast "",
            [ ("Marseille", Coast "")
            , ("Tuscany", Coast "")
            , ("Gulf of Lyons", Sea)
            ])
        , (Land,
            [ ("Marseilles", Land)
            , ("Tyrolia", Land)
            , ("Venice", Land)
            , ("Tuscany", Land)
            ])
        ])
    , Noncapital ("Tuscany",
        [ (Coast "",
            [ ("Piedmont", Coast "")
            , ("Rome", Coast "")
            , ("Gulf of Lyons", Sea)
            , ("Tyrrhenian Sea", Sea)
            ])
        , (Land,
            [ ("Piedmont", Land)
            , ("Venice", Land)
            , ("Rome", Land)
            ])
        ])
    , Noncapital ("Tuscany",
        [ (Coast "",
            [ ("Piedmont", Coast "")
            , ("Rome", Coast "")
            , ("Gulf of Lyons", Sea)
            , ("Tyrrhenian Sea", Sea)
            ])
        , (Land,
            [ ("Piedmont", Land)
            , ("Venice", Land)
            , ("Rome", Land)
            ])
        ])
    , Noncapital ("Apulia",
        [ (Coast "",
            [ ("Naples", Coast "")
            , ("Venice", Coast "")
            , ("Adriatic Sea", Sea)
            , ("Ionian Sea", Sea)
            ])
        , (Land,
            [ ("Naples", Land)
            , ("Venice", Land)
            , ("Rome", Land)
            ])
        ])
    ]

austriaHungaryData = 
    [ Capital ("Trieste",
        [ (Coast "",
            [ ("Venice", Coast "")
            , ("Albania", Coast "")
            , ("Adriatic", Sea)
            ])
        , (Land,
            [ ("Venice", Land)
            , ("Tyrolia", Land)
            , ("Vienna", Land)
            , ("Budapest", Land)
            , ("Serbia", Land)
            , ("Albania", Land)
            ])
        ])
    , Capital ("Vienna",
        [(Land,
            [ ("Bohemia", Land)
            , ("Galicia", Land)
            , ("Budapest", Land)
            , ("Trieste", Land)
            , ("Tyrolia", Land)
            ])
        ])
    , Capital ("Budapest",
        [(Land,
            [ ("Galicia", Land)
            , ("Rumania", Land)
            , ("Serbia", Land)
            , ("Trieste", Land)
            , ("Vienna", Land)
            ])
        ])
    , Noncapital ("Tyrolia",
        [(Land,
            [ ("Venice", Land)
            , ("Piedmont", Land)
            , ("Munich", Land)
            , ("Bohemia", Land)
            , ("Vienna", Land)
            , ("Trieste", Land)
            ])
        ])
    , Noncapital ("Bohemia",
        [(Land,
            [ ("Tyrolia", Land)
            , ("Munich", Land)
            , ("Silesia", Land)
            , ("Galicia", Land)
            , ("Vienna", Land)
            ])
        ])
    , Noncapital ("Galicia",
        [(Land,
            [ ("Bohemia", Land)
            , ("Silesia", Land)
            , ("Warsaw", Land)
            , ("Ukraine", Land)
            , ("Rumania", Land)
            , ("Budapest", Land)
            , ("Vienna", Land)
            ])
        ])
    ]

turkeyData = 
    [ Capital ("Constantinople",
        [ (Coast "",
            [ ("Ankara", Coast "")
            , ("Smyrna", Coast "")
            , ("Bulgaria", Coast "East")
            , ("Bulgaria", Coast "South")
            , ("Black Sea", Sea)
            , ("Aegean Sea", Sea)
            ])
        , (Land,
            [ ("Bulgaria", Land)
            , ("Ankara", Land)
            , ("Smyrna", Land)
            ])
        ])
    , Capital ("Ankara",
        [ (Coast "",
            [ ("Constantinople", Coast "")
            , ("Armenia", Coast "")
            , ("Black Sea", Sea)
            ])
        , (Land,
            [ ("Constantinople", Land)
            , ("Smyrna", Land)
            , ("Armenia", Land)
            ])
        ])
    , Capital ("Smyrna",
        [ (Coast "",
            [ ("Constantinople", Coast "")
            , ("Syria", Coast "")
            , ("Aegean Sea", Sea)
            , ("Eastern Mediterranean", Sea)
            ])
        , (Land,
            [ ("Constantinople", Land)
            , ("Ankara", Land)
            , ("Armenia", Land)
            , ("Syria", Land)
            ])
        ])
    , Noncapital ("Armenia",
        [ (Coast "",
            [ ("Ankara", Coast "")
            , ("Sevastopol", Coast "")
            , ("Black Sea", Sea)
            ])
        , (Land,
            [ ("Sevastopol", Land)
            , ("Ankara", Land)
            , ("Smyrna", Land)
            , ("Syria", Land)
            ])
        ])
    , Noncapital ("Syria",
        [ (Coast "",
            [ ("Smyrna", Coast "")
            , ("Eastern Mediterranean", Sea)
            ])
        , (Land,
            [ ("Smyrna", Land)
            , ("Armenia", Land)
            ])
        ])
    ]

nothingData = 
    [ Capital ("Norway",
        [ (Coast "",
            [ ("St. Petersburg", Coast "North")
            , ("Sweden", Coast "")
            , ("Skagerrack", Sea)
            , ("North Sea", Sea)
            , ("Norwegian Sea", Sea)
            ])
        , (Land,
            [ ("Sweden", Land)
            , ("Finland", Land)
            , ("St. Petersburg", Land)
            ])
        ])
    , Capital ("Sweden",
        [ (Coast "",
            [ ("Norway", Coast "")
            , ("Finland", Coast "")
            , ("Denmark", Coast "")
            , ("Gulf of Bothnia", Sea)
            , ("Baltic Sea", Sea)
            , ("Skagerrack", Sea)
            ])
        , (Land,
            [ ("Constantinople", Land)
            , ("Smyrna", Land)
            , ("Armenia", Land)
            ])
        ])
    , Capital ("Denmark",
        [ (Coast "",
            [ ("Sweden", Coast "")
            , ("Kiel", Coast "")
            , ("Baltic Sea", Sea)
            , ("Skagerrack", Sea)
            , ("North Sea", Sea)
            , ("Heligoland Bight", Sea)
            ])
        , (Land,
            [ ("Kiel", Land)
            , ("Sweden", Land)
            ])
        ])
    , Capital ("Holland",
        [ (Coast "",
            [ ("Belgium", Coast "")
            , ("Kiel", Coast "")
            , ("North Sea", Sea)
            , ("Heligoland Bight", Sea)
            ])
        , (Land,
            [ ("Kiel", Land)
            , ("Ruhr", Land)
            , ("Belgium", Land)
            ])
        ])
    , Capital ("Belgium",
        [ (Coast "",
            [ ("Holland", Coast "")
            , ("Picardy", Coast "")
            , ("North Sea", Sea)
            , ("English Channel", Sea)
            ])
        , (Land,
            [ ("Holland", Land)
            , ("Ruhr", Land)
            , ("Burgundy", Land)
            , ("Picardy", Land)
            ])
        ])
    , Capital ("Spain",
        [ (Coast "North",
            [ ("Gascony", Coast "")
            , ("Portugal", Coast "")
            , ("Mid-Atlantic Ocean", Sea)
            ])
        , (Coast "South",
            [ ("Marseilles", Coast "")
            , ("Portugal", Coast "")
            , ("Gulf of Lyons", Sea)
            , ("Western Mediterranean", Sea)
            , ("Mid-Atlantic Ocean", Sea)
            ])
        , (Land,
            [ ("Gascony", Land)
            , ("Marseilles", Land)
            , ("Portugal", Land)
            , ("Picardy", Land)
            ])
        ])
    , Capital ("Tunis",
        [ (Coast "",
            [ ("North Africa", Coast "")
            , ("Western Mediterranean", Sea)
            , ("Tyrrhenian Sea", Sea)
            , ("Ionian Sea", Sea)
            ])
        , (Land,
            [ ("North Africa", Land)
            ])
        ])
    , Capital ("Greece",
        [ (Coast "",
            [ ("Albania", Coast "")
            , ("Bulgaria", Coast "South")
            , ("Ionian Sea", Sea)
            , ("Aegean Sea", Sea)
            ])
        , (Land,
            [ ("Albania", Land)
            , ("Serbia", Land)
            , ("Bulgaria", Land)
            ])
        ])
    , Capital ("Bulgaria",
        [ (Coast "East",
            [ ("Romania", Coast "")
            , ("Constantinople", Coast "")
            , ("Black Sea", Sea)
            ])
        , (Coast "South",
            [ ("Greece", Coast "")
            , ("Constantinople", Coast "")
            , ("Aegean Sea", Sea)
            ])
        , (Land,
            [ ("Rumania", Land)
            , ("Serbia", Land)
            , ("Greece", Land)
            , ("Constantinople", Land)
            ])
        ])
    , Capital ("Rumania",
        [ (Coast "",
            [ ("Sevastopol", Coast "")
            , ("Bulgaria", Coast "South")
            , ("Black Sea", Sea)
            ])
        , (Land,
            [ ("Sevastopol", Land)
            , ("Ukraine", Land)
            , ("Galicia", Land)
            , ("Budapest", Land)
            , ("Serbia", Land)
            , ("Bulgaria", Land)
            ])
        ])
    , Capital ("Serbia",
        [ (Land,
            [ ("Budapest", Land)
            , ("Trieste", Land)
            , ("Albania", Land)
            , ("Greece", Land)
            , ("Bulgaria", Land)
            , ("Rumania", Land)
            ])
        ])
    , Noncapital ("North Africa",
        [ (Coast "",
            [ ("Tunis", Coast "")
            , ("Western Mediterranean", Sea)
            , ("Mid-Atlantic Ocean", Sea)
            ])
        , (Land,
            [ ("Sevastopol", Land)
            , ("Tunis", Land)
            ])
        ])
    , Noncapital ("Albania",
        [ (Coast "",
            [ ("Trieste", Coast "")
            , ("Greece", Coast "")
            , ("Adriatic Sea", Sea)
            , ("Ionian Sea", Sea)
            ])
        , (Land,
            [ ("Trieste", Land)
            , ("Serbia", Land)
            , ("Greece", Land)
            ])
        ])
    ]



seas = List.map Noncapital
    [ ("Barents Sea",
        [ (Sea,
            [ ("Norway", Coast "")
            , ("St. Petersburg", Coast "North")
            , ("Norwegian Sea", Sea)
            ])])
    , ("Norwegian Sea",
        [ (Sea,
            [ ("Norway", Coast "")
            , ("Edinburgh", Coast "")
            , ("Clyde", Coast "")
            , ("North Sea", Sea)
            , ("North Atlantic Ocean", Sea)
            ])])
    , ("North Sea",
        [ (Sea,
            [ ("Edinburgh", Coast "")
            , ("Yorkshire", Coast "")
            , ("London", Coast "")
            , ("Belgium", Coast "")
            , ("Holland", Coast "")
            , ("Denmark", Coast "")
            , ("Norway", Coast "")
            , ("Norwegian Sea", Sea)
            , ("Skagerrrack Sea", Sea)
            , ("Heligoland Bight", Sea)
            , ("English Channel", Sea)
            ])])
    , ("Skaggerrack",
        [ (Sea,
            [ ("Norway", Coast "")
            , ("Sweden", Coast "")
            , ("Denmark", Coast "")
            , ("North Sea", Sea)
            ])])
    , ("Heligoland Bight",
        [ (Sea,
            [ ("Kiel", Coast "")
            , ("Holland", Coast "")
            , ("Denmark", Coast "")
            , ("North Sea", Sea)
            ])])
    , ("Baltic Sea",
        [ (Sea,
            [ ("Sweden", Coast "")
            , ("Denmark", Coast "")
            , ("Kiel", Coast "")
            , ("Berlin", Coast "")
            , ("Prussia", Coast "")
            , ("Livonia", Coast "")
            , ("Gulf of Bothnia", Sea)
            ])])
    , ("Gulf of Bothnia",
        [ (Sea,
            [ ("Swedent", Coast "")
            , ("Finland", Coast "")
            , ("St. Petersburg", Coast "South")
            , ("Livonia", Coast "")
            , ("Baltic Sea", Sea)
            ])])
    , ("North Atlantic Ocean",
        [ (Sea,
            [ ("Clyde", Coast "")
            , ("Mid-Atlantic Ocean", Sea)
            , ("Norwegian Sea", Sea)
            , ("Irish Sea", Sea)
            ])])
    , ("Irish Sea",
        [ (Sea,
            [ ("Wales", Coast "")
            , ("Liverpool", Coast "")
            , ("North Alantic Ocean", Sea)
            , ("Mid-Alantic Ocean", Sea)
            , ("English Channel Sea", Sea)
            ])])
    , ("English Channel",
        [ (Sea,
            [ ("Wales", Coast "")
            , ("London", Coast "")
            , ("Belgium", Coast "")
            , ("Picardy", Coast "")
            , ("Brest", Coast "")
            , ("North Sea", Sea)
            , ("Irish Sea", Sea)
            , ("Mid-Atlantic Ocean", Sea)
            ])])
    , ("Mid-Atlantic Ocean",
        [ (Sea,
            [ ("Brest", Coast "")
            , ("Gascony", Coast "")
            , ("Spain", Coast "North")
            , ("Portugal", Coast "")
            , ("Spain", Coast "South")
            , ("North Africa", Coast "")
            , ("North Atlantic Ocean", Sea)
            , ("Irish Sea", Sea)
            , ("English Channel", Sea)
            , ("Western Mediterranean", Sea)
            ])])
    , ("Western Mediterranean",
        [ (Sea,
            [ ("North Africa", Coast "")
            , ("Spain", Coast "South")
            , ("Western Mediterranean", Sea)
            , ("Mid-Atlantic Ocean", Sea)
            , ("Gulf of Lyons", Sea)
            ])])
    , ("Gulf of Lyons",
        [ (Sea,
            [ ("Tuscany", Coast "")
            , ("Piedmont", Coast "")
            , ("Marseilles", Coast "")
            , ("Spain", Coast "South")
            , ("Western Mediterranean", Sea)
            , ("Tyrrhenian Sea", Sea)
            ])])
    , ("Tyrrhenian Sea",
        [ (Sea,
            [ ("Tuscany", Coast "")
            , ("Rome", Coast "")
            , ("Naples", Coast "")
            , ("Tunis", Coast "")
            , ("Ionian Sea", Sea)
            , ("Western Mediterranean", Sea)
            , ("Gulf of Lyons", Sea)
            ])])
    , ("Ionian Sea",
        [ (Sea,
            [ ("Tunis", Coast "")
            , ("Naples", Coast "")
            , ("Apulia", Coast "")
            , ("Albania", Coast "")
            , ("Greece", Coast "")
            , ("Tyrrhenian Sea", Sea)
            , ("Adriatic Sea", Sea)
            , ("Aegean Sea", Sea)
            , ("Eastern Mediterranean", Sea)
            ])])
    , ("Adriatic Sea",
        [ (Sea,
            [ ("Albania", Coast "")
            , ("Trieste", Coast "")
            , ("Venice", Coast "")
            , ("Apulia", Coast "")
            , ("Ionian Sea", Sea)
            ])])
    , ("Aegean Sea",
        [ (Sea,
            [ ("Greece", Coast "")
            , ("Bulgaria", Coast "South")
            , ("Constantinople", Coast "")
            , ("Smyrna", Coast "")
            , ("Ionian Sea", Sea)
            , ("Eastern Mediterranean", Sea)
            ])])
    , ("Black Sea",
        [ (Sea,
            [ ("Sevastopol", Coast "")
            , ("Rumania", Coast "")
            , ("Bulgaria", Coast "East")
            , ("Constantinople", Coast "")
            , ("Ankara", Coast "")
            , ("Armenia", Coast "")
            , ("Aegean Sea", Sea)
            ])])
    , ("Eastern Mediterranean",
        [ (Sea,
            [ ("Smyrna", Coast "")
            , ("Syria", Coast "")
            , ("Aegean Sea", Sea)
            , ("Ionian Sea", Sea)
            ])])
    ]