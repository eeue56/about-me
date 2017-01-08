module View exposing (..)

import Model exposing (..)
import Update exposing (..)

import Html exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes exposing (style)

import Github
import AboutMe exposing (viewAboutMe)
import FavouriteProjects exposing (viewFavouriteProjects, projectsWithMaybeRepos)
import Translation exposing (..)
import ViewCss exposing (viewStyle, CssClass(..), namespacedCss)


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
        [ ] 
        [ text language ]

viewChooseLanguage : Model -> Html Msg
viewChooseLanguage model =
    List.map viewLanguageChoice languageKeys
        |> select [ onInput ChangeLanguage, namespacedCss.class [ LanguageSelect ] ] 


view : Model -> Html Msg
view model =
    div 
        [ namespacedCss.class [ Main ] ]
        [ ViewCss.viewStyle
        , viewChooseLanguage model 
        , viewAboutMe model.templates model.language
        , viewFavouriteProjects model.language (projectsWithMaybeRepos model.repos FavouriteProjects.allProjects)
        ]

