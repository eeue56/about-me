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
    , Cmd.batch 
        [ Http.send (loadRequest (LoadRepos 1)) (getRepos "eeue56" 1)
        , loadModel 
        ]
    )

main : Program Never Model Msg
main = 
    Html.program 
        { init = init 
        , update = (\msg model -> update msg model |> alwaysSaveModel)
        , view = view
        , subscriptions = (\_ -> Sub.none)
        }