module Main exposing (..)

import Html
import Array
import Regex
import List
import String
import Debug

-- Copy the content of input_asarrays.txt 1:1 here

--inpt : List String
--inpt =
--   [ "abba[mnop]qrst", "abcd[bddb]xyyx", "aaaa[qwer]tyui", "ioxxoj[asdfgh]zxcvbn" ]

inpt : List String
inpt =
        ["aba[bab]xyz",
         "xyx[xyx]xyx",
         "aaa[kek]eke",
         "zazbz[bzb]cdb" ]

main : Html.Html a
main =

    -- uncomment the following lines to run task 1
    -------------------------------------------------
    --let total =
        --    (amountofStringsWithTLSSupport inpt0 +
        --    amountofStringsWithTLSSupport inpt1 +
        --    amountofStringsWithTLSSupport inpt2 +
        --    amountofStringsWithTLSSupport inpt3 +
        --    amountofStringsWithTLSSupport inpt4 +
        --    amountofStringsWithTLSSupport inpt5 +
        --    amountofStringsWithTLSSupport inpt6 +
        --    amountofStringsWithTLSSupport inpt7 +
        --    amountofStringsWithTLSSupport inpt8 +
        --    amountofStringsWithTLSSupport inpt9 +
        --    amountofStringsWithTLSSupport inpt10 +
        --    amountofStringsWithTLSSupport inpt11 +
        --    amountofStringsWithTLSSupport inpt12 +
        --    amountofStringsWithTLSSupport inpt13 +
        --    amountofStringsWithTLSSupport inpt14 +
        --    amountofStringsWithTLSSupport inpt15 +
        --    amountofStringsWithTLSSupport inpt16 +
        --    amountofStringsWithTLSSupport inpt17 +
        --    amountofStringsWithTLSSupport inpt18 +
        --    amountofStringsWithTLSSupport inpt19)
    --in
        --    Html.div [] [ Html.text (toString (total)) ]

      -- uncomment the following lines to run task 2
      --------------------------------------------------
      let total =
              (amountofStringsWithSSLSupport inpt0 +
               amountofStringsWithSSLSupport inpt1 +
               amountofStringsWithSSLSupport inpt2 +
               amountofStringsWithSSLSupport inpt3 +
               amountofStringsWithSSLSupport inpt4 +
               amountofStringsWithSSLSupport inpt5 +
               amountofStringsWithSSLSupport inpt6 +
               amountofStringsWithSSLSupport inpt7 +
               amountofStringsWithSSLSupport inpt8 +
               amountofStringsWithSSLSupport inpt9 +
               amountofStringsWithSSLSupport inpt10 +
               amountofStringsWithSSLSupport inpt11 +
               amountofStringsWithSSLSupport inpt12 +
               amountofStringsWithSSLSupport inpt13 +
               amountofStringsWithSSLSupport inpt14 +
               amountofStringsWithSSLSupport inpt15 +
               amountofStringsWithSSLSupport inpt16 +
               amountofStringsWithSSLSupport inpt17 +
               amountofStringsWithSSLSupport inpt18 +
               amountofStringsWithSSLSupport inpt19)
      in
              Html.div [] [ Html.text (toString (total)) ]

    -- uncomment the following line to use the small input array for the 2nd task
    -- Html.div[] [ Html.text (toString (amountofStringsWithSSLSupport inpt)) ]


amountofStringsWithTLSSupport : List String -> Int
amountofStringsWithTLSSupport lst =
    List.length (List.filter (\str -> supportsTLS str) lst)

amountofStringsWithSSLSupport : List String -> Int
amountofStringsWithSSLSupport lst =
    List.length (List.filter (\str -> supportsSSL str) lst)


supportsTLS : String -> Bool
supportsTLS str =
    if amuntofABBAStrings (sequencesFromSquareBrackets str) > 0 then
        False
    else if amuntofABBAStrings (sequencesFromOutsideSquareBrackets str) > 0 then
        True
    else
        False

supportsSSL : String -> Bool
supportsSSL str =
        List.length (List.filter (\aba -> (containsBABForABA (sequencesFromSquareBrackets str) aba)) (getABAs (sequencesFromOutsideSquareBrackets str))) > 0


