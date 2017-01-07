module Translation exposing (..)

import Dict exposing (Dict)
import String.Extra

type alias Translation = 
    { en : String
    , sv : String
    , we : String 
    , no : String 
    }

type alias Templates =
    Dict String String

getterMap : Dict String (Translation -> String)
getterMap = 
    [ ( "English", .en )
    , ( "Welsh", .we )
    , ( "Norwegian", .no )
    , ( "Swedish", .sv )
    ]
        |> Dict.fromList

languageKeys : List String 
languageKeys = 
    Dict.keys getterMap 

defaultLanguage : String
defaultLanguage = "English"

defaultTranslator : (Translation -> String)
defaultTranslator = .en


getTranslation : String -> Translation -> String 
getTranslation language translations = 
    let 
        translator = 
            Dict.get language getterMap
                |> Maybe.withDefault defaultTranslator
    in 
        translator translations

insertTemplateString : Templates -> String -> String 
insertTemplateString templates text =
    Dict.foldl 
        (\k v formattedText -> String.Extra.replace ("{" ++ k ++ "}") v formattedText) text templates