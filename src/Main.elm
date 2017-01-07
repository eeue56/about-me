module Main exposing (..)

import Html exposing (..)
import Dict

import Http
import Github exposing (getRepos)

import Model exposing (..)
import Update exposing (..)
import View exposing (..)



init : (Model, Cmd Msg) 
init =
    ( { language = "English", repos = [], templates = Dict.empty }
    , Http.send (loadRequest (LoadRepos 1)) (getRepos "eeue56" 1)
    )

main : Program Never Model Msg
main = 
    Html.program 
        { init = init 
        , update = update
        , view = view
        , subscriptions = (\_ -> Sub.none)
        }