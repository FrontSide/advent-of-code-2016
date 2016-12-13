module Main exposing (..)

import Html
import String
import Array
import Tuple

displayWidth : Int
displayWidth =
        50

displayHight : Int
displayHight =
        6

initDisplay : List ( List Bool )
initDisplay =
        List.repeat displayHight (List.repeat displayWidth False)

exampleDisplay : List ( List Bool )
exampleDisplay =
        List.repeat 3 (List.repeat 7 False)

printDisplayToConsole : List ( List Bool ) -> List (String, String)
printDisplayToConsole display =
        List.map ( \printableRow -> ( Debug.log "Display" printableRow, Debug.log "Display" "" ) ) ( List.map ( \row -> ( String.join "" ( List.map ( \pixelBool -> (if pixelBool then "#" else ".") ) row ) ) ) display )

getDisplayPrintable : List ( List Bool ) -> String
getDisplayPrintable display =
        String.join "<br>" (List.map ( \row ->  String.join "" ( List.map ( \pixelBool -> (if pixelBool then "#" else ".") ) row ) ) display)


main : Html.Html a
main =
        let x =
                printDisplayToConsole (initDisplay)
        in
                Html.div [] [ Html.text (getDisplayPrintable (doRect initDisplay 2 4)) ]

toIndexedDisplay : List ( List Bool ) -> List ( Int, List (Int, Bool) )
toIndexedDisplay display =
         Array.toIndexedList (Array.fromList (List.map (\row -> Array.toIndexedList (Array.fromList (row)) ) display))

doRect : List ( List Bool ) -> Int -> Int -> List ( List Bool )
doRect display w h =
        -- turns on all of the pixels in a rectangle at the top-left
        -- of the given display which is w wide and h tall.
        let indexedDisplay =
                (toIndexedDisplay display)
        in
                let
                        l = List.map ( \ir -> Debug.log "indexedDisplay :: " ir ) indexedDisplay
                in
                        List.map (\rowTuple -> (if ((Tuple.first rowTuple) < h) then ( List.map ( \indexedPixel -> ((Tuple.first indexedPixel) < w) ) (Tuple.second rowTuple) ) else ( List.map Tuple.second (Tuple.second rowTuple) )) ) indexedDisplay

doRotateRow : List ( List Bool ) -> Int -> Int -> List ( List Bool )
doRotateRow display rowIdx offset =
        -- shifts all of the pixels in row rowIdx (0 is the top row)
        -- right by offset pixels.
        -- Pixels that would fall off the right end appear at the left end of the row.
        -- Returns the new Display
        display

doRotateColumn : List ( List Bool ) -> Int -> Int -> List ( List Bool )
doRotateColumn display columnIdx offset =
        -- shifts all of the pixels in column columnIdx (0 is the left column)
        -- down by offset pixels.
        -- Pixels that would fall off the bottom appear at the top of the column.
        -- Returns the new display
        display
