module Location (Location, empty, path, hash, search, query, location, currentLocation, pushState, replaceState, go, back, forward) where

{-| This library combines some useful functionality from the
`window.location` and `window.history` APIs.

# Overview
@docs Location, empty, path, hash, search, query

# Getting the location

## With a Signal
@docs location

## With a Task
@docs currentLocation

# History Manipulation
@docs pushState, replaceState
@docs go, back, forward
-}

import Native.Location
import Signal
import Task exposing (Task)
import Maybe
import String
import Dict


{-| `Location` contains information about the current location of the
browser history (e.g. the path or hash).
-}
type Location
    = Location
        { path : String
        , hash : String
        , search : String
        }


{-| `empty` returns a location object with empty default values.
-}
empty : Location
empty =
    Location
        { path = ""
        , hash = ""
        , search = ""
        }


{-| Returns the path component of the location.
-}
path : Location -> String
path location =
    let
        (Location l) = location
    in
        l.path


{-| Returns the hash component of the location.
-}
hash : Location -> String
hash location =
    let
        (Location l) = location
    in
        l.hash


{-| Returns the search component of the location.
-}
search : Location -> String
search location =
    let
        (Location l) = location
    in
        l.search


{-| Returns the search query converted to a `Dict`.
-}
query : Location -> Dict.Dict String String
query location =
    let
        queryStr = search location

        len = String.length queryStr

        startIdx =
            if len > 0 then
                1
            else
                0

        combinedTokens = String.slice startIdx len queryStr

        tokens = String.split "&" combinedTokens

        associatedTokens = List.filterMap toTuple tokens
    in
        Dict.fromList associatedTokens


toTuple : String -> Maybe ( String, String )
toTuple searchTerm =
    let
        tokens = String.split "=" searchTerm

        maybeFirst = List.head <| List.take 1 tokens

        maybeLast = List.head <| List.drop 1 tokens
    in
        case maybeFirst of
            Just first ->
                case maybeLast of
                    Just last ->
                        Just ( first, last )

                    Nothing ->
                        Nothing

            Nothing ->
                Nothing


{-| `location` is a Signal representing Location changes over time.
-}
location : Signal.Signal Location
location =
    Native.Location.location


{-| `currentLocation` is a Task to get the current `Location` object.
-}
currentLocation : Task x Location
currentLocation =
    Native.Location.currentLocation


{-| `pushState` is a mapping to `window.history.pushState` of the HTML 5
history API.
-}
pushState : String -> Task x Location
pushState url =
    Native.Location.pushState url


{-| `replaceState` is a mapping to `window.history.replaceState` of
the HTML 5 history API.
-}
replaceState : String -> Task x Location
replaceState url =
    Native.Location.replaceState url


{-| `go` is a mapping to `window.history.go` of the HTML 5 history
API.
-}
go : Int -> Task x Location
go offset =
    Native.Location.go offset


{-| `back` is a mapping to `window.history.back` of the HTML 5 history
API.
-}
back : Task x Location
back =
    go (-1)


{-| `forward` is a mapping to `window.history.forward` of the HTML 5 history
API.
-}
forward : Task x Location
forward =
    go 1
