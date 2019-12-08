:- dynamic
	damage/1,
        left/1,
	health/2,
	stats/5,
	status/3.
	
% Runs the game
:- use_module(library(lists)).
:- use_module(library(random)).

run :-
    clean,
    start_game,
    play_game,
    end_game,
    !.

start_game :- 
    draw_start,
    read(Input),
    (Input == 'start') -> select_game_mode;
    start_game,
    !.

select_game_mode :-
    assert(select),
    draw_menu(select), % draw selection menu
    read(Input),
    ((Input == 'single') -> select_single_mode; % single player mode
    (Input == 'double') -> select_double_mode; % double player mode
    (Input == 'dex') -> select_dex_mode; % view the dex
    select_game_mode),
    !.

select_single_mode :-
    assert(mode(single)),
    assert(player1),
    assert(player2),
    assert(ai_player(player2)),
    select_prologemon(player1),
    select_difficulty,
    select_prologemon(player2),
    !.

select_double_mode :-
    assert(mode(double)),
    assert(player1),
    assert(player2),
    select_prologemon(player1),
    select_prologemon(player2),
    !.

select_prologemon(Player) :-
    mode(single) -> (
        ai_player(Player) -> ai_select_prologemon(Player);
        player_select_prologemon(Player)
        );
    player_select_prologemon(Player),
    !.

player_select_prologemon(Player) :- 
    draw_menu(Player),
    read(Input),
    is_valide_prologemon(Input) ->
        init_player(Player, Input);
    player_select_prologemon(Player),
    !.

ai_select_prologemon(Player) :-
    ai(Difficulty),
    other_player(Player, Other_Player),
    selected(Other_Player, Other_Prologemon),
    get_ai_prologemon(Difficulty, Other_Prologemon, Prologemon),
    init_player(Player, Prologemon),
    !.

get_ai_prologemon(easy, Other_Prologemon, Prologemon) :-
    dex_stats(Other_Prologemon, _, _, _, _, Type1),
    dex_stats(Prologemon, _, _, _, _, Type2),
    beat(Type1, Type2),
    !.

get_ai_prologemon(medium, Other_Prologemon, Other_Prologemon).

get_ai_prologemon(hard, Other_Prologemon, Prologemon) :-
    dex_stats(Other_Prologemon, _, _, _, _, Type1),
    dex_stats(Prologemon, _, _, _, _, Type2),
    beat(Type2, Type1),
    !.

beat(fire, grass).
beat(water, fire).
beat(grass, water).

init_player(Player, Prologemon) :- 
    dex_stats(Prologemon, Hp, Atk, Def, Speed, Type),
    assert(selected(Player, Prologemon)),
    assert(health(Player, Hp)),
    assert(stats(Player, Atk, Def, Speed, Type)),
    assert(status(Player, none, 0)),
    assert(made_move(Player, none)),
    !.

select_difficulty :-
    assert(difficulty),
    draw_menu(difficulty),
    read(Input),
    ((Input == 'easy') -> assert(ai(easy));
    (Input == 'medium') -> assert(ai(medium));
    (Input == 'hard') -> assert(ai(hard));
    select_difficulty),
    !.

select_dex_mode :-
    assert(dex),
    draw_menu(dex),
    read(Input),
    is_valide_prologemon(Input) -> select_dex_linker(Input);
    select_dex_mode,
    !.

select_dex_linker(Prologmon) :-
    draw_dex_entry(Prologmon),
    writeln('Type \'back\' to go back to the main menu, or \'name of Prologemon\' to view another Prologemon (No Caps)'),
    read(Input),
    ((Input == 'back') -> select_game_mode;
     (Input == 'lobachu') -> select_dex_linker(lobachu);
     (Input == 'charsine') -> select_dex_linker(charsine);
     (Input == 'mushlator') -> select_dex_linker(mushlator);
     select_dex_linker(Prologmon)),
    !. 

is_valide_prologemon(Input) :- 
    member(Input, ['lobachu', 'mushlator', 'charsine']).

play_game :- 
    check_game_over,
    !.

play_game :- 
    \+ check_game_over,
    make_move(player1),
    make_move(player2),
    battle,
    play_game,
    !.

player_standby(Player) :-
    draw_blank,
    health(player1, H1),
    health(player2, H2),
    status(player1, Status1, _),
    status(player2, Status2, _),
    selected(player1, Prologemon1),
    selected(player2, Prologemon2),
    draw_standby(Player, Prologemon1, H1, Status1, Prologemon2, H2, Status2),
    !.

make_move(Player) :- 
    mode(single) -> (
        ai_player(Player) -> ai_make_move(Player);
        player_make_move(Player)
        );
    player_make_move(Player),
    !.

player_make_move(Player) :-
    player_standby(Player),
    selected(Player, Prolgemon),
    read(Input),
    is_valide_move(Input) -> (move_map(Prolgemon, Input, Move), retract(made_move(Player, _)), assert(made_move(Player, Move)));
    player_make_move(Player),
    !.

ai_make_move(Player) :- 
    selected(Player, Prolgemon),
    random(1, 5, X),
    random_move_map(X, Input),
    move_map(Prolgemon, Input, Move),
    retract(made_move(Player, _)),
    assert(made_move(Player, Move)),
    !.

random_move_map(1, a).
random_move_map(2, b).
random_move_map(3, c).
random_move_map(4, d).

battle :-
    made_move(player1, Move1),
    made_move(player2, Move2),
    stats(player1, _, _, S1, _),
    stats(player2, _, _, S2, _),
    (S1 >= S2 ->
        (play_battle(player1, Move1), sleep(5), play_battle(player2, Move2), sleep(5));
        (play_battle(player2, Move2), sleep(5), play_battle(player1, Move1), sleep(5))),
    !.

play_battle(Player, Move) :-
    draw_blank,
    other_player(Player, OthPlayer),
    draw_battle(Player, Move),
    use_move(Move),
    random(0, 2, ConfChance),
    random(0, 2, ParaChance),
    stats(OthPlayer, _, _, _, P_Type),
    status(Player, S, _),
    move(Move, _, M_Type, _, _, _),
    type(M_Type, P_Type, N),
    (S == sleep ->
	    write('It is fast asleep!'), nl;
     S == confusion ->
         (ConfChance == 1 ->
	    write('It hurt itself in its confusion!'), nl;
            (N == 2 -> 
		writeln('It\'s Super Effective');
    	     N == 0.5 -> 
		writeln('It\'s Not Very Effective');
	     true
            )
         );
     S == paralysis ->
	(ParaChance == 1 ->
	    writeln('It can\'t move!');
            (N == 2 -> 
		writeln('It\'s Super Effective');
    	     N == 0.5 -> 
		writeln('It\'s Not Very Effective');
	     true
            )
         );
     N == 2 -> 
	writeln('It\'s Super Effective');
     N == 0.5 -> 
	writeln('It\'s Not Very Effective');
     true
    ),
    battle_calculations(Player, Move, OthPlayer, ConfChance, ParaChance),
    check_game_over -> play_game;
    true,
    !.





