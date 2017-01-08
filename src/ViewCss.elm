module ViewCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)
import Html.CssHelpers
import Html exposing (Html)

namespacedCss : Html.CssHelpers.Namespace String class id msg
namespacedCss =
    Html.CssHelpers.withNamespace "main"

type CssClass 
    = Main
    | LanguageSelect
    | ProjectName
    | GithubStar
    | GithubStarCount
    | GithubLanguage

viewStyle : Html msg
viewStyle = 
    [ css ]
        |> compile 
        |> .css
        |> Html.CssHelpers.style

css : Stylesheet
css = 
    [ (.) Main
        [ margin (px 50)
        , position relative
        , fontSize (px 26)
        ]
    , (.) LanguageSelect
        [ position absolute 
        , right (px 0)
        , top (px -40)
        , height (px 20)
        ]
    , (.) ProjectName
        [ margin (px 3)
        , marginRight (px 10)
        , fontSize (px 30)
        , fontStyle italic
        ]
    , (.) GithubStar 
        [ height (px 20)
        , width (px 20)
        , marginRight (px 3)
        ]
    , (.) GithubStarCount
        [ marginRight (px 10)
        ]
    , (.) GithubLanguage
        [ fontSize (px 20)
        ]
    ]
        |> namespace namespacedCss.name
        |> stylesheet

