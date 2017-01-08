module Github exposing (..)


import Dict exposing (Dict)
import Http
import HttpBuilder exposing (..)
import Json.Encode as Encode
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (..)

import Translation exposing (Translation)

nameTranslations : Translation
nameTranslations =
    { en = "Name"
    , sv = "Namn"
    , no = "Navn"
    , we = "Enw"
    }

stargazersTranslations : Translation
stargazersTranslations =
    { en = "Stargazers"
    , sv = "Stargazers"
    , no = "Stargazers"
    , we = "Stargazers"
    }

languageTranslations : Translation
languageTranslations =
    { en = "Language"
    , sv = "Språk"
    , no = "Språk"
    , we = "Iaith"
    }


getRepos : String -> Int -> Http.Request (List Repo)
getRepos username pageNumber = 
  "https://api.github.com/users/" ++ username ++ "/repos?per_page=100&page=" ++ (toString pageNumber)
    |> get
    |> withExpect (Http.expectJson decodeRepos) 
    |> toRequest


incrementLanguage : Maybe number -> Maybe number
incrementLanguage maybeLang = 
    case maybeLang of 
        Nothing -> Just 1
        Just v -> Just (v + 1)

countLanguages : List Repo -> Dict String Int
countLanguages =
    List.map .language 
        >> List.foldl (\language dict -> Dict.update language incrementLanguage dict) Dict.empty

languageBreakdown : Dict String Int -> String
languageBreakdown dict =
    Dict.toList dict
        |> List.sortBy Tuple.second
        |> List.reverse
        |> List.map (\(k, v) -> k ++ ":" ++ (toString v))
        |> String.join ","



type alias Repo = 
    { name : String
    , stargazersCount : Int
    , language : String
    }

decodeRepo : Decoder Repo 
decodeRepo =
    decode Repo 
        |> optional "name" Decode.string "None"
        |> optional "stargazers_count" Decode.int 0
        |> optional "language" Decode.string "None"


encodeRepo : Repo -> Encode.Value
encodeRepo repo =
    Encode.object 
        [ ( "name", Encode.string repo.name )
        , ( "stargazers_count", Encode.int repo.stargazersCount )
        , ( "language", Encode.string repo.language)
        ]

decodeFilterList : Decoder a -> Decoder (List a)
decodeFilterList decoder =
    Decode.list Decode.value
        |> Decode.andThen (\values ->
            List.filterMap (Decode.decodeValue decoder >> Result.toMaybe) values
                |> Decode.succeed
        )

decodeRepos : Decoder (List Repo)
decodeRepos =
    decodeFilterList decodeRepo