is_valide_move(Move) :-
    member(Move, ['a', 'b', 'c', 'd']),
    !.

other_player(player1, player2).
other_player(player2, player1).

move_map(lobachu, a, 'big_pinch').
move_map(lobachu, b, 'water_snap').
move_map(lobachu, c, 'confuse_wave').
move_map(lobachu, d, 'shell_molt').
move_map(mushlator, a, 'sleep_spore').
move_map(mushlator, b, 'paralyze_dust').
move_map(mushlator, c, 'fungal_launch').
move_map(mushlator, d, 'take_root').
move_map(charsine, a, 'hibernate').
move_map(charsine, b, 'heat_over').
move_map(charsine, c, 'toasty_hug').
move_map(charsine, d, 'fire_dance').

% TODO: check game over condition
check_game_over :-
    health(player1, H1),
    (H1 =< 0),
    assert(win(player2)),
    !.

check_game_over :-
    health(player2, H2),
    (H2 =< 0),
    assert(win(player1)),
    !.

%% TODO: process after game ends
 end_game :-
     win(Player),
     draw_winner(Player),
     draw_end.

 draw_winner(player1) :-
     mode(single) -> write('You have won!'), draw_end_game(player1, player2);
     other_player(player1, OthPlayer),
     draw_end_game(player1, OthPlayer).

 draw_winner(player2) :-
     mode(single) -> write('You have lost!'), draw_end_game(player2, player1);
     other_player(player2, OthPlayer),
     draw_end_game(player2, OthPlayer).

 % ---------------------------------------------------DRAW RELATED CODE BELOW--------------------------------------------------

 draw_end_game(player1, player2) :-
     draw_blank,
     selected(player1, Prologemon1),
     selected(player2, Prologemon2),
	 health(player1, Hp1),
	 health(player2, Hp2),
	 draw_hp(b, Prologemon2, 0, none),
     draw_prologemon(b, Prologemon2, faint),
     draw_hp(a, Prologemon1, Hp1, none),
     draw_prologemon(a, Prologemon1, none),
     write('Player One Wins!'), nl,
     sleep(10).

 draw_end_game(player2, player1) :-
     draw_blank,
     selected(player1, Prologemon1),
     selected(player2, Prologemon2),
	 health(player1, Hp1),
	 health(player2, Hp2),
	 draw_hp(b, Prologemon2, Hp2, none),
     draw_prologemon(b, Prologemon2, none),
     draw_hp(a, Prologemon1, Hp1, none),
     draw_prologemon(a, Prologemon1, faint),
     write('Player Two Wins!'), nl,
     sleep(10).

draw_start :-
    draw_logo,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    write('                                                                                     Type \'start\''),
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    write('                                                                                                                                                            The MTD Company'),
    nl,
    !.

draw_end :-
    draw_logo,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    write('                                                                                     Game Over! Type \'run\' to play again'),
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    write('                                                                                                                                                            The MTD Company'),
    nl,
    !.

draw_menu(Mode) :-
    draw_all_prologemon,
    nl,
    nl,
    nl,
    draw_menu_text(Mode),
    !.

draw_dex(Prologemon) :-
    draw_prologemon(a, Prologemon, none),
    nl,
    nl,
    draw_dex_entry(Prologemon),
    !.


draw_initial(Prologemon1, Prologemon2) :-
    draw_hp(b, Prologemon2),
    nl,
    draw_prologemon(b, Prologemon2, none),
    draw_field(empty),
    draw_hp(a, Prologemon1),
    nl,
    draw_prologemon(a, Prologemon1, none),
    !.

draw_standby(player1, Prologemon1, Hp1, Status1, Prologemon2, Hp2, Status2) :-
    draw_hp(b, Prologemon2, Hp2, Status2),
    nl,
    draw_prologemon(b, Prologemon2, Status2),
    draw_field(empty),
    draw_hp(a, Prologemon1, Hp1, Status1),
    nl,
    draw_prologemon(a, Prologemon1, Status1),
    draw_turn(player1, Prologemon1),
    !.

draw_battle(player1, Move) :-
    selected(player1, Prologemon1),
    selected(player2, Prologemon2),
    health(player1, Hp1),
    health(player2, Hp2),
    status(player1, Status1, _),
    status(player2, Status2, _),
    draw_hp(b, Prologemon2, Hp2, Status2),
    nl,
    draw_prologemon(b, Prologemon2, Status2),
    draw_field(a, Move),
    draw_hp(a, Prologemon1, Hp1, Status1),
    nl,
    draw_prologemon(a, Prologemon1, Status1),
    !.

draw_battle(player2, Move) :-
    selected(player1, Prologemon1),
    selected(player2, Prologemon2),
    health(player1, Hp1),
    health(player2, Hp2),
    status(player1, Status1, _),
    status(player2, Status2, _),
    draw_hp(b, Prologemon2, Hp2, Status2),
    nl,
    draw_prologemon(b, Prologemon2, Status2),
    draw_field(b, Move),
    draw_hp(a, Prologemon1, Hp1, Status1),
    nl,
    draw_prologemon(a, Prologemon1, Status1),
    !.

draw_standby(player2, Prologemon1, Hp1, Status1, Prologemon2, Hp2, Status2) :-
    draw_hp(b, Prologemon2, Hp2, Status2),
    nl,
    draw_prologemon(b, Prologemon2, Status2),
    draw_field(empty),
    draw_hp(a, Prologemon1, Hp1, Status1),
    nl,
    draw_prologemon(a, Prologemon1, Status1),
    draw_turn(player2, Prologemon2),
    !.

draw_turn(player1, Prologemon) :-
    write('Type the \'name\' of the move Player One wishes to use'), nl,
    draw_moves(Prologemon).

draw_turn(player2, Prologemon) :-
    write('Type the \'name\' of the move Player Two wishes to use'), nl,
    draw_moves(Prologemon).

