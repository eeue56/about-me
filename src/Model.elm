module Model exposing (Model)

import Translation exposing (Templates)
import Github exposing (Repo)

type alias Model = 
    { language : String 
    , repos : List Repo
    , templates : Templates
    }
