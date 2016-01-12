module Main (..) where

import Location exposing (Location)
import Html exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)
import StartApp
import Task exposing (Task)
import Signal


type Action
    = LocationChange (Maybe Location)
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
            [ Signal.map (LocationChange << Just) Location.location
            ]
        }


init : ( Model, Effects Action )
init =
    ( Location.empty, mapEffect Location.currentLocation LocationChange )


view : Signal.Address Action -> Model -> Html
view address model =
    div
        []
        [ h1 [] [ text "Location Task Example" ]
        , p [] [ text <| toString model ]
        , p [] [ text "Click the buttons to navigate." ]
        , button
            [ onClick address (GoTo "/example?query=test") ]
            [ text "Go To: /example?query=test" ]
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
        LocationChange maybeLoc ->
            case maybeLoc of
                Just loc ->
                    ( loc, Effects.none )

                Nothing ->
                    ( model, Effects.none )

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
