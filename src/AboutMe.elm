module AboutMe exposing (translations, viewAboutMe)

import Html exposing (Html, text)
import Translation exposing (Translation, Templates)

translations : Translation
translations = 
    { en = me 
    , we = fi
    , sv = jag
    , no = jeg
    }

me : String 
me = """

I'm a programmer who loves open source and challenging problems. 
I also like languages! I have {repos} repos in {languagesCount} languages on Github. 

"""


jag : String 
jag = """

Jag är en programmerer som älskar open source och svåra problemer. 
Jag älskar ochså språk! Jar har {repos} repos på {languagesCount} språk i Github.

"""

jeg : String 
jeg = """

Jeg er en programmer som elsker open source og vanskelige problemer.
Jeg elsker ogsa språk! Jeg har {repos} repos på {languagesCount} språk i Github.

"""

fi : String
fi = """

Rydw i'n person sydd caru open source ac problemiau galed.
Rwyn caru iaith hefyd! Mae gen i {repos} mewn {languagesCount} iaith ar Github.

"""


viewAboutMe : Templates -> String -> Html msg
viewAboutMe templates language = 
    Translation.getTranslation language translations
        |> Translation.insertTemplateString templates
        |> Html.text
        |> (\text -> Html.p [] [ text ])

