module Main exposing (..)

import Html
import String
import Array
import Tuple

exampleInstructions : List( List (List Bool) -> List (List Bool))
exampleInstructions =
        -- Apparrently what I'm doing here is called currying
        -- and descibes the technique of translating the evaluation of
        -- a function that takes multiple areguments into a function
        -- that takes a single argument.
        --
        -- In this case each instruction (doRect, doRoatate, doColumn)
        -- takes 3 parameters. I would like to store the functions in a
        -- List with the first two parameters already added to them but not
        -- the last one.
        --
        -- So I have a list of the instructions here whereas a instruction is
        -- now composed of <function> -> Int -> Int
        -- which leaves only (List List(Bool)) (i.e. the display) to be passed
        -- to this instruction, which can then be done in the
        -- executeInstructionsOnDisplay function
        --
        -- I can' believe this works.
        -- It's basically a way of passing callbacks
        [(doRect 3 2),
         (doRotateColumn 1 1),
         (doRotateRow 0 4),
         (doRotateColumn 1 1)
        ]

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

getDisplayPrintable : List ( List Bool ) -> Html.Html ul
getDisplayPrintable display =
        Html.ul []  (List.map ( \row ->  Html.div [] [ Html.text (String.join " " ( List.map ( \pixelBool -> (if pixelBool then "#" else "_") ) row ) )]) display)

getDisplayLitPixelCount : List ( List Bool ) -> Int
getDisplayLitPixelCount display =
        List.length (
                List.concatMap ( \row ->
                        (List.filter ((==) True) row)
                ) display
        )

main : Html.Html a
main =
        let x =
                printDisplayToConsole (initDisplay)
        in
                Html.div [] [ getDisplayPrintable (executeInstructionsOnDisplay (input) (initDisplay) )]

executeInstructionsOnDisplay : List ( List ( List Bool ) -> List ( List Bool ) ) -> List ( List Bool ) -> List ( List Bool )
executeInstructionsOnDisplay instructions startDisplay =
        -- This function accepts a list of instructions
        -- (see the comment in exampeInstructions)
        -- and executes all the instructions recursively whereas
        -- the output of the first instruction (i.e. a display)
        -- will be the input of the second one and so on...
        -- Each time the first instruction will be dropped from the
        -- list after execution untill all are gone.
        if List.length instructions == 0 then
                startDisplay
        else
            let updatedDisplay =
                executeSingleInstructionOnDisplay (List.head instructions) startDisplay
            in
                executeInstructionsOnDisplay (List.drop 1 instructions) updatedDisplay

executeSingleInstructionOnDisplay : Maybe ( List ( List Bool ) -> List ( List Bool ) ) -> List ( List Bool ) -> List ( List Bool )
executeSingleInstructionOnDisplay instruction display =
        case instruction of
                Just instruction ->
                        instruction display
                Nothing ->
                        display

toIndexedDisplay : List ( List Bool ) -> List ( Int, List (Int, Bool) )
toIndexedDisplay display =
         Array.toIndexedList (Array.fromList (List.map (\row -> Array.toIndexedList (Array.fromList (row)) ) display))

shiftArray : Array.Array ( Bool ) -> Array.Array ( Bool )
shiftArray arr =
        -- Circularly shift the given array to the right by one index
        let revIndexes =
                -- A revesed list of all array indexes
                List.reverse (List.range 0 ((Array.length arr) - 1))

        in
            let lastOriginalElement =
                Maybe.withDefault False ( Array.get ((Array.length arr) - 1) arr )
            in
                Array.set 0 lastOriginalElement (
                    Array.fromList (
                        List.reverse (
                            List.map (
                                \idx -> ( Maybe.withDefault False ( Array.get (idx - 1) arr ) )
                            ) revIndexes
                        )
                    )
                )

doRect : Int -> Int -> List ( List Bool ) -> List ( List Bool )
doRect w h display =
        -- turns on all of the pixels in a rectangle at the top-left
        -- of the given display which is w wide and h tall.
        let indexedDisplay =
                (toIndexedDisplay display)
        in
                let
                        l = List.map ( \ir -> Debug.log "indexedDisplay :: " ir ) indexedDisplay
                in
                        List.map (\rowTuple -> (if ((Tuple.first rowTuple) < h) then ( List.map ( \indexedPixel -> if ((Tuple.first indexedPixel) < w) then True else ( Tuple.second indexedPixel ) ) (Tuple.second rowTuple) ) else ( List.map Tuple.second (Tuple.second rowTuple) )) ) indexedDisplay

doRotateRow : Int -> Int -> List ( List Bool ) -> List ( List Bool )
doRotateRow rowIdx offset display =
        -- shifts all of the pixels in row rowIdx (0 is the top row)
        -- right by offset pixels.
        -- Pixels that would fall off the right end appear at the left end of the row.
        -- Recursive
        -- Returns the new Display

        if offset == 0 then
                display
        else

                let displayArray =
                        -- Turn the List ( List Bool ) display to an Array ( Array Bool ) display
                        -- so that we can get elements by index
                        Array.fromList ( List.map Array.fromList display )
                in

                        let updatedDisplay =
                                -- move elements to the right by one in array
                                Array.set rowIdx ( shiftArray ( Maybe.withDefault Array.empty (Array.get rowIdx displayArray) ) ) displayArray
                        in
                                doRotateRow rowIdx (offset - 1) ( Array.toList ( Array.map Array.toList updatedDisplay ) )


doRotateColumn : Int -> Int -> List ( List Bool ) -> List ( List Bool )
doRotateColumn columnIdx offset display =
        -- shifts all of the pixels in column columnIdx (0 is the left column)
        -- down by offset pixels.
        -- Pixels that would fall off the bottom appear at the top of the column.
        -- Returns the new display

        if offset == 0 then
                display
        else

        let displayArray =
                -- Turn the List ( List Bool ) display to an Array ( Array Bool ) display
                -- so that we can get elements by index
                Array.fromList ( List.map Array.fromList display )
        in
                let columnArray =
                        Array.map ( \rowArray -> Maybe.withDefault False ( Array.get columnIdx ( rowArray ) ) ) displayArray
                in
                    let updatedColumnArray =
                        shiftArray columnArray
                    in
                        doRotateColumn columnIdx (offset - 1) (
                            List.map (
                                \rowIdx ->
                                        Array.toList ( Array.set columnIdx ( Maybe.withDefault False ( Array.get rowIdx updatedColumnArray )) ( Maybe.withDefault Array.empty ( Array.get rowIdx displayArray )) )
                            ) ( List.range 0 ( (Array.length updatedColumnArray ) - 1 ) )
                        )
