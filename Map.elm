module Map exposing (Map, empty, get, set, asList)

type Map k v = M (List (k, v))

empty : Map k v
empty = M []

get : k -> Map k v -> Maybe v
get k (M kvs) = case kvs of
    [] -> Nothing
    (k_, v)::kvs_ ->
        if k == k_ then Just v else get k (M kvs_)

set : k -> v -> Map k v -> Map k v
set k v (M kvs) = case kvs of
    [] -> M [(k, v)]
    (k_, v_)::kvs_ ->
        if k == k_ then M <| (k_, v)::kvs else
            let
                kvs = asList <| set k v (M kvs_)
            in
                M <| (k_, v_)::kvs

asList : Map k v -> List (k, v)
asList (M kvs) = kvs

fromList : List (k, v) -> Map k v
fromList kvs = case kvs of
    [] -> M []
    (k,v)::kvs_ -> set k v <| fromList kvs_