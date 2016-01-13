module Main (..) where

import Location exposing (Location)
import Html exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)
import StartApp
import Task exposing (Task)
import Signal
import Dict


type Action
    = LocationChange Location
    | HandleLocationTask (Maybe Location)
    | GoTo String
    | Back
    | Forward


type alias Model =
    Location


main : Signal.Signal Html
main =
    app.html


app =
    StartApp.start
        { init = init
        , update = update
        , view = view
        , inputs =
            [ Signal.map LocationChange Location.location
            ]
        }


init : ( Model, Effects Action )
init =
    ( Location.empty, mapEffect Location.currentLocation HandleLocationTask )


view : Signal.Address Action -> Model -> Html
view address model =
    div
        []
        [ h1 [] [ text "History Example" ]
        , p [] [ text "Path: ", text <| Location.path model ]
        , p [] [ text "Hash: ", text <| Location.hash model ]
        , p [] [ text "Search: ", text <| Location.search model ]
        , p [] [ text "Qeury: ", text <| toString <| Location.query model ]
        , p [] [ text "Click the buttons to navigate." ]
        , button
            [ onClick address (GoTo "/example?foo=bar#foo") ]
            [ text "Go To: /example?foo=bar#foo" ]
        , button
            [ onClick address Back ]
            [ text "Back" ]
        , button
            [ onClick address Forward ]
            [ text "Forward" ]
        ]


update : Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        LocationChange location ->
            ( location, Effects.none )

        --( location, Effects.none )
        HandleLocationTask _ ->
            ( model, Effects.none )

        GoTo url ->
            ( model, mapEffect (Location.pushState url) HandleLocationTask )

        Back ->
            ( model, mapEffect Location.back HandleLocationTask )

        Forward ->
            ( model, mapEffect Location.forward HandleLocationTask )


mapEffect : Task x Location -> (Maybe Location -> y) -> Effects y
mapEffect task mapper =
    task
        |> Task.toMaybe
        |> Task.map mapper
        |> Effects.task


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks
