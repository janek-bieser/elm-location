module Location (Location, empty, location, currentLocation, pushState, replaceState, go, back, forward) where

{-| This library combines some useful functionality from the
`window.location` and `window.history` APIs.

# Overview
@docs Location, empty

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


{-| `Location` contains information about the current location of the
browser history (e.g. the path or hash).
-}
type alias Location =
    { path : String
    , hash : String
    , search : String
    }


{-| `empty` returns an location object with empty default values.
-}
empty : Location
empty =
    { path = ""
    , hash = ""
    , search = ""
    }


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
