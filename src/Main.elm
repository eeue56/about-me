module Main exposing (..)

import Html exposing (..)
import Dict

import Http
import Github exposing (getRepos, getOneRepo)
import FavouriteProjects exposing (takeHome)

import Model exposing (..)
import Update exposing (..)
import View exposing (..)


loadAllFavourites : List (Cmd Msg)
loadAllFavourites = 
    List.map 
        (\project -> Http.send (loadRequest LoadRepo) (getOneRepo project.owner project.name))
        FavouriteProjects.allProjects

init : (Model, Cmd Msg) 
init =
    ( { language = "English", repos = [], templates = Dict.empty }
    , Cmd.batch 
        ([ Http.send (loadRequest (LoadRepos 1)) (getRepos "eeue56" 1)
        , loadModel 
        ] ++ loadAllFavourites)
    )

main : Program Never Model Msg
main = 
    Html.program 
        { init = init 
        , update = (\msg model -> update msg model |> alwaysSaveModel)
        , view = view
        , subscriptions = (\_ -> Sub.none)
        }