draw_menu_text(select) :-
    write('Type \'single\' for single-player, Type \'double\' for two-player, Type \'dex\' to view the PrologeDex'), nl.

draw_menu_text(player1) :-
    write('Type the \'name of Prologemon\' Player One wishes to use (No Caps)'), nl.

draw_menu_text(player2) :-
    write('Type \'name of Prologemon\' Player Two wishes to use (No Caps)'), nl.

draw_menu_text(difficulty) :-
    write('Type \'easy\', \'medium\', \'hard\' to choose the difficulty of the AI'), nl.

draw_menu_text(dex) :-
    write('Type \'lobachu\', \'mushlator\', \'charsine\' to choose the Prologemon to view'), nl.

draw_dex_entry(lobachu) :-
    nl,
    write('Lobachu, the Big Pincer Prologemon. It uses its claws to rapidly pinch its opponent. It is believed to be biologically immortal'), nl,
    nl,
    write('Type: Water'), nl,
    write('HP: 150'), nl,
    write('Power: 110'), nl,
    write('Defence: 200'), nl,
    write('Speed: 40'), nl,
    nl,
    write('Big Pinch: Deal 40 Normal damage'), nl,
    write('Water Snap: Deal 30 Water damage'), nl,
    write('Tidal Ray: Deals 10 Water damage, Confuses (Confusion lasts 3 turns)'), nl,
    write('Shell Molt: Decreases user\'s Defence, Greatly increase user\'s Speed'), nl,
    nl.

draw_dex_entry(mushlator) :-
    nl,
    write('Mushlator, the Mushroom Missile Prolgemon. It uses its spores to disable threats and launches itself at supersonic speeds to finish them off'), nl,
    nl,
    write('Type: Grass'), nl,
    write('HP: 100'), nl,
    write('Power: 100'), nl,
    write('Defence: 80'), nl,
    write('Speed: 140'), nl,
    nl,
    write('Sleeping Spore: Puts enemy to Sleep (Sleep lasts 1-2 turn)'), nl,
    write('Paralyzing Dust: Paralyzes enemy (Paralysis lasts 4 turns'), nl,
    write('Fungal Launch: Deals 60 Grass damage, Deals 20 damage to yourself'), nl,
    write('Take Root: Lowers user\'s Speed, User heals 60 health'), nl,
    nl.

draw_dex_entry(charsine) :-
    nl,
    write('Charsine, the Charred Paw Prologemon. The symbol on its belly radiates tremendous heat. Anything it hugs will be in for a toasty surprise '), nl,
    nl,
    write('Type: Fire'), nl,
    write('HP: 200'), nl,
    write('Power: 80'), nl,
    write('Defence: 100'), nl,
    write('Speed: 70'), nl,
    nl,
    write('Hibernate: User applies Sleep to itself, User\'s HP is fully healed (Sleep lasts 3 turns)'), nl,
    write('Heat Over: Deals 60 damage next turn, Lowers user\'s Attack'), nl,
    write('Toasty Hug: Deals 30 fire damage'), nl,
    write('Fire Dance: Raises Attack'), nl,
    nl.

draw_hp(a, lobachu) :-
    write('                            Lobachu '), write(150), write('\\'), write(150), nl.

draw_hp(a, mushlator) :-
    write('                            Mushlator '), write(100), write('\\'), write(100), nl.

draw_hp(a, charsine) :-
    write('                            Charsine '), write(200), write('\\'), write(200), nl.

draw_hp(b, lobachu) :-
    write('                                                                Lobachu '),
    write(150), write('\\'), write(150), nl.

draw_hp(b,mushlator) :-
    write('                                                                Mushlator '),
    write(100), write('\\'), write(100), nl.

draw_hp(b, charsine) :-
    write('                                                                Charsine '),
    write(200), write('\\'), write(200), nl.

draw_hp(a, lobachu, Hp, none) :-
    write('                            Lobachu '), write(Hp), write('\\'), write(150), nl.

draw_hp(a, lobachu, Hp, confusion) :-
    write('                        CFN Lobachu '), write(Hp), write('\\'), write(150), nl.

draw_hp(a, lobachu, Hp, sleep) :-
    write('                        SLP Lobachu '), write(Hp), write('\\'), write(150), nl.

draw_hp(a, lobachu, Hp, paralysis) :-
    write('                        PAR Lobachu '), write(Hp), write('\\'), write(150), nl.

draw_hp(a, lobachu, Hp, burn) :-
    write('                        BRN Lobachu '), write(Hp), write('\\'), write(150), nl.

draw_hp(a, mushlator, Hp, none) :-
    write('                            Mushlator '), write(Hp), write('\\'), write(100), nl.

draw_hp(a, mushlator, Hp, confusion) :-
    write('                        CFN Mushlator '), write(Hp), write('\\'), write(100), nl.

draw_hp(a, mushlator, Hp, sleep) :-
    write('                        SLP Mushlator '), write(Hp), write('\\'), write(100), nl.

draw_hp(a, mushlator, Hp, paralysis) :-
    write('                        PAR Mushlator '), write(Hp), write('\\'), write(100), nl.

draw_hp(a, mushlator, Hp, burn) :-
    write('                        BRN Mushlator '), write(Hp), write('\\'), write(100), nl.

draw_hp(a, charsine, Hp, none) :-
    write('                            Charsine '), write(Hp), write('\\'), write(200), nl.

draw_hp(a, charsine, Hp, confusion) :-
    write('                        CFN Charsine '), write(Hp), write('\\'), write(200), nl.

draw_hp(a, charsine, Hp, sleep) :-
    write('                        SLP Charsine '), write(Hp), write('\\'), write(200), nl.

draw_hp(a, charsine, Hp, paralysis) :-
    write('                        PAR Charsine '), write(Hp), write('\\'), write(200), nl.

draw_hp(a, charsine, Hp, burn) :-
    write('                        BRN Charsine '), write(Hp), write('\\'), write(200), nl.

draw_hp(b, lobachu, Hp, none) :-
    write('                                                                Lobachu '),
    write(Hp), write('\\'), write(150), nl.

draw_hp(b, lobachu, Hp, confusion) :-
    write('                                                            CFN Lobachu '),
    write(Hp), write('\\'), write(150), nl.

draw_hp(b, lobachu, Hp, sleep) :-
    write('                                                            SLP Lobachu '),
    write(Hp), write('\\'), write(150), nl.

