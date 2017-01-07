module View exposing (..)

import Model exposing (..)
import Update exposing (..)

import Html exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes exposing (style)

import Github
import AboutMe exposing (viewAboutMe)
import Translation exposing (..)

viewRepo : Github.Repo -> Html Msg 
viewRepo repo = 
    Html.tr 
        []
        [ Html.td [] [(text repo.name)]
        , Html.td [] [(text <| toString repo.stargazersCount)]
        , Html.td [] [(text repo.language)]
        ]

viewReposHeader : Model -> Html Msg
viewReposHeader model =
    let 
        translator = 
            Translation.getTranslation model.language
    in 
        Html.tr 
            []
            [ Html.td [] [ text <| translator Github.nameTranslations]
            , Html.td [] [ text <| translator Github.stargazersTranslations]
            , Html.td [] [ text <| translator Github.languageTranslations ]
            ]

viewRepos : Model -> Html Msg
viewRepos model = 
    model.repos
        |> List.sortBy .stargazersCount
        |> List.reverse
        |> List.map viewRepo 
        |> (\xs -> viewReposHeader model :: xs)
        |> Html.table []


viewLanguageChoice : String -> Html Msg 
viewLanguageChoice language =
    option 
        [] 
        [ text language ]

viewChooseLanguage : Model -> Html Msg
viewChooseLanguage model =
    select [ onInput ChangeLanguage ] (List.map viewLanguageChoice languageKeys)  


view : Model -> Html Msg
view model =
    div 
        []
        [ viewChooseLanguage model 
        , viewAboutMe model.templates model.language
        , viewRepos model
        ]