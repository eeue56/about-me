module Github exposing (..)


import Http
import HttpBuilder exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (..)


getRepos : String -> Int -> Http.Request (List Repo)
getRepos username pageNumber = 
  "https://api.github.com/users/" ++ username ++ "/repos?per_page=100&page=" ++ (toString pageNumber)
    |> get
    |> withExpect (Http.expectJson decodeRepos) 
    |> toRequest


type alias Repo = 
    { name : String
    , stargazersCount : Int
    , watchersCount : Int
    , language : String
    }

decodeRepo : Decoder Repo 
decodeRepo =
    decode Repo 
        |> optional "name" Decode.string "None"
        |> optional "stargazers_count" Decode.int 0
        |> optional "watchers_count" Decode.int 0
        |> optional "language" Decode.string "None"

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
