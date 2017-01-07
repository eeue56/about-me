module Flags exposing (viewFlag, translations)

import Html exposing (Html, img)
import Html.Attributes exposing (src, alt)

import Translation exposing (Translation, getTranslation)

translations : Translation
translations =
    { en = "images/en.svg"
    , sv = "images/sv.png"
    , no = "images/no.png"
    , we = "images/we.png"
    }

viewFlag : String -> Html msg
viewFlag language = 
    let 
        imgSrc = 
            getTranslation language translations
    in 
        img 
            [ src imgSrc
            , alt (language ++ " flag") 
            ]
            []
