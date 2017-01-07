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
I also like languages! I have {repos} repos on Github.

"""


jag : String 
jag = """

Jag är en programmerer som älskar open source och problemer svårt. 
Jag ochså älskar språk! Jar har {repos} repos på Github.

"""

jeg : String 
jeg = """

Jeg er en programmer som elsker open source och programmer hard.
Jeg ogsa elsker språk! Jeg har {repos} repos på Github.

"""

fi : String
fi = """

Rwyn person sydd caru open source ac problemiau galed.
Rwyn caru iaith hefyd! Mae gen i {repos} ar Github.

"""


viewAboutMe : Templates -> String -> Html msg
viewAboutMe templates language = 
    Translation.getTranslation language translations
        |> Translation.insertTemplateString templates
        |> Html.text
