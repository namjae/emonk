
-module(emonk).
-on_load(init/0).


-export([add_worker/0, rem_worker/0, num_workers/0]).
-export([create_ctx/0, create_ctx/1]).
-export([eval/2, call/3]).


-define(APPNAME, emonk).
-define(LIBNAME, emonk).
-define(CTX_STACK, 8192).

add_worker() ->
    not_loaded(?LINE).

rem_worker() ->
    not_loaded(?LINE).

num_workers() ->
    not_loaded(?LINE).

create_ctx() ->
    create_ctx(?CTX_STACK).

create_ctx(_) ->
    not_loaded(?LINE).

eval(Ctx, Script) ->
    Ref = make_ref(),
    eval(Ctx, Ref, self(), Script),
    receive
        {Ref, Resp} -> Resp
    end.

eval(_Ctx, _Ref, _Dest, _Script) ->
    not_loaded(?LINE).

call(Ctx, Name, Args) ->
    Ref = make_ref(),
    call(Ctx, Ref, self(), Name, Args),
    receive
        {Ref, Resp} -> Resp
    end.

call(_Ctx, _Ref, _Dest, _Name, _Args) ->
    not_loaded(?LINE).

%% Internal API

init() ->
    SoName = case code:priv_dir(?APPNAME) of
        {error, bad_name} ->
            case filelib:is_dir(filename:join(["..", priv])) of
                true ->
                    filename:join(["..", priv, ?LIBNAME]);
                _ ->
                    filename:join([priv, ?LIBNAME])
            end;
        Dir ->
            filename:join(Dir, ?LIBNAME)
    end,
    erlang:load_nif(SoName, 0).


not_loaded(Line) ->
    exit({not_loaded, [{module, ?MODULE}, {line, Line}]}).