isABBA : Array.Array Char -> Bool
isABBA chars =
    let
        l = Debug.log "isABBA : " (toString chars)
    in
        if Array.length chars /= 4 then
            False
        else if (Array.get 0 chars /= Array.get 1 chars) && (Array.get 0 chars == Array.get 3 chars) && (Array.get 1 chars == Array.get 2 chars) then
            True
        else
            False


containsABBA : Array.Array Char -> Bool
containsABBA chars =
    List.length (List.filter (\subslice -> isABBA subslice) (List.map (\idx -> getSubsliceLengthFour chars idx) (List.range 0 ((Array.length chars) - 4)))) > 0


isABA : Array.Array Char -> Bool
isABA chars =
         let
             l = Debug.log "isABA : " (toString chars)
         in
                if Array.length chars /= 3 then
                    False
                else if (Array.get 0 chars == Array.get 2 chars) && (Array.get 0 chars /= Array.get 1 chars) then
                    True
                else
                    False

isBAB : Array.Array Char -> Array.Array Char -> Bool
isBAB chars aba =
         let
             l = Debug.log "isBAB : " (toString chars)
         in
        if Array.length chars /= 3 then
            False
        -- every bab is also an aba
        else if not (isABA chars) then
            False
        else if (Array.get 1 aba == Array.get 0 chars) &&  (Array.get 0 aba == Array.get 1 chars) then
            True
        else False


getABAs : List (Maybe String) -> List (Array.Array Char)
getABAs strings =
        List.concatMap (
                 \string -> List.filter (\subslice -> isABA subslice) (List.map (\idx -> getSubsliceLengthThree (Array.fromList (String.toList (Maybe.withDefault "" string))) idx) (List.range 0 ((Array.length (Array.fromList (String.toList (Maybe.withDefault "" string)))) - 3)))
        ) strings



containsBABForABA : List (Maybe String) -> Array.Array Char -> Bool
containsBABForABA strings aba =

        List.length(
            List.concatMap (
                \string -> List.filter ( \subslice -> isBAB subslice aba ) (List.map (\idx -> getSubsliceLengthThree (Array.fromList (String.toList (Maybe.withDefault "" string))) idx) (List.range 0 ((Array.length (Array.fromList (String.toList (Maybe.withDefault "" string)))) - 3)))
            ) strings
        ) > 0


getSubsliceLengthFour : Array.Array Char -> Int -> Array.Array Char
getSubsliceLengthFour chars startIndex =
    let
        l = Debug.log "Make subslice : " (chars, startIndex)
    in
        Array.slice (startIndex) (startIndex + 4) chars

getSubsliceLengthThree : Array.Array Char -> Int -> Array.Array Char
getSubsliceLengthThree chars startIndex =
    let
        l = Debug.log "Make subslice : " (chars, startIndex)
    in
        Array.slice (startIndex) (startIndex + 3) chars


amuntofABBAStrings : List (Maybe String) -> Int
amuntofABBAStrings strings =
    List.length (List.filter (\string -> containsABBA (Array.fromList (String.toList (Maybe.withDefault "" string)))) strings)


sequencesFromSquareBrackets : String -> List (Maybe String)
sequencesFromSquareBrackets str =
    List.concatMap (\match -> match.submatches) (Regex.find Regex.All (Regex.regex "\\[(\\w+)\\]") str)


sequencesFromOutsideSquareBrackets : String -> List (Maybe String)
sequencesFromOutsideSquareBrackets str =
    List.append
        (List.concatMap
            (\match -> (match.submatches))
            (Regex.find Regex.All (Regex.regex "(\\w+)\\[") str)
        )
        (List.concatMap
            (\match -> (match.submatches))
            (Regex.find Regex.All (Regex.regex "\\](\\w+)$") str)
        )


toHtmlList : List (Maybe String) -> Html.Html msg
toHtmlList strings =
    Html.ul [] (List.map toHtmlListElement strings)


toHtmlListElement : Maybe String -> Html.Html msg
toHtmlListElement element =
    case element of
        Just element ->
            Html.li [] [ Html.text element ]

        Nothing ->
            Html.li [] [ Html.text "" ]
