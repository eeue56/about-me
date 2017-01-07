module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes exposing (style)
import Dict

import Http

import AboutMe exposing (viewAboutMe)
import Translation exposing (..)
import Github exposing (getRepos)

import Model exposing (..)
import Update exposing (..)



viewLanguageChoice : String -> Html Msg 
viewLanguageChoice language =
    option 
        [] 
        [ text language ]

viewChooseLanguage : Model -> Html Msg
viewChooseLanguage model =
    select [ onInput ChangeLanguage ] (List.map viewLanguageChoice languageKeys)  


init : (Model, Cmd Msg) 
init =
    ( {language = "English", repos = [], templates = Dict.empty }
    , Http.send (loadRequest (LoadRepos 1)) (getRepos "eeue56" 1)
    )

viewRepos : Model -> Html Msg
viewRepos model = 
    List.length model.repos
        |> toString
        |> text

view : Model -> Html Msg
view model =
    div 
        []
        [ viewChooseLanguage model 
        , viewAboutMe model.templates model.language
        ]


main = 
    Html.program 
        { init = init 
        , update = update
        , view = view
        , subscriptions = (\_ -> Sub.none)
        }