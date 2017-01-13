module FavouriteProjects exposing (..)

import Html exposing (Html)
import Html.Attributes

import Translation exposing (Translation)
import Github exposing (Repo)
import ViewCss exposing (CssClass(..), namespacedCss)


type alias FavouriteProject = 
    { about : Translation
    , owner : String
    , name : String
    }


allProjects : List FavouriteProject 
allProjects = 
    [ takeHome 
    , slackTodayIDid
    ] 


-- TODO: refactor heavily
projectsWithMaybeRepos : List Repo -> List FavouriteProject -> List (FavouriteProject, Maybe Repo)
projectsWithMaybeRepos repos favourites =
    favourites
        |> List.map (\fav -> 
            List.filter (\repo -> repo.name == fav.name) repos
                |> List.head
                |> (\head -> (fav, head))
        )


viewAboutProject : String -> Html msg 
viewAboutProject about =
    Html.div 
        []
        [ Html.text about ]

viewRepoTitle : String -> String -> Html msg 
viewRepoTitle owner name =
    let 
        url =
            "https://github.com/" ++ owner ++ "/" ++ name
    in
        Html.a
            [ namespacedCss.class [ProjectName] 
            , Html.Attributes.href url
            ] 
            [ Html.text name ]


viewStargazers : Repo -> Html msg 
viewStargazers repo =
    Html.span 
        [] 
        [ Html.img 
            [ Html.Attributes.src "images/star.png" 
            , namespacedCss.class [ GithubStar ]
            ] 
            [] 
        , Html.span 
            [ namespacedCss.class [ GithubStarCount ] ]
            [ Html.text <| toString repo.stargazersCount ]
        ]

languageTranslations = 
    { en = "Written in "
    , sv = "Skrever på "
    , no = "Skrever på "
    , we = "Ysgrifennu mewn "
    }

viewLanguage : String -> Repo -> Html msg
viewLanguage language repo = 
    (Translation.getTranslation language languageTranslations) ++ repo.language
        |> Html.text
        |> (\text -> 
            Html.span 
                [ namespacedCss.class [ GithubLanguage ] ] 
                [ text ]
        )

viewRepoInfo : String -> Maybe Repo -> FavouriteProject -> Html msg
viewRepoInfo language maybeRepo project =
    case maybeRepo of 
        Nothing -> 
            Html.div 
                []
                [ viewRepoTitle project.owner project.name
                ]
        Just repo ->
            Html.div 
                []
                [ viewRepoTitle repo.owner repo.name
                , viewStargazers repo
                , viewLanguage language repo
                ]   

viewFavouriteProject : String -> FavouriteProject -> Maybe Repo -> Html msg
viewFavouriteProject language project repo = 
    Html.div 
        []
        [ viewRepoInfo language repo project
        , viewAboutProject (Translation.getTranslation language project.about)
        ]

viewFavouriteProjects : String -> List (FavouriteProject, Maybe Repo) -> Html msg 
viewFavouriteProjects language projects =
    List.map (\(project, repo) -> viewFavouriteProject language project repo) projects
        |> Html.div []


takeHome : FavouriteProject 
takeHome =
    { name = "take-home"
    , owner = "NoRedInk"
    , about =
        { en = """
The world's only full-stack Elm project! 
It has a lot of cool features, like server-side-rendering, CSS in Elm, server-client shared types and code,
and seemless interop between client and server.
"""
        , sv = """
Världens ända full-stack Elm projekt!
Det har flera coola saker som server-side-rendering, CSS i Elm, server-client delade types och interop mellan client och server.
"""
        , no = """
Vårld enst full-stack Elm prosjekt!
Det har manga kjempe bra saker som server-side-rendering, CSS i Elm, types delt fra server til client og interop mellom client og server.

"""
        , we = """
Yr unig full-stack project yn yr byd! 
Mae gen e llawer o pethaiu sy'n unigryw i e, fel server-side-rendering, CSS i Elm, types o'r server gweithio gyda'r client, ac interop dros yr client ac server.

"""
        }
    }


slackTodayIDid : FavouriteProject 
slackTodayIDid =
    { name = "slack-today-i-did"
    , owner = "NoRedInk"
    , about =
        { en = """
The first Slackbot framework written in Python 3.6. It's designed to be interface-agnostic, so it also supports a REPL interface. 

It uses Python's type system to implement a type-safe interface too! If you give it a command, you must specify the types of each argument it expects.
It will then use those arguments to verify the inputs given by the users. It also lets you search for commands by their type!

"""
        , sv = """
Det första Slackbot frameworket skrivet i Python 3.6. Det är designat för att vara interface agnostiskt, och har ett REPL interface.

Det använder Pythons typsystem för att implementera ett typsäkert interface. Om du ger det ett komando, så måste du specificera typerna till varje 
argument. 
Argumenten används sendan för att verifiera de inputs användaren ger. Det går även att söka efter kommandon genom att ange typ.
"""
        , no = """
The first Slackbot framework written in Python 3.6. It's designed to be interface-agnostic, so it also supports a REPL interface. 

It uses Python's type system to implement a type-safe interface too! If you give it a command, you must specify the types of each argument it expects.
It will then use those arguments to verify the inputs given by the users. It also lets you search for commands by their type!

"""
        , we = """
The first Slackbot framework written in Python 3.6. It's designed to be interface-agnostic, so it also supports a REPL interface. 

It uses Python's type system to implement a type-safe interface too! If you give it a command, you must specify the types of each argument it expects.
It will then use those arguments to verify the inputs given by the users. It also lets you search for commands by their type!

"""
        }
    }
