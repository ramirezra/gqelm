module Brand exposing (appBarHeight, canvasColor, cardColor, defaultBodyPadding, defaultPadding, defaultPaddingAmount, primaryColor, primaryColorBolder, primaryTextColor, shadowColor, subtleTextColor)

import Colors
import Element exposing (padding, rgb255, rgba255)


primaryColor : Element.Color
primaryColor =
    Colors.red500


primaryColorBolder : Element.Color
primaryColorBolder =
    Colors.red700


primaryTextColor : Element.Color
primaryTextColor =
    rgb255 255 255 255


canvasColor : Element.Color
canvasColor =
    Colors.grey400


cardColor : Element.Color
cardColor =
    rgb255 255 255 255


shadowColor : Element.Color
shadowColor =
    rgba255 0 0 0 0.05


subtleTextColor : Element.Color
subtleTextColor =
    rgb255 200 200 200


defaultPadding : Element.Attribute msg
defaultPadding =
    Element.padding defaultPaddingAmount


defaultPaddingAmount : Int
defaultPaddingAmount =
    20


defaultBodyPadding : Element.Attribute msg
defaultBodyPadding =
    Element.paddingEach
        { top = appBarHeight + defaultPaddingAmount
        , left = defaultPaddingAmount
        , right = defaultPaddingAmount
        , bottom = defaultPaddingAmount
        }


appBarHeight : Int
appBarHeight =
    75
