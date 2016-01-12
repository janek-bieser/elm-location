module Main (..) where

import Location exposing (Location)
import Html exposing (..)
import Signal


main : Signal Html
main =
    Signal.map view Location.location


view : Location -> Html
view location =
    div
        []
        [ h1 [] [ text "Location Signal Example" ]
        , p [] [ text "Change the hash or search query in the browser address bar (e.g. '?foo=bar' or '?x=100#foo')" ]
        , p [] [ text "--------------------------------" ]
        , p [] [ text <| toString location ]
        ]
