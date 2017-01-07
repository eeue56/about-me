module Main exposing (..)

import Html exposing (Html)

type Msg = NoOp

type alias Model = 
    {}


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        NoOp -> (model, Cmd.none)

init : (Model, Cmd Msg) 
init =
    ({}, Cmd.none)

view : Model -> Html Msg
view model =
    Html.text "hello"


main = 
    Html.program 
        { init = init 
        , update = update
        , view = view
        , subscriptions = (\_ -> Sub.none)
        }