draw_hp(b, lobachu, Hp, paralysis) :-
    write('                                                            PAR Lobachu '),
    write(Hp), write('\\'), write(150), nl.

draw_hp(b, lobachu, Hp, burn) :-
    write('                                                            BRN Lobachu '),
    write(Hp), write('\\'), write(150), nl.

draw_hp(b, mushlator, Hp, none) :-
    write('                                                                Mushlator '),
    write(Hp), write('\\'), write(100), nl.

draw_hp(b, mushlator, Hp, confusion) :-
    write('                                                            CFN Mushlator '),
    write(Hp), write('\\'), write(100), nl.

draw_hp(b, mushlator, Hp, sleep) :-
    write('                                                            SLP Mushlator '),
    write(Hp), write('\\'), write(100), nl.

draw_hp(b, mushlator, Hp, paralysis) :-
    write('                                                            PAR Mushlator '),
    write(Hp), write('\\'), write(100), nl.

draw_hp(b, mushlator, Hp, burn) :-
    write('                                                            BRN Mushlator '),
    write(Hp), write('\\'), write(100), nl.

draw_hp(b, charsine, Hp, none) :-
    write('                                                                Charsine '),
    write(Hp), write('\\'), write(200), nl.

draw_hp(b, charsine, Hp, confusion) :-
    write('                                                            CFN Charsine '),
    write(Hp), write('\\'), write(200), nl.

draw_hp(b, charsine, Hp, sleep) :-
    write('                                                            SLP Charsine '),
    write(Hp), write('\\'), write(200), nl.

draw_hp(b, charsine, Hp, paralysis) :-
    write('                                                            PAR Charsine '),
    write(Hp), write('\\'), write(200), nl.

draw_hp(b, charsine, Hp, burn) :-
    write('                                                            BRN Charsine '),
    write(Hp), write('\\'), write(200), nl.



draw_blank:-
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl,
    nl.

draw_logo :-
    draw_blank,
    write('     _ _ _ _ _ _ _'), nl,
    write('    |             |                                      |                                                       /'), nl,
    write('    |             |            /                         |                                                      /'), nl,
    write('    |             |          /                           |                                                     /'), nl,
    write('    |             |        /                             |                                                    /'), nl,
    write('    |             |     |/            _ _ _ _ _ _ _      |      _ _ _ _ _ _ _       _ _ _ _ _ _ _       _ _ _ _ _ _ _       _ _ _ _ _ _ _       _ _ _ _ _ _ _       _ _ _ _ _ _ _'), nl,
    write('    |_ _ _ _ _ _ _|     |            |             |     |     |             |     |             |     |             |     |      |      |     |             |     |             |'), nl,
    write('    |                   |            |             |     |     |             |     |             |     |             |     |      |      |     |             |     |             |'), nl,
    write('    |                   |            |             |     |     |             |     |             |     |             |     |      |      |     |             |     |             |'), nl,
    write('    |                   |            |             |     |     |             |     |             |     |_ _ _ _ _ _ _|     |      |      |     |             |     |             |'), nl,
    write('    |                   |            |             |     |     |             |     |             |     |                   |      |      |     |             |     |             |'), nl,
    write('    |                   |            |             |     |     |             |     |             |     |                   |      |      |     |             |     |             |'), nl,
    write('    |                   |            |_ _ _ _ _ _ _|     |     |_ _ _ _ _ _ _|     |_ _ _ _ _ _ _|     |_ _ _ _ _ _ _      |      |      |     |_ _ _ _ _ _ _|     |             |'), nl,
    write('                                                                                                 |'), nl,
    write('                                                                                                 |'), nl,
    write('                                                                                                 |'), nl,
    write('                                                                                                 |'), nl,
    write('                                                                                                 |'), nl,
    write('                                                                                    _ _ _ _ _ _ _|'), nl.

draw_all_prologemon :-
    draw_blank,
    write('                 |   |             /\\'), nl,
    write('|_|              |___|            / o\\                   _         _ '), nl,
    write(' |       \\_/       |             /    \\                 |_|_______|_| '), nl,
    write(' |      /|_|\\      |            / o    \\                |           |'), nl,
    write(' |______|   |______|           /    o   \\               |  0     0  | '), nl,
    write('    ____|   |____             /         o\\              |     .     |'), nl,
    write('    ____|   |____            /   o        \\             |___________| '), nl,
    write('    ____|   |____           /______________\\            _|    |    |_'), nl,
    write('    ____|   |____          /________________\\          |_|  \\ | /  |_|'), nl,
    write('        \\   /                  | =    = |                |    |    | '), nl,
    write('         \\_/                   |        |                |   / \\   | '), nl,
    write('          |                 ___|________|___             |__/___\\__|'), nl,
    write('          |                |   |  |  |  |   |             |_|   |_|'), nl,
    nl,
    write('       Lobachu                  Mushlator                  Charsine'), nl.


draw_prologemon(a, lobachu, Status) :-
    write('                 |   |'), nl,
    write('|_|              |___|'), nl,
    write(' |       \\_/       |'), nl,
    draw_lobachu_status(a, Status),
    write(' |______|   |______|'), nl,
    write('    ____|   |____'), nl,
    write('    ____|   |____'), nl,
    write('    ____|   |____'), nl,
    write('    ____|   |____'), nl,
    write('        \\   /'), nl,
    write('         \\_/'), nl,
    write('          |'), nl,
    write('          |'), nl,
    !.

draw_prologemon(b, lobachu, Status) :-
    write('                                                                                                 |   |'), nl,
    write('                                                                                |_|              |___|'), nl,
    write('                                                                                 |       \\_/       |'), nl,
    draw_lobachu_status(b, Status),
    write('                                                                                 |______|   |______|'), nl,
    write('                                                                                    ____|   |____'), nl,
    write('                                                                                    ____|   |____'), nl,
    write('                                                                                    ____|   |____'), nl,
    write('                                                                                    ____|   |____'), nl,
    write('                                                                                        \\   /'), nl,
    write('                                                                                         \\_/'), nl,
    write('                                                                                          |'), nl,
    write('                                                                                          |'), nl,
    !.

draw_lobachu_status(a, none) :-
    write(' |      /|_|\\      |'), nl.

draw_lobachu_status(a, confusion) :-
    write(' |      /O_o\\      |'), nl.

draw_lobachu_status(a, sleep) :-
    write(' |      /z_z\\      |'), nl.

draw_lobachu_status(a, paralysis) :-
    write(' |      /+_-\\      |'), nl.

draw_lobachu_status(a, burn) :-
    write(' |      />_<\\      |'), nl.

draw_lobachu_status(a, faint) :-
    write(' |      /x_x\\      |'), nl.

draw_lobachu_status(b, none) :-
    write('                                                                                 |      /|_|\\      |'), nl.

draw_lobachu_status(b, confusion) :-
    write('                                                                                 |      /O_o\\      |'), nl.

draw_lobachu_status(b, sleep) :-
    write('                                                                                 |      /z_z\\      |'), nl.

draw_lobachu_status(b, paralysis) :-
    write('                                                                                 |      /+_-\\      |'), nl.

draw_lobachu_status(b, burn) :-
    write('                                                                                 |      />_<\\      |'), nl.

draw_lobachu_status(b, faint) :-
    write('                                                                                 |      /x_x\\      |'), nl.

draw_prologemon(a, mushlator, Status) :-
    write('        /\\'), nl,
    write('       / o\\'), nl,
    write('      /    \\'), nl,
    write('     / o    \\'), nl,
    write('    /    o   \\'), nl,
    write('   /         o\\'), nl,
    write('  /   o        \\'), nl,
    write(' /______________\\'), nl,
    write('/________________\\'), nl,
    draw_mushlator_status(a, Status),
    write('    |        |'), nl,
    write(' ___|________|___'), nl,
    write('|   |  |  |  |   |'), nl,
    !.
draw_prologemon(b, mushlator, Status) :-
    write('                                                                                           /\\'), nl,
    write('                                                                                          / o\\'), nl,
    write('                                                                                         /    \\'), nl,
    write('                                                                                        / o    \\'), nl,
    write('                                                                                       /    o   \\'), nl,
    write('                                                                                      /         o\\'), nl,
    write('                                                                                     /   o        \\'), nl,
    write('                                                                                    /______________\\'), nl,
    write('                                                                                   /________________\\'), nl,
    draw_mushlator_status(b, Status),
    write('                                                                                       |        |'), nl,
    write('                                                                                    ___|________|___'), nl,
    write('                                                                                   |   |  |  |  |   |'), nl,
    !.

draw_mushlator_status(a, none) :-
    write('    | =    = |'), nl.

draw_mushlator_status(a, confusion) :-
    write('    | O    o |'), nl.

draw_mushlator_status(a, sleep) :-
    write('    | Z    Z |'), nl.

draw_mushlator_status(a, paralysis) :-
    write('    | +    - |'), nl.

draw_mushlator_status(a, burn) :-
    write('    | >    < |'), nl.

draw_mushlator_status(a, faint) :-
    write('    | x    x |'), nl.

draw_mushlator_status(b, none) :-
    write('                                                                                       | =    = |'), nl.

draw_mushlator_status(b, confusion) :-
    write('                                                                                       | O    o |'), nl.

draw_mushlator_status(b, sleep) :-
    write('                                                                                       | z    z |'), nl.

draw_mushlator_status(b, paralysis) :-
    write('                                                                                       | +    - |'), nl.

draw_mushlator_status(b, burn) :-
    write('                                                                                       | >    < |'), nl.

draw_mushlator_status(b, faint) :-
    write('                                                                                       | x    x |'), nl.

draw_prologemon(a, charsine, Status) :-
    write('  _         _'), nl,
    write(' |_|_______|_|'), nl,
    write(' |           |'), nl,
    draw_charsine_status(a, Status),
    write(' |     .     |'), nl,
    write(' |___________|'), nl,
    write(' _|    |    |_'), nl,
    write('|_|  \\ | /  |_|'), nl,
    write('  |    |    |'), nl,
    write('  |   / \\   |'), nl,
    write('  |__/___\\__|'), nl,
    write('   |_|   |_|'), nl,
    !.

draw_prologemon(b, charsine, Status) :-
    write('                                                                                        _         _'), nl,
    write('                                                                                       |_|_______|_|'), nl,
    write('                                                                                       |           |'), nl,
    draw_charsine_status(b, Status),
    write('                                                                                       |     .     |'), nl,
    write('                                                                                       |___________|'), nl,
    write('                                                                                       _|    |    |_'), nl,
    write('                                                                                      |_|  \\ | /  |_|'), nl,
    write('                                                                                        |    |    |'), nl,
    write('                                                                                        |   / \\   |'), nl,
    write('                                                                                        |__/___\\__|'), nl,
    write('                                                                                         |_|   |_|'), nl,
    !.

draw_charsine_status(a, none) :-
    write(' |  0     0  |'), nl.

draw_charsine_status(a, confusion) :-
    write(' |  O     o  |'), nl.

draw_charsine_status(a, sleep) :-
    write(' |  z     z  |'), nl.

draw_charsine_status(a, paralysis) :-
    write(' |  +     -  |'), nl.

draw_charsine_status(a, burn) :-
    write(' |  >     <  |'), nl.

draw_charsine_status(a, faint) :-
    write(' |  x     x  |'), nl.

draw_charsine_status(b, none) :-
    write('                                                                                       |  0     0  |'), nl.

draw_charsine_status(b, confusion) :-
    write('                                                                                       |  O     o  |'), nl.

draw_charsine_status(b, sleep) :-
    write('                                                                                       |  z     z  |'), nl.

draw_charsine_status(b, paralysis) :-
    write('                                                                                       |  +     -  |'), nl.

draw_charsine_status(b, burn) :-
    write('                                                                                       |  >     <  |'), nl.

draw_charsine_status(b, faint) :-
    write('                                                                                       |  x     x  |'), nl.

draw_field(empty) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(a, big_pinch) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                |                 |'),nl,
    write('                                |_________________|'),nl,
    write('                                         |'),nl,
    write('                                         |'),nl,
    write('                                         |'),nl,
    write('                                         |'),nl,
    write('                                         |'),nl,
    write('                                         |'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(a, water_snap) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                         |'),nl,
    write('                                         |'),nl,
    write('                                  _ _ _  |  _ _ _ '),nl,
    write('                                      /  | \\'),nl,
    write('                                     /   |  \\'),nl,
    write('                                    /    |   \\'),nl,
    write('                                   /     |    \\'),nl,
    write('                                         |'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(a, confuse_wave) :-
    write(''),nl,
    write(''),nl,
    write('                                           _ _ _'),nl,
    write('                                          |     |'),nl,
    write('                                       _ _|_    |'),nl,
    write('                                      |   |_|_ _|'),nl,
    write('                                   _ _|_    |'),nl,
    write('                                  |   |_|_ _|'),nl,
    write('                                  |     |'),nl,
    write('                                  |_ _ _|'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(a, shell_molt) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('\\ \\ | | - - - - | | / /'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(b, big_pinch) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                                  |                 |'),nl,
    write('                                                  |_________________|'),nl,
    write('                                                           |'),nl,
    write('                                                           |'),nl,
    write('                                                           |'),nl,
    write('                                                           |'),nl,
    write('                                                           |'),nl,
    write('                                                           |'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(b, water_snap) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                                           |'),nl,
    write('                                                           |'),nl,
    write('                                                    _ _ _  |  _ _ _ '),nl,
    write('                                                        /  | \\'),nl,
    write('                                                       /   |  \\'),nl,
    write('                                                      /    |   \\'),nl,
    write('                                                     /     |    \\'),nl,
    write('                                                           |'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(a, confuse_wave) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                                             _ _ _'),nl,
    write('                                                            |     |'),nl,
    write('                                                         _ _|_    |'),nl,
    write('                                                        |   |_|_ _|'),nl,
    write('                                                     _ _|_    |'),nl,
    write('                                                    |   |_|_ _|'),nl,
    write('                                                    |     |'),nl,
    write('                                                    |_ _ _|'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(b, shell_molt) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                                                              \\ \\ | | - - - - | | / /'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.


draw_field(a, sleep_spore) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                .................'),nl,
    write('                                 .................'),nl,
    write('                                  .................'),nl,
    write('                                 .................'),nl,
    write('                                .................'),nl,
    write('                                 .................'),nl,
    write('                                  .................'),nl,
    write('                                 .................'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.


draw_field(a, paralyze_dust) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                ,,,,,,,,,,,,,,,,,'),nl,
    write('                                 ,,,,,,,,,,,,,,,,,'),nl,
    write('                                  ,,,,,,,,,,,,,,,,,'),nl,
    write('                                 ,,,,,,,,,,,,,,,,,'),nl,
    write('                                ,,,,,,,,,,,,,,,,,'),nl,
    write('                                 ,,,,,,,,,,,,,,,,,'),nl,
    write('                                  ,,,,,,,,,,,,,,,,,'),nl,
    write('                                 ,,,,,,,,,,,,,,,,,'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(a, fungal_launch) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                       /\\'),nl,
    write('                                      /  \\'),nl,
    write('                                     /    \\'),nl,
    write('                                    /      \\'),nl,
    write('                                   /        \\'),nl,
    write('                                  /          \\'),nl,
    write('                                 /            \\'),nl,
    write('                                /              \\'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(a, take_root) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                   |'),nl,
    write('                                  /|'),nl,
    write('                                 / |\\'),nl,
    write('                                /  | \\'),nl,
    write('                                  /|  \\'),nl,
    write('                                 / |\\  \\'),nl,
    write('                                / /| \\'),nl,
    write('                                 / |  '),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(b, sleep_spore) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                                                .................'),nl,
    write('                                                                 .................'),nl,
    write('                                                                .................'),nl,
    write('                                                               .................'),nl,
    write('                                                                .................'),nl,
    write('                                                                 .................'),nl,
    write('                                                                .................'),nl,
    write('                                                               .................'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(b, paralyze_dust) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                                                ,,,,,,,,,,,,,,,,,'),nl,
    write('                                                                 ,,,,,,,,,,,,,,,,,'),nl,
    write('                                                                ,,,,,,,,,,,,,,,,,'),nl,
    write('                                                               ,,,,,,,,,,,,,,,,,'),nl,
    write('                                                                ,,,,,,,,,,,,,,,,,'),nl,
    write('                                                                 ,,,,,,,,,,,,,,,,,'),nl,
    write('                                                                ,,,,,,,,,,,,,,,,,'),nl,
    write('                                                               ,,,,,,,,,,,,,,,,,'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(b, fungal_launch) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                                                      /\\'),nl,
    write('                                                                     /  \\'),nl,
    write('                                                                    /    \\'),nl,
    write('                                                                   /      \\'),nl,
    write('                                                                  /        \\'),nl,
    write('                                                                 /          \\'),nl,
    write('                                                                /            \\'),nl,
    write('                                                               /              \\'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(b, take_root) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                                                   |'),nl,
    write('                                                                  /|'),nl,
    write('                                                                 / |\\'),nl,
    write('                                                                /  | \\'),nl,
    write('                                                                  /|  \\'),nl,
    write('                                                                 / |\\  \\'),nl,
    write('                                                                / /| \\'),nl,
    write('                                                                 / |  '),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(a, hibernate) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('zzzzzzzzzzzz'),nl,
    write('          z'),nl,
    write('        z'),nl,
    write('      z'),nl,
    write('    z'),nl,
    write('   z'),nl,
    write(' z'),nl,
    write('zzzzzzzzzzzz'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(a, heat_over) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,

    write('                                    |            |            |'),nl,
    write('                                |   |   |    |   |   |    |   |   |'),nl,
    write('                                |   |   |    |   |   |    |   |   |'),nl,
    write('                                    |            |            |'),nl,
    write('                                   / \\         /  \\         /  \\'),nl,
    write('                                  /   \\       /    \\       /    \\'),nl,
    write('                                 /     \\     /      \\     /      \\'),nl,
    write('                                /       \\   /        \\   /        \\'),nl,

    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(a, toasty_hug) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,

    write('                                    |'),nl,
    write('                                |   |   |'),nl,
    write('                                |   |   |'),nl,
    write('                                    |'),nl,
    write('                                   / \\'),nl,
    write('                                  /   \\'),nl,
    write('                                 /     \\'),nl,
    write('                                /       \\'),nl,

    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.


draw_field(a, fire_dance) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('  |     |     |'),nl,
    write('  |     |     |'),nl,
    write('  |     |     |'),nl,
    write('  |     |     |'),nl,
    write('  |     |     |'),nl,
    write('__|__ __|__ __|__'),nl,
    write('  |     |     |'),nl,
    write('  |     |     |'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(b, hibernate) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                                                                       zzzzzzzzzzzz'),nl,
    write('                                                                                                 z'),nl,
    write('                                                                                               z'),nl,
    write('                                                                                             z'),nl,
    write('                                                                                           z'),nl,
    write('                                                                                          z'),nl,
    write('                                                                                        z'),nl,
    write('                                                                                       zzzzzzzzzzzz'),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(b, heat_over) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,

    write('                                         |            |            |'),nl,
    write('                                     |   |   |    |   |   |    |   |   |'),nl,
    write('                                     |   |   |    |   |   |    |   |   |'),nl,
    write('                                         |            |            |'),nl,
    write('                                        / \\         /  \\         /  \\'),nl,
    write('                                       /   \\       /    \\       /    \\'),nl,
    write('                                      /     \\     /      \\     /      \\'),nl,
    write('                                     /       \\   /        \\   /        \\'),nl,

    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(b, toasty_hug) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,

    write('                                                                    |'),nl,
    write('                                                                |   |   |'),nl,
    write('                                                                |   |   |'),nl,
    write('                                                                    |'),nl,
    write('                                                                   / \\'),nl,
    write('                                                                  /   \\'),nl,
    write('                                                                 /     \\'),nl,
    write('                                                                /       \\'),nl,

    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.

draw_field(b, fire_dance) :-
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl,
    write('                                                                                       |     |     |'),nl,
    write('                                                                                       |     |     |'),nl,
    write('                                                                                       |     |     |'),nl,
    write('                                                                                       |     |     |'),nl,
    write('                                                                                       |     |     |'),nl,
    write('                                                                                     __|__ __|__ __|__'),nl,
    write('                                                                                       |     |     |'),nl,
    write('                                                                                       |     |     |'),nl,

    write(''),nl,
    write(''),nl,
    write(''),nl,
    write(''),nl.


draw_moves(lobachu) :-
    write('a. Big Pinch'), nl,
    write('b. Water Snap'), nl,
    write('c. Confuse Wave'), nl,
    write('d. Shell Molt'), nl.

draw_moves(mushlator) :-
    write('a. Sleep Spore'), nl,
    write('b. Paralyze Dust'), nl,
    write('c. Fungal Launch'), nl,
    write('d. Take Root'), nl.

draw_moves(charsine) :-
    write('a. Hibernate'), nl,
    write('b. Heat Over'), nl,
    write('c. Toasty Hug'), nl,
    write('d. Fire Dance'), nl.

use_move(big_pinch) :-
    write('Lobachu used Big Pinch!'), nl.

use_move(water_snap) :-
    write('Lobachu used Water Snap!'), nl.

use_move(confuse_wave) :-
    write('Lobachu used Confuse Wave!'), nl.

use_move(shell_molt) :-
    write('Lobachu used Shell Molt!'), nl,
    write('Lobachu\'s Defence decreased!'), nl,
    write('Lobachu\'s Speed greatly increased!'), nl.

use_move(sleep_spore) :-
    write('Mushlator used Sleep Spore!'), nl.

use_move(paralyze_dust) :-
    write('Mushlator used Paralyze Dust!'), nl.

use_move(fungal_launch) :-
    write('Mushlator used Fungal Launch!'), nl,
    write('Mushlator is damaged by recoil!'), nl.

use_move(take_root) :-
    write('Mushlator used Take Root!'), nl,
    write('Mushlator\'s Speed decreased!'), nl,
    write('Mushlator heals itself!'), nl.

use_move(hibernate) :-
    write('Charsine used Hibernate!'), nl.

use_move(heat_over) :-
    write('Charsine used Heat Over!'), nl,
    write('Charsine\'s Attack decreased!'), nl.

use_move(toasty_hug) :-
    write('Charsine used Toasty Hug!'), nl.

use_move(fire_dance) :-
    write('Charsine used Fire Dance!'), nl,
    write('Charsine\'s Attack increased!'), nl.

%------------------------------------------------BATTLE CALCULATIONS----------------------------------------------------
%pokemon dex stats (hp, atk, def, speed, type).
dex_stats(charsine, 200, 80, 100, 70, fire).
dex_stats(lobachu, 150, 110, 200, 40, water).
dex_stats(mushlator, 100, 100, 80, 140, grass).

%damage dealt & status turns left
damage(0).
left(0).

%moves(name, power, type, status effect, status turns, special additions).
move('big_pinch', 40, normal, none, 0, nothing).
move('water_snap', 30, water, none, 0, nothing).
move('confuse_wave', 10, water, confusion, X, nothing) :-
    random(2, 4, X).
move('shell_molt', 0, normal, none, 0, special).
move('sleep_spore', 0, normal, sleep, X, nothing) :-
    random(1, 3, X).
move('paralyze_dust', 0, normal, paralysis, 4, nothing).
move('fungal_launch', 60, grass, none, 0, special).
move('take_root', 0, normal, none, 0, special).
move('hibernate', 0, normal, none, 0, special).
move('heat_over', 60, fire, none, 0, special).
move('toasty_hug', 30, fire, none, 0, nothing).
move('fire_dance', 0, normal, none, 0, special).

%special effects of moves (name, player1 and player2).
sp_move('shell_molt', Player1, Player2) :-
    stats(Player1, X1, X2, X3, T1),
    (X2 < 40 ->
	    Modified_defense is 20;
    	Modified_defense is X2 - 20),
    (X3 > 160 ->
        Modified_speed is 200;
        Modified_speed is X3 + 40),
    retract(stats(Player1, _, _, _, _)),
    assert(stats(Player1, X1, Modified_defense, Modified_speed, T1)).

sp_move('fungal_launch', Player1, Player2) :-
    health(Player1, HP1),
    Modified_health is HP1 - 20,
    retract(health(Player1, HP1)),
    assert(health(Player1, Modified_health)).

sp_move('take_root', Player1, Player2) :-
    stats(Player1, X1, X2, X3, T1),
    health(Player1, HP1),
    (X3 < 40 ->
	Modified_speed is 20;
    Modified_speed is X3 - 20),

    (HP1 < 40 ->
	Modified_health is HP1 + 60;
    Modified_health is 100),

    retract(stats(Player1, _, _, _, _)),
    assert(stats(Player1, X1, X2, Modified_speed, T1)),
    retract(health(Player1, _)),
    assert(health(Player1, Modified_health)).

sp_move('hibernate', Player1, Player2) :-
    health(Player1, HP1),
    status(Player1, S, Turns),
    selected(Player1, P1),
    dex_stats(P1, Y1, Y2, Y3, Y4, Type),
    random(1, 4, RandomNumber),
    retract(health(Player1, HP1)),
    assert(health(Player1, Y1)),
    retract(status(Player1, S, Turns)),
    assert(status(Player1, sleep, RandomNumber)).

sp_move('fire_dance', Player1, Player2) :-
    stats(Player1, X1, X2, X3, T1),
    (X1 > 170 ->
            Modified_attack is 200;
            Modified_attack is X1 + 30),
    retract(stats(Player1, _, _, _, _)),
    assert(stats(Player1, Modified_attack, X2, X3, T1)).

sp_move('heat_over', Player1, Player2) :-
    stats(Player1, X1, X2, X3, T1),
    (X1 < 40 ->
	    Modified_attack is 20;
        Modified_attack is X1 - 20),
    retract(stats(Player1, _, _, _, _)),
    assert(stats(Player1, Modified_attack, X2, X3, T1)).

%typing calculations
type(water, fire, 2).
type(fire, grass, 2).
type(grass, water, 2).
type(fire, water, 0.5).
type(grass, fire, 0.5).
type(water, grass, 0.5).
type(normal, _, 1).
type(_, normal, 1).

damage_multiplier(M, T, X, A, D, Power, Crit_number) :-
	(T == X ->
		STAB is 1.5;
		STAB is 1
	),
	(Crit_number == 10 ->
		CRIT is 1.5;
		CRIT is 1
	),
	random(0.85, 1.00, RandomNumber),
	Modifier is STAB * M * CRIT * RandomNumber,
	(Power == 0 ->
		Pre_Damage is 0;
		Pre_Damage is ((22 * Power * A/D)/50 + 2) * Modifier
	),
	Damage is floor(Pre_Damage),
   	retract(damage(_)),
	assert(damage(Damage)).

%left calculations
left_calculations(Time1) :-
	(Time1 > 0 ->
		Left is Time1 - 1;
		Left is 0),
	retract(left(_)),
	assert(left(Left)).

%battle
battle_calculations(Player1, Name, Player2, ConfChance, ParaChance) :-
    %initiliazation
	stats(Player1, X1, X2, X3, X4),
	stats(Player2, Y1, Y2, Y3, X5),
	status(Player1, S1, Time1),
	status(Player2, S2, Time2),
	health(Player1, Hp1),
	health(Player2, Hp2),
	random(1, 11, Crit_number),
	% damage calculations
	move(Name, Power, T1, S, Turn, SP),
	type(V4, V5, Multiplier),
	damage_multiplier(Multiplier, T1, X4, X1, Y2, Power, Crit_number),
        damage(Damage),
        RH is Hp2 - Damage,
	left_calculations(Time1),
	left(Left),
	(Crit_number == 10 ->
			(Power > 0 ->
				Crit_ln is 0;
				Crit_ln is 1
			);
			Crit_ln is 1;
			true
	),
    % what to do depending on status

	(S1 == none ->
    		retract(health(Player2, _)),
                assert(health(Player2, RH)),
		(Crit_ln == 0 ->
			writeln('Critical Hit!');
			true
		),
                (S2 == none ->
                   retract(status(Player2, _, _)),
                   assert(status(Player2, S, Turn));
                   true
            ),
            (SP == special ->
                   sp_move(Name, Player1, Player2);
                   true
            )
        ;
    	S1 == confusion ->
    	    (Left == 0 ->
    	        retract(status(Player1, _, _)),
    	        assert(status(Player1, none, 0));
    	        retract(status(Player1, _, _)),
               	assert(status(Player1, S1, Left))
    	    ),
    	    (ConfChance == 0 ->
    	            retract(health(Player2, _)),
                    assert(health(Player2, RH)),
		    (Crit_ln == 0 ->
			writeln('Critical Hit!');
			true
		    ),
                    (S2 == none ->
                           retract(status(Player2, _, _)),
                           assert(status(Player2, S, Turn));
                           true
                    ),
                    (SP == special ->
                           sp_move(Name, Player1, Player2);
                           true
                    );
		    Rec is Hp1 - 20,
                    retract(health(Player1, _)),
                    assert(health(Player1, Rec))
            );
        S1 == paralysis ->
        	    (Left == 0 ->
        	        retract(status(Player1, _, _)),
        	        assert(status(Player1, none, 0));
        	        retract(status(Player1, _, _)),
                        assert(status(Player1, S1, Left))
        	    ),
        	    (ParaChance == 0 ->
        	        retract(health(player2, _)),
                        assert(health(player2, RH)),
			(Crit_ln == 0 ->
			 writeln('Critical Hit!');
			 true
		        ),
                    (S2 == none ->
                           retract(status(Player2, _, _)),
                           assert(status(Player2, S, Turn));
                           true
                    ),
                    (SP == special ->
                           sp_move(Name, Player1, Player2);
                           true
                    );
                    true
                )
        ;
        S1 == sleep ->
                (Left == 0 ->
            	    retract(status(Player1, _, _)),
            	    assert(status(Player1, none, 0))
            	    ;
            	    retract(status(Player1, _, _)),
                    assert(status(Player1, S1, Left))
            	)
        ),
	!.
    

% Cleans up all the asserted predicates.
clean :-
    clean_select,
    clean_player1,
    clean_player2,
    clean_selected,
    clean_ai,
    clean_difficulty,
    clean_dex,
    clean_health,
    clean_stats,
    clean_status,
    clean_made_move,
    clean_mode,
    clean_ai_player,
    clean_win,
    !.

clean_select :- repeat, (retract( select ) -> false; true).
clean_player1 :- repeat, (retract( player1 ) -> false; true).
clean_player2 :- repeat, (retract( player2 ) -> false; true).
clean_selected :- repeat, (retract( selected(_, _) ) -> false; true).
clean_ai :- repeat, (retract( ai(_) ) -> false; true).
clean_difficulty :- repeat, (retract( difficulty ) -> false; true).
clean_dex :- repeat, (retract( dex ) -> false; true).
clean_health :- repeat, (retract( health(_, _) ) -> false; true).
clean_stats :- repeat, (retract( stats(_, _, _, _, _) ) -> false; true).
clean_status :- repeat, (retract( status(_, _, _) ) -> false; true).
clean_made_move :- repeat, (retract( made_move(_, _) ) -> false; true).
clean_mode :- repeat, (retract( mode(_) ) -> false; true).
clean_ai_player :- repeat, (retract( ai_player(_) ) -> false; true).
clean_win :- repeat, (retract( win(_) ) -> false; true).
    