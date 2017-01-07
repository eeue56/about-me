module Update exposing (update, Msg(..), loadRequest)

import Dict 
import Http

import Model exposing (Model)
import Github exposing (Repo, getRepos)

type Msg 
    = NoOp
    | ChangeLanguage String
    | LoadRepos Int (List Repo)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        NoOp -> (model, Cmd.none)

        ChangeLanguage language ->
            ( { model | language = language }, Cmd.none )

        LoadRepos pageNumber repos ->
            let
                nextPage = 
                    if List.length repos < 100 then 
                        Cmd.none 
                    else 
                        Http.send 
                            (loadRequest (LoadRepos (pageNumber + 1))) 
                            (getRepos "eeue56" (pageNumber + 1))

                joinedRepos = 
                    List.concat [ model.repos, repos ]

                countLanguages =
                    Github.countLanguages joinedRepos 
            in
                ( 
                    { model 
                    | repos = joinedRepos
                    , templates = 
                        model.templates
                            |> Dict.insert "repos" 
                                (toString <| List.length joinedRepos) 
                            |> Dict.insert "languagesCount" 
                                (toString <| List.length <| Dict.keys <| countLanguages)
                            |> Dict.insert "languageBreakdown"
                                (Github.languageBreakdown countLanguages)
                    }
                , nextPage
                )


loadRequest : (v -> Msg) -> Result x v  -> Msg
loadRequest load result =
    case result of 
        Err _ -> NoOp
        Ok v -> load v 