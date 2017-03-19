-module(day).
-export([start/0]).

to_string(T) ->
        R= io_lib:format("~p",[T]),
        lists:flatten(R).

% x, y
init_location() ->
        {0, 0, "hhhxzeay"}.

target_coordinates() ->
        {3, 3}.

move_up(X, Y, C, false) ->
        {X, Y, C, false};
move_up(X, Y, C, true) ->
        {X, Y-1, string:concat(C, "U"), true}.

move_down(X, Y, C, false) ->
        {X, Y, C, false};
move_down(X, Y, C, true) ->
        {X, Y+1, string:concat(C, "D"), true}.

move_left(X, Y, C, false) ->
        {X, Y, C, false};
move_left(X, Y, C, true) ->
        {X-1, Y, string:concat(C, "L"), true}.

move_right(X, Y, C, false) ->
        {X, Y, C, false};
move_right(X, Y, C, true) ->
        N= X+1,
        S= string:concat(C, "R"),
        {N, Y, S, true}.

can_move_up(X, 0, C) ->
        false;
can_move_up(X, Y, C) ->
        is_unlocked(lists:nth(1, get_md5_short(C))).

can_move_down(X, 3, C) ->
        false;
can_move_down(X, Y, C) ->
        is_unlocked(lists:nth(2, get_md5_short(C))).

can_move_left(0, Y, C) ->
        false;
can_move_left(X, Y, C) ->
        is_unlocked(lists:nth(3, get_md5_short(C))).

can_move_right(3, Y, C) ->
        false;
can_move_right(X, Y, C) ->
        is_unlocked(lists:nth(4, get_md5_short(C))).

% requires: code for this room
% guarantees: returns a tuple with booleans indicating whether
%             a direction is a accessible: {up, down, left, right}
get_room_layout(X, Y, C) ->
        {can_move_up(X, Y, C), can_move_down(X, Y, C), can_move_left(X, Y, C), can_move_right(X, Y, C), X, Y, C}.

unmoveable(false, false, false, false) ->
        true;
unmoveable(A, B, C, D) ->
        false.

get_path_length(ok) ->
        "0";
get_path_length(R) ->
        to_string(string:len(R)).

iterate(3, 3, C, R) ->
        %io:fwrite(R),
        %io:fwrite("\n--------------\n"),
        io:fwrite(get_path_length(R)),
        io:fwrite("\n"),
        R;
iterate(X, Y, C, R) ->
        U= unmoveable(can_move_up(X, Y, C), can_move_down(X, Y, C), can_move_left(X, Y, C), can_move_right(X, Y, C)),
        if
                U ->
                        R;
                true ->
                        iterate_down(X, Y, C, R),
                        iterate_right(X, Y, C, R),
                        iterate_left(X, Y, C, R),
                        iterate_up(X, Y, C, R),
                        "X"
        end.



iterate_down(X, Y, C, R) ->
        O= move_down(X, Y, C, can_move_down(X, Y, C)),
        if
                element(4, O) ->
                        iterate(element(1, O), element(2, O), element(3, O), string:concat(R, "D"));
                true ->
                        R
        end.

iterate_left(X, Y, C, R) ->
        O= move_left(X, Y, C, can_move_left(X, Y, C)),
        if
                element(4, O) ->
                        iterate(element(1, O), element(2, O), element(3, O), string:concat(R, "L"));
                true ->
                        R
        end.

iterate_up(X, Y, C, R) ->
        O= move_up(X, Y, C, can_move_up(X, Y, C)),
        if
                element(4, O) ->
                        iterate(element(1, O), element(2, O), element(3, O), string:concat(R, "U"));
                true ->
                        R
        end.

iterate_right(X, Y, C, R) ->
        O= move_right(X, Y, C, can_move_right(X, Y, C)),
        if
                element(4, O) ->
                        iterate(element(1, O), element(2, O), element(3, O), string:concat(R, "R"));
                true ->
                        R
        end.

start() ->
        L= init_location(),
        X= element(1, L),
        Y= element(2, L),
        C= element(3, L),
        io:fwrite(to_string(iterate(X, Y, C, ""))).

% get the first 4 letters of the md5 hash for S
get_md5_short(S) ->
        lists:sublist(lists:flatten(daymd5:md5_hex(S)), 1, 4).

open_characters() ->
        "bcdef".

locked_characters() ->
        "0123456789a".

% returns true if a given hex character indicates that the door is unlocked
is_unlocked(C) ->
        string:chr(open_characters(), C) > 0.
