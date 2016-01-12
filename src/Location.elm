module Location (Location, location, currentLocation, pushState, mapEffect, empty) where

{-| This library combines some useful functionality from the
`window.location` and `window.history` APIs.

# Overview
@docs Location
@empty Location

# Signals
@docs location

# Tasks
@docs currentLocation
@docs pushState

# Utilities
@docs mapEffect
-}

import Native.Location
import Signal
import Task exposing (Task)
import Effects exposing (Effects)
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


{-| `mapEffect` maps a Location task to an Effect defined by the user.
-}
mapEffect : Task x Location -> (Maybe Location -> y) -> Effects y
mapEffect task mapper =
    task
        |> Task.toMaybe
        |> Task.map mapper
        |> Effects.task
