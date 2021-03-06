module Utils exposing (..)


removeRepeats : List a -> List a
removeRepeats xs =
    case xs of
        [] ->
            []

        x :: xs_ ->
            if List.member x xs_ then
                removeRepeats xs_
            else
                x :: removeRepeats xs_


firstTo : (a -> Bool) -> List a -> Maybe a
firstTo f xs =
    case xs of
        [] ->
            Nothing

        x :: xs_ ->
            if f x then
                Just x
            else
                firstTo f xs_


appendMaybe : Maybe a -> List a -> List a
appendMaybe mx xs =
    case mx of
        Just x ->
            x :: xs

        Nothing ->
            xs


graphOf : List a -> (a -> b) -> List ( a, b )
graphOf xs f =
    List.map (\x -> ( x, f x )) xs


multigraphOf : List a -> (a -> List b) -> List ( a, b )
multigraphOf xs f =
    List.concat <| List.map (\x -> List.map (\y -> ( x, y )) (f x)) xs


fromMaybes : List (Maybe a) -> List a
fromMaybes mxs =
    case mxs of
        [] ->
            []

        Nothing :: mxs_ ->
            fromMaybes mxs_

        (Just x) :: mxs_ ->
            x :: fromMaybes mxs_


partitionBy : (a -> b) -> (a -> c) -> List a -> List ( b, List c )
partitionBy f g xs =
    let
        insert x p =
            case p of
                [] ->
                    [ ( f x, [ g x ] ) ]

                ( y, zs ) :: p ->
                    if f x == y then
                        ( y, g x :: zs ) :: p
                    else
                        ( y, zs ) :: insert x p
    in
        List.foldr insert [] xs


stepUntil : (a -> Maybe a) -> a -> a
stepUntil f x =
    case f x of
        Nothing ->
            x

        Just x_ ->
            stepUntil f x_


failIfNothing : Maybe a -> a
failIfNothing mx =
    case mx of
        Nothing ->
            Debug.crash "fail if nothing"

        Just x ->
            x


applyUntilIdempotent : (a -> a) -> a -> a
applyUntilIdempotent f x =
    let
        fx =
            f x

        _ =
            Debug.log "applyUntilIdemPotent - " ( fx, x )
    in
        if fx == x then
            x
        else
            applyUntilIdempotent f fx
