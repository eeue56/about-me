module Update exposing (update, Msg(..), loadRequest, alwaysSaveModel, loadModel)

import Dict 
import Http
import Task

import Model exposing (Model)
import Github exposing (Repo, getRepos)
import LocalStorage

type Msg 
    = NoOp
    | ChangeLanguage String
    | LoadRepos Int (List Repo)
    | LoadModel Model 
    | LoadRepo Repo

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        NoOp -> (model, Cmd.none)

        ChangeLanguage language ->
            ( { model | language = language }, Cmd.none )

        LoadRepos pageNumber repos ->
            loadRepos model pageNumber repos

        LoadRepo repo ->
            let
                (newModel, _) =
                    loadRepos model 0 [ repo ]
            in
                ( newModel, Cmd.none )

        LoadModel newModel ->
            ( newModel, Cmd.none )

alwaysSaveModel : (Model, Cmd Msg) -> (Model, Cmd Msg)
alwaysSaveModel (model, cmds) =
    (model, Cmd.batch [ cmds, saveModel model ])


loadRequest : (v -> Msg) -> Result x v  -> Msg
loadRequest load result =
    case result of 
        Err _ -> NoOp
        Ok v -> load v 


loadRepos : Model -> Int -> List Repo -> (Model, Cmd Msg)
loadRepos model pageNumber repos =
    let
        nextPage = 
            if List.length repos < 100 then 
                Cmd.none 
            else 
                Http.send 
                    (loadRequest (LoadRepos (pageNumber + 1))) 
                    (getRepos "eeue56" (pageNumber + 1))

        names = 
            List.map .name repos 

        joinedRepos = 
            addAndReplaceRepos model.repos repos

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

{-|
    Takes a list of repos we already got, then a list of new repos,
    returns a list of the two joined - with any repos with the same name replaced by the second 
    occurance

    >>> addAndReplaceRepos [ {name = "hello", stargazersCount = 2, language="none"}] [ {name = "hello", stargazersCount = 2, language="some"}]
    [ {name = "hello", stargazersCount = 2, language="some"} ]
-}
addAndReplaceRepos : List Repo -> List Repo -> List Repo 
addAndReplaceRepos original new =
    let
        newNames = 
            List.map .name new

        originalWithThoseInNew = 
            original
                |> List.filter (\repo -> not <| List.member repo.name newNames)
    in
        originalWithThoseInNew ++ new


saveModel : Model -> Cmd Msg 
saveModel model = 
    LocalStorage.store "elm-model" (Model.encodeModel model)

loadModel : Cmd Msg 
loadModel =
    LocalStorage.getJson (Model.decodeModel) "elm-model" 
        |> Task.attempt (\res ->
            case res of
                Ok (Just model) -> LoadModel model 
                _ -> NoOp
        )