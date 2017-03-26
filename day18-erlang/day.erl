-module(day).
-export([start/0]).

to_string(T) ->
        R= io_lib:format("~p",[T]),
        lists:flatten(R).

max_rows() -> 400000.

% string_to_list(string, iteration index, list)
string_to_list(S, I, L) ->
    D= (I > string:len(S)),
    if
        D ->
            L;
        true ->
            string_to_list(S, I+1, lists:append(L, [string:substr(S, I, 1)]))
    end.

first_row() ->
    "^.^^^.^..^....^^....^^^^.^^.^...^^.^.^^.^^.^^..^.^...^.^..^.^^.^..^.....^^^.^.^^^..^^...^^^...^...^.".

first_row_as_list() ->
    string_to_list(first_row(), 1, []).

% . --> safe = true
% ^ --> trap = false
symbol_to_bool(".") ->
    true;
symbol_to_bool("^") ->
    false.

row_to_bool(R) ->
    lists:map(fun symbol_to_bool/1, R).

start() ->
    print_all_rows(row_to_bool(first_row_as_list()), 1, max_rows()).

% A tile's safety depends on the safety of the tile at the same
% position in the previous row as well the tiles surrounding this
% previous row's tile. A tile is a trap (not safe) if in the previous row:
% - Its left and center tiles are traps, but its right tile is not.
% - Its center and right tiles are traps, but its left tile is not.
% - Only its left tile is a trap.
% - Only its right tile is a trap.
% is_safe(prev_left_type, prev_center_type, prev_right_type)
is_safe(false, false, true) ->
    false;
is_safe(true, false, false) ->
    false;
is_safe(false, true, true) ->
    false;
is_safe(true, true, false) ->
    false;
is_safe(L, C, R) ->
    true.

% find_next_row(previous/current row, index, nex_row_list)
find_next_row(P) ->
    find_next_row(P, 2, [is_safe(true, lists:nth(1, P), lists:nth(2, P))]).
find_next_row(P, I, N) ->
    L= (I == length(P)),
    if
        L ->
            lists:append(N, [is_safe(lists:nth(I-1, P), lists:nth(I, P), true)]);
        true ->
            find_next_row(P, I+1, lists:append(N, [is_safe(lists:nth(I-1, P), lists:nth(I, P), lists:nth(I+1, P))]))
    end.

is_true(B) -> B.

get_num_of_safe_tiles(R) ->
    length(lists:filter(fun is_true/1, R)).

% print_all_rows(start row, index, max_rows)
print_all_rows(R, 1, M) ->
    io:fwrite(to_string(R)),
    io:fwrite(to_string(get_num_of_safe_tiles(R))),
    print_all_rows(R, 2, M);
print_all_rows(R, I, M) ->
    E= I>M,
    if
        E ->
            false;
        true ->
            N= find_next_row(R),
            io:fwrite("\n"),
            io:fwrite(to_string(N)),
            io:fwrite(to_string(get_num_of_safe_tiles(N))),
            print_all_rows(N, I+1, M)
    end.
