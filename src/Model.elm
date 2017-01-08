module Model exposing (Model, encodeModel, decodeModel)

import Dict exposing (Dict)

import Json.Encode as Json
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (..)

import Translation exposing (Templates)
import Github exposing (Repo, encodeRepo, decodeRepo)

type alias Model = 
    { language : String 
    , repos : List Repo
    , templates : Templates
    }

encodeModel : Model -> Json.Value
encodeModel model = 
    Json.object
        [ ("language", Json.string model.language)
        , ("repos", Json.list <| List.map encodeRepo model.repos)
        , ("templates", encodeDict Json.string model.templates)
        ]

encodeDict : (b -> Json.Value) -> Dict String b -> Json.Value
encodeDict fb dict =
    Dict.toList dict
        |> List.map (\(a, b) -> (a, fb b))
        |> Json.object 


decodeModel : Decoder Model 
decodeModel =
    decode Model
        |> optional "language" Decode.string Translation.defaultLanguage
        |> optional "repos" (Decode.list decodeRepo) []
        |> optional "templates" (Decode.dict Decode.string) Dict.empty