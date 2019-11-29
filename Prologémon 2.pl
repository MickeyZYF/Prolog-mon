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
    write("                                                                                     Type \"start\""),
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
    write("                                                                                                                                                            The MTD Company"),
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

draw_standby(player2, Prologemon1, Hp1, Status1, Prologemon2, Hp2, Status2) :-
    draw_hp(b, Prologemon2, Hp2, Status2),
    nl,
    draw_prologemon(b, Prologemon2, Status2),
    draw_field(empty),
    draw_hp(a, Prologemon1, Hp1, Status1),
    nl,
    draw_prologemon(a, Prologemon1, Status1),
    draw_turn(player2, Player2),
    !.

draw_move_test_one :-
    draw_hp(b, lobachu),
    nl,
    draw_prologemon(b, lobachu, none),
    draw_field(b, heat_over),
    draw_hp(a, lobachu),
    nl,
    draw_prologemon(a, lobachu, none),
    !.

draw_move_test_two :-
    draw_hp(b, lobachu),
    nl,
    draw_prologemon(b, lobachu, none),
    draw_field(a, heat_over),
    draw_hp(a, lobachu),
    nl,
    draw_prologemon(a, lobachu, none),
    !.

draw_move_test :-
    draw_move_test_one,
    sleep(5),
    draw_move_test_two.

draw_turn(player1, Prologemon) :-
    write("Type the \"name\" of the move Player One wishes to use"), nl,
    draw_moves(Prologemon).

draw_turn(player2, Prologemon) :-
    write("Type the \"name\" of the move Player Two wishes to use"), nl,
    draw_moves(Prologemon).

draw_menu_text(select) :-
    write("Type \"Single\" for single-player, Type \"Double\" for two-player").

draw_menu_text(player1) :-
    write("Type the \"name of the Prologemon\" Player One wishes to use").

draw_menu_text(player2) :-
    write("Type \"name of the Prologemon\" Player Two wishes to use").

draw_menu_text(difficulty) :-
    write("Type \"Easy\", \"Medium\", \"Hard\" to choose the difficulty of the AI").

draw_dex_entry(lobachu) :-
    write("Lobachu, the Big Pincer Prologemon. It uses its claws to rapidly pinch its opponent. It is believed to be biologically immortal"), nl,
    nl,
    write("Type: Water"), nl,
    write("HP: 150"), nl,
    write("Power: 110"), nl,
    write("Defence: 200"), nl,
    write("Speed: 40"), nl,
    nl,
    write("Big Pinch: Deal 40 Normal damage"), nl,
    write("Water Snap: Deal 30 Water damage"), nl,
    write("Tidal Ray: Deals 10 Water damage, Confuses (Confusion lasts 3 turns)"), nl,
    write("Shell Molt: Decreases defence, greatly increase speed"), nl.

draw_dex_entry(mushlator) :-
    write("Mushalator, the Mushroom Missile Prolgemon. It uses its spores to disable threats and launches itself at supersonic speed to finish them off"), nl,
    nl,
    write("Type: Grass"), nl,
    write("HP: 100"), nl,
    write("Power: 100"), nl,
    write("Defence: 70"), nl,
    write("Speed: 140"), nl,
    nl,
    write("Sleeping Spore: Puts enemy to sleep (Sleep lasts 1-2 turn)"), nl,
    write("Paralyzing Dust: Paralyzes enemy (Paralysis lasts 4 turns"), nl,
    write("Fungal Launch: Deals 60 Grass damage, deals 20 damage to yourself"), nl,
    write("Take Root: Lowers speed, heals 30 health every turn (Lasts 3 turns)"), nl.

draw_dex_entry(charsine) :-
    write("Charsine, the Charred Paw Prologemon. The symbol on its belly radiates tremendous heat. Anything it hugs will get be in for a toasty surprise "), nl,
    nl,
    write("Type: Fire"), nl,
    write("HP: 200"), nl,
    write("Power: 80"), nl,
    write("Defence: 100"), nl,
    write("Speed: 70"), nl,
    nl,
    write("Hibernate: User applies Sleep to itself, heal to full (Sleep lasts 3 turns) "), nl,
    write("Heat Over: Gather up energy for a turn, deals 60 damage next turn"), nl,
    write("Toasty Hug: Deal 10 damage, Burns (Burn Lasts 4 turns)"), nl,
    write("Fire Dance: Raises attack"), nl.

draw_hp(a, lobachu) :-
    write("                            Lobachu "), write(150), write("\\"), write(150), nl.

draw_hp(a, mushlator) :-
    write("                            Mushlator "), write(100), write("\\"), write(100), nl.

draw_hp(a, charsine) :-
    write("                            Charsine "), write(200), write("\\"), write(200), nl.

draw_hp(b, lobachu) :-
    write("                                                                Lobachu "),
    write(150), write("\\"), write(150), nl.

draw_hp(b,mushlator) :-
    write("                                                                Mushlator "),
    write(100), write("\\"), write(100), nl.

draw_hp(b, charsine) :-
    write("                                                                Charsine "),
    write(200), write("\\"), write(200), nl.

draw_hp(a, lobachu, Hp, none) :-
    write("                            Lobachu "), write(Hp), write("\\"), write(150), nl.

draw_hp(a, lobachu, Hp, confusion) :-
    write("                        CFN Lobachu "), write(Hp), write("\\"), write(150), nl.

draw_hp(a, lobachu, Hp, sleep) :-
    write("                        SLP Lobachu "), write(Hp), write("\\"), write(150), nl.

draw_hp(a, lobachu, Hp, paralysis) :-
    write("                        PAR Lobachu "), write(Hp), write("\\"), write(150), nl.

draw_hp(a, lobachu, Hp, burn) :-
    write("                        BRN Lobachu "), write(Hp), write("\\"), write(150), nl.

draw_hp(a, mushlator, Hp, none) :-
    write("                            Mushlator "), write(Hp), write("\\"), write(100), nl.

draw_hp(a, mushlator, Hp, confusion) :-
    write("                        CFN Mushlator "), write(Hp), write("\\"), write(100), nl.

draw_hp(a, mushlator, Hp, sleep) :-
    write("                        SLP Mushlator "), write(Hp), write("\\"), write(100), nl.

draw_hp(a, mushlator, Hp, paralysis) :-
    write("                        PAR Mushlator "), write(Hp), write("\\"), write(100), nl.

draw_hp(a, mushlator, Hp, burn) :-
    write("                        BRN Mushlator "), write(Hp), write("\\"), write(100), nl.

draw_hp(a, charsine, Hp, none) :-
    write("                            Charsine "), write(Hp), write("\\"), write(200), nl.

draw_hp(a, charsine, Hp, confusion) :-
    write("                        CFN Charsine "), write(Hp), write("\\"), write(200), nl.

draw_hp(a, charsine, Hp, sleep) :-
    write("                        SLP Charsine "), write(Hp), write("\\"), write(200), nl.

draw_hp(a, charsine, Hp, paralysis) :-
    write("                        PAR Charsine "), write(Hp), write("\\"), write(200), nl.

draw_hp(a, charsine, Hp, burn) :-
    write("                        BRN Charsine "), write(Hp), write("\\"), write(200), nl.

draw_hp(b, lobachu, Hp, none) :-
    write("                                                                Lobachu "),
    write(Hp), write("\\"), write(150), nl.

draw_hp(b, lobachu, Hp, confusion) :-
    write("                                                            CFN Lobachu "),
    write(Hp), write("\\"), write(150), nl.

draw_hp(b, lobachu, Hp, sleep) :-
    write("                                                            SLP Lobachu "),
    write(Hp), write("\\"), write(150), nl.

draw_hp(b, lobachu, Hp, paralysis) :-
    write("                                                            PAR Lobachu "),
    write(Hp), write("\\"), write(150), nl.

draw_hp(b, lobachu, Hp, burn) :-
    write("                                                            BRN Lobachu "),
    write(Hp), write("\\"), write(150), nl.

draw_hp(b, mushlator, Hp, none) :-
    write("                                                                Mushlator "),
    write(Hp), write("\\"), write(100), nl.

draw_hp(b, mushlator, Hp, confusion) :-
    write("                                                            CFN Mushlator "),
    write(Hp), write("\\"), write(100), nl.

draw_hp(b, mushlator, Hp, sleep) :-
    write("                                                            SLP Mushlator "),
    write(Hp), write("\\"), write(100), nl.

draw_hp(b, mushlator, Hp, paralysis) :-
    write("                                                            PAR Mushlator "),
    write(Hp), write("\\"), write(100), nl.

draw_hp(b, mushlator, Hp, burn) :-
    write("                                                            BRN Mushlator "),
    write(Hp), write("\\"), write(100), nl.

draw_hp(b, charsine, Hp, none) :-
    write("                                                                Charsine "),
    write(Hp), write("\\"), write(200), nl.

draw_hp(b, charsine, Hp, confusion) :-
    write("                                                            CFN Charsine "),
    write(Hp), write("\\"), write(200), nl.

draw_hp(b, charsine, Hp, sleep) :-
    write("                                                            SLP Charsine "),
    write(Hp), write("\\"), write(200), nl.

draw_hp(b, charsine, Hp, paralysis) :-
    write("                                                            PAR Charsine "),
    write(Hp), write("\\"), write(200), nl.

draw_hp(b, charsine, Hp, burn) :-
    write("                                                            BRN Charsine "),
    write(Hp), write("\\"), write(200), nl.

draw_logo :-
    write("     _ _ _ _ _ _ _"), nl,
    write("    |             |                                      |                                                       /"), nl,
    write("    |             |            /                         |                                                      /"), nl,
    write("    |             |          /                           |                                                     /"), nl,
    write("    |             |        /                             |                                                    /"), nl,
    write("    |             |     |/            _ _ _ _ _ _ _      |      _ _ _ _ _ _ _       _ _ _ _ _ _ _       _ _ _ _ _ _ _       _ _ _ _ _ _ _       _ _ _ _ _ _ _       _ _ _ _ _ _ _"), nl,
    write("    |_ _ _ _ _ _ _|     |            |             |     |     |             |     |             |     |             |     |      |      |     |             |     |             |"), nl,
    write("    |                   |            |             |     |     |             |     |             |     |             |     |      |      |     |             |     |             |"), nl,
    write("    |                   |            |             |     |     |             |     |             |     |             |     |      |      |     |             |     |             |"), nl,
    write("    |                   |            |             |     |     |             |     |             |     |_ _ _ _ _ _ _|     |      |      |     |             |     |             |"), nl,
    write("    |                   |            |             |     |     |             |     |             |     |                   |      |      |     |             |     |             |"), nl,
    write("    |                   |            |             |     |     |             |     |             |     |                   |      |      |     |             |     |             |"), nl,
    write("    |                   |            |_ _ _ _ _ _ _|     |     |_ _ _ _ _ _ _|     |_ _ _ _ _ _ _|     |_ _ _ _ _ _ _      |      |      |     |_ _ _ _ _ _ _|     |             |"), nl,
    write("                                                                                                 |"), nl,
    write("                                                                                                 |"), nl,
    write("                                                                                                 |"), nl,
    write("                                                                                                 |"), nl,
    write("                                                                                                 |"), nl,
    write("                                                                                    _ _ _ _ _ _ _|"), nl.

draw_all_prologemon :-
    write("                 |   |             /\\"), nl,
    write("|_|              |___|            / o\\                   _         _ "), nl,
    write(" |       \\_/       |             /    \\                 |_|_______|_| "), nl,
    write(" |      /|_|\\      |            / o    \\                |           |"), nl,
    write(" |______|   |______|           /    o   \\               |  0     0  | "), nl,
    write("    ____|   |____             /         o\\              |     .     |"), nl,
    write("    ____|   |____            /   o        \\             |___________| "), nl,
    write("    ____|   |____           /______________\\            _|    |    |_"), nl,
    write("    ____|   |____          /________________\\          |_|  \\ | /  |_|"), nl,
    write("        \\   /                  | =    = |                |    |    | "), nl,
    write("         \\_/                   |        |                |   / \\   | "), nl,
    write("          |                 ___|________|___             |__/___\\__|"), nl,
    write("          |                |   |  |  |  |   |             |_|   |_|"), nl,
    nl,
    write("       Lobachu                  Mushlator                  Charsine"), nl.






draw_prologemon(a, lobachu, Status) :-
    write("                 |   |"), nl,
    write("|_|              |___|"), nl,
    write(" |       \\_/       |"), nl,
    draw_lobachu_status(a, Status),
    write(" |______|   |______|"), nl,
    write("    ____|   |____"), nl,
    write("    ____|   |____"), nl,
    write("    ____|   |____"), nl,
    write("    ____|   |____"), nl,
    write("        \\   /"), nl,
    write("         \\_/"), nl,
    write("          |"), nl,
    write("          |"), nl,
    !.

draw_prologemon(b, lobachu, Status) :-
    write("                                                                                                 |   |"), nl,
    write("                                                                                |_|              |___|"), nl,
    write("                                                                                 |       \\_/       |"), nl,
    draw_lobachu_status(b, Status),
    write("                                                                                 |______|   |______|"), nl,
    write("                                                                                    ____|   |____"), nl,
    write("                                                                                    ____|   |____"), nl,
    write("                                                                                    ____|   |____"), nl,
    write("                                                                                    ____|   |____"), nl,
    write("                                                                                        \\   /"), nl,
    write("                                                                                         \\_/"), nl,
    write("                                                                                          |"), nl,
    write("                                                                                          |"), nl,
    !.

draw_lobachu_status(a, none) :-
    write(" |      /|_|\\      |"), nl.

draw_lobachu_status(a, confusion) :-
    write(" |      /O_o\\      |"), nl.

draw_lobachu_status(a, sleep) :-
    write(" |      /z_z\\      |"), nl.

draw_lobachu_status(a, paralysis) :-
    write(" |      /+_-\\      |"), nl.

draw_lobachu_status(a, burn) :-
    write(" |      />_<\\      |"), nl.

draw_lobachu_status(a, faint) :-
    write(" |      /x_x\\      |"), nl.

draw_lobachu_status(b, none) :-
    write("                                                                                 |      /|_|\\      |"), nl.

draw_lobachu_status(b, confusion) :-
    write("                                                                                 |      /O_o\\      |"), nl.

draw_lobachu_status(b, sleep) :-
    write("                                                                                 |      /z_z\\      |"), nl.

draw_lobachu_status(b, paralysis) :-
    write("                                                                                 |      /+_-\\      |"), nl.

draw_lobachu_status(b, burn) :-
    write("                                                                                 |      />_<\\      |"), nl.

draw_lobachu_status(b, faint) :-
    write("                                                                                 |      /x_x\\      |"), nl.

draw_prologemon(a, mushlator, Status) :-
    write("        /\\"), nl,
    write("       / o\\"), nl,
    write("      /    \\"), nl,
    write("     / o    \\"), nl,
    write("    /    o   \\"), nl,
    write("   /         o\\"), nl,
    write("  /   o        \\"), nl,
    write(" /______________\\"), nl,
    write("/________________\\"), nl,
    draw_mushlator_status(a, Status),
    write("    |        |"), nl,
    write(" ___|________|___"), nl,
    write("|   |  |  |  |   |"), nl,
    !.
draw_prologemon(b, mushlator, Status) :-
    write("                                                                                           /\\"), nl,
    write("                                                                                          / o\\"), nl,
    write("                                                                                         /    \\"), nl,
    write("                                                                                        / o    \\"), nl,
    write("                                                                                       /    o   \\"), nl,
    write("                                                                                      /         o\\"), nl,
    write("                                                                                     /   o        \\"), nl,
    write("                                                                                    /______________\\"), nl,
    write("                                                                                   /________________\\"), nl,
    draw_mushlator_status(b, Status),
    write("                                                                                       |        |"), nl,
    write("                                                                                    ___|________|___"), nl,
    write("                                                                                   |   |  |  |  |   |"), nl,
    !.

draw_mushlator_status(a, none) :-
    write("    | =    = |"), nl.

draw_mushlator_status(a, confusion) :-
    write("    | O    o |"), nl.

draw_mushlator_status(a, sleep) :-
    write("    | Z    Z |"), nl.

draw_mushlator_status(a, paralysis) :-
    write("    | +    - |"), nl.

draw_mushlator_status(a, burn) :-
    write("    | >    < |"), nl.

draw_mushlator_status(a, faint) :-
    write("    | x    x |"), nl.

draw_mushlator_status(b, none) :-
    write("                                                                                       | =    = |"), nl.

draw_mushlator_status(b, confusion) :-
    write("                                                                                       | O    o |"), nl.

draw_mushlator_status(b, sleep) :-
    write("                                                                                       | z    z |"), nl.

draw_mushlator_status(b, paralysis) :-
    write("                                                                                       | +    - |"), nl.

draw_mushlator_status(b, burn) :-
    write("                                                                                       | >    < |"), nl.

draw_mushlator_status(b, faint) :-
    write("                                                                                       | x    x |"), nl.

draw_prologemon(a, charsine, Status) :-
    write("  _         _"), nl,
    write(" |_|_______|_|"), nl,
    write(" |           |"), nl,
    draw_charsine_status(a, Status),
    write(" |     .     |"), nl,
    write(" |___________|"), nl,
    write(" _|    |    |_"), nl,
    write("|_|  \\ | /  |_|"), nl,
    write("  |    |    |"), nl,
    write("  |   / \\   |"), nl,
    write("  |__/___\\__|"), nl,
    write("   |_|   |_|"), nl,
    !.

draw_prologemon(b, charsine, Status) :-
    write("                                                                                        _         _"), nl,
    write("                                                                                       |_|_______|_|"), nl,
    write("                                                                                       |           |"), nl,
    draw_charsine_status(b, Status),
    write("                                                                                       |     .     |"), nl,
    write("                                                                                       |___________|"), nl,
    write("                                                                                       _|    |    |_"), nl,
    write("                                                                                      |_|  \\ | /  |_|"), nl,
    write("                                                                                        |    |    |"), nl,
    write("                                                                                        |   / \\   |"), nl,
    write("                                                                                        |__/___\\__|"), nl,
    write("                                                                                         |_|   |_|"), nl,
    !.

draw_charsine_status(a, none) :-
    write(" |  0     0  |"), nl.

draw_charsine_status(a, confusion) :-
    write(" |  O     o  |"), nl.

draw_charsine_status(a, sleep) :-
    write(" |  z     z  |"), nl.

draw_charsine_status(a, paralysis) :-
    write(" |  +     -  |"), nl.

draw_charsine_status(a, burn) :-
    write(" |  >     <  |"), nl.

draw_charsine_status(a, faint) :-
    write(" |  x     x  |"), nl.

draw_charsine_status(b, none) :-
    write("                                                                                       |  0     0  |"), nl.

draw_charsine_status(b, confusion) :-
    write("                                                                                       |  O     o  |"), nl.

draw_charsine_status(b, sleep) :-
    write("                                                                                       |  z     z  |"), nl.

draw_charsine_status(b, paralysis) :-
    write("                                                                                       |  +     -  |"), nl.

draw_charsine_status(b, burn) :-
    write("                                                                                       |  >     <  |"), nl.

draw_charsine_status(b, faint) :-
    write("                                                                                       |  x     x  |"), nl.

draw_field(empty) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(a, big_pinch) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                                  |                 |"),nl,
    write("                                                  |_________________|"),nl,
    write("                                                           |"),nl,
    write("                                                           |"),nl,
    write("                                                           |"),nl,
    write("                                                           |"),nl,
    write("                                                           |"),nl,
    write("                                                           |"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(a, water_snap) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                                           |"),nl,
    write("                                                           |"),nl,
    write("                                                    _ _ _  |  _ _ _ "),nl,
    write("                                                        /  | \\"),nl,
    write("                                                       /   |  \\"),nl,
    write("                                                      /    |   \\"),nl,
    write("                                                     /     |    \\"),nl,
    write("                                                           |"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(a, confuse_wave) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                                             _ _ _"),nl,
    write("                                                            |     |"),nl,
    write("                                                         _ _|_    |"),nl,
    write("                                                        |   |_|_ _|"),nl,
    write("                                                     _ _|_    |"),nl,
    write("                                                    |   |_|_ _|"),nl,
    write("                                                    |     |"),nl,
    write("                                                    |_ _ _|"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(a, shell_molt) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                                                              \\ \\ | | - - - - | | / /"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(b, big_pinch) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                |                 |"),nl,
    write("                                |_________________|"),nl,
    write("                                         |"),nl,
    write("                                         |"),nl,
    write("                                         |"),nl,
    write("                                         |"),nl,
    write("                                         |"),nl,
    write("                                         |"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(b, water_snap) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                         |"),nl,
    write("                                         |"),nl,
    write("                                  _ _ _  |  _ _ _ "),nl,
    write("                                      /  | \\"),nl,
    write("                                     /   |  \\"),nl,
    write("                                    /    |   \\"),nl,
    write("                                   /     |    \\"),nl,
    write("                                         |"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(b, confuse_wave) :-
    write(""),nl,
    write(""),nl,
    write("                                           _ _ _"),nl,
    write("                                          |     |"),nl,
    write("                                       _ _|_    |"),nl,
    write("                                      |   |_|_ _|"),nl,
    write("                                   _ _|_    |"),nl,
    write("                                  |   |_|_ _|"),nl,
    write("                                  |     |"),nl,
    write("                                  |_ _ _|"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(b, shell_molt) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("\\ \\ | | - - - - | | / /"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(a, sleep_spore) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                ................."),nl,
    write("                                 ................."),nl,
    write("                                  ................."),nl,
    write("                                 ................."),nl,
    write("                                ................."),nl,
    write("                                 ................."),nl,
    write("                                  ................."),nl,
    write("                                 ................."),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.


draw_field(a, paralyze_dust) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                ,,,,,,,,,,,,,,,,,"),nl,
    write("                                 ,,,,,,,,,,,,,,,,,"),nl,
    write("                                  ,,,,,,,,,,,,,,,,,"),nl,
    write("                                 ,,,,,,,,,,,,,,,,,"),nl,
    write("                                ,,,,,,,,,,,,,,,,,"),nl,
    write("                                 ,,,,,,,,,,,,,,,,,"),nl,
    write("                                  ,,,,,,,,,,,,,,,,,"),nl,
    write("                                 ,,,,,,,,,,,,,,,,,"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(a, fungal_launch) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                       /\\"),nl,
    write("                                      /  \\"),nl,
    write("                                     /    \\"),nl,
    write("                                    /      \\"),nl,
    write("                                   /        \\"),nl,
    write("                                  /          \\"),nl,
    write("                                 /            \\"),nl,
    write("                                /              \\"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(a, take_root) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                   |"),nl,
    write("                                  /|"),nl,
    write("                                 / |\\"),nl,
    write("                                /  | \\"),nl,
    write("                                  /|  \\"),nl,
    write("                                 / |\\  \\"),nl,
    write("                                / /| \\"),nl,
    write("                                 / |  "),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(b, sleep_spore) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                                                ................."),nl,
    write("                                                                 ................."),nl,
    write("                                                                ................."),nl,
    write("                                                               ................."),nl,
    write("                                                                ................."),nl,
    write("                                                                 ................."),nl,
    write("                                                                ................."),nl,
    write("                                                               ................."),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(b, paralyze_dust) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                                                ,,,,,,,,,,,,,,,,,"),nl,
    write("                                                                 ,,,,,,,,,,,,,,,,,"),nl,
    write("                                                                ,,,,,,,,,,,,,,,,,"),nl,
    write("                                                               ,,,,,,,,,,,,,,,,,"),nl,
    write("                                                                ,,,,,,,,,,,,,,,,,"),nl,
    write("                                                                 ,,,,,,,,,,,,,,,,,"),nl,
    write("                                                                ,,,,,,,,,,,,,,,,,"),nl,
    write("                                                               ,,,,,,,,,,,,,,,,,"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(b, fungal_launch) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                                               \\              /"),nl,
    write("                                                                \\            /"),nl,
    write("                                                                 \\          /"),nl,
    write("                                                                  \\        /"),nl,
    write("                                                                   \\      /"),nl,
    write("                                                                    \\    /"),nl,
    write("                                                                     \\  /"),nl,
    write("                                                                      \\/"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(b, take_root) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("                                                                    | /"),nl,
    write("                                                                  \\ |/ /"),nl,
    write("                                                                \\  \\| /"),nl,
    write("                                                                 \\  |/"),nl,
    write("                                                                  \\ |  /"),nl,
    write("                                                                   \\| /"),nl,
    write("                                                                    |/"),nl,
    write("                                                                    |"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(a, hibernate) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("zzzzzzzzzzzz"),nl,
    write("          z"),nl,
    write("        z"),nl,
    write("      z"),nl,
    write("    z"),nl,
    write("   z"),nl,
    write(" z"),nl,
    write("zzzzzzzzzzzz"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(a, heat_over) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,

    write("                                    |            |            |"),nl,
    write("                                |   |   |    |   |   |    |   |   |"),nl,
    write("                                |   |   |    |   |   |    |   |   |"),nl,
    write("                                    |            |            |"),nl,
    write("                                   / \\         /  \\         /  \\"),nl,
    write("                                  /   \\       /    \\       /    \\"),nl,
    write("                                 /     \\     /      \\     /      \\"),nl,
    write("                                /       \\   /        \\   /        \\"),nl,

    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(a, toasty_hug) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,

    write("                                    |"),nl,
    write("                                |   |   |"),nl,
    write("                                |   |   |"),nl,
    write("                                    |"),nl,
    write("                                   / \\"),nl,
    write("                                  /   \\"),nl,
    write("                                 /     \\"),nl,
    write("                                /       \\"),nl,

    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(a, toasty_hug) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("  |     |     |"),nl,
    write("  |     |     |"),nl,
    write("  |     |     |"),nl,
    write("  |     |     |"),nl,
    write("  |     |     |"),nl,
    write("__|__ __|__ __|__"),nl,
    write("  |     |     |"),nl,
    write("  |     |     |"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(b, hibernate) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("zzzzzzzzzzzz"),nl,
    write("          z"),nl,
    write("        z"),nl,
    write("      z"),nl,
    write("    z"),nl,
    write("   z"),nl,
    write(" z"),nl,
    write("zzzzzzzzzzzz"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(b, heat_over) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,

    write("                                    |            |            |"),nl,
    write("                                |   |   |    |   |   |    |   |   |"),nl,
    write("                                |   |   |    |   |   |    |   |   |"),nl,
    write("                                    |            |            |"),nl,
    write("                                   / \\         /  \\         /  \\"),nl,
    write("                                  /   \\       /    \\       /    \\"),nl,
    write("                                 /     \\     /      \\     /      \\"),nl,
    write("                                /       \\   /        \\   /        \\"),nl,

    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(b, toasty_hug) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,

    write("                                    |"),nl,
    write("                                |   |   |"),nl,
    write("                                |   |   |"),nl,
    write("                                    |"),nl,
    write("                                   / \\"),nl,
    write("                                  /   \\"),nl,
    write("                                 /     \\"),nl,
    write("                                /       \\"),nl,

    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_field(b, toasty_hug) :-
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write("  |     |     |"),nl,
    write("  |     |     |"),nl,
    write("  |     |     |"),nl,
    write("  |     |     |"),nl,
    write("  |     |     |"),nl,
    write("__|__ __|__ __|__"),nl,
    write("  |     |     |"),nl,
    write("  |     |     |"),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl,
    write(""),nl.

draw_moves(lobachu) :-
    write("1. Big Pinch"), nl,
    write("2. Water Snap"), nl,
    write("3. Confuse Wave"), nl,
    write("4. Shell Molt"), nl.

draw_moves(mushlator) :-
    write("1. Sleep Spore"), nl,
    write("2. Paralyze Dust"), nl,
    write("3. Fungal Launch"), nl,
    write("4. Take Root"), nl.

draw_moves(charsine) :-
    write("1. Hibernate"), nl,
    write("2. Heat Over"), nl,
    write("3. Toasty Hug"), nl,
    write("4. Fire Dance"), nl.

use_move(big_pinch) :-
    write("                          |___|"), nl,
    write("Lobachu used Big Pinch!     |"), nl.

use_move(water_snap) :-
    write("                             _|_"), nl,
    write("Lobachu used Water Snap!     /|\\"), nl.

use_move(confuse_wave) :-
    write("                               _ "), nl,
    write("Lobachu used Confuse Wave!    | |_|"), nl.

use_move(shell_molt) :-
    write("                             |   |"), nl,
    write("Lobachu used Shell Molt!     |_ _|"), nl.

use_move(sleep_spore) :-
    write("                               . .  ."), nl,
    write("Mushlator used Sleep Spore!     .  . . "), nl.

use_move(paralyze_dust) :-
    write("                                , ,  ,"), nl,
    write("Mushlator used Paralyze Dust!    ,  , , "), nl.

use_move(fungal_launch) :-
    write("                                   /\\"), nl,
    write("Mushlator used Fungal Launch!     /__\\"), nl.

use_move(take_root) :-
    write("                             /|\\"), nl,
    write("Mushlator used Take Root!     |\\"), nl.

use_move(hibernate) :-
    write("                                Z Z"), nl,
    write("Charsine used Hibernate!     Z Z"), nl.

use_move(heat_over) :-
    write("                                   \\  |  / "), nl,
    write("Charsine is charging up power!     |     |"), nl.

use_move(heat_over_2) :-
    write("                             \\|/ \\|/ \\|/"), nl,
    write("Charsine used Heat Over!     / \\ / \\ / \\"), nl.

use_move(toasty_hug) :-
    write("                              \\|/"), nl,
    write("Charsine used Toasty Hug!     / \\"), nl.

use_move(fire_dance) :-
    write("                             _|_ _|_ _|_"), nl,
    write("Charsine used Toasty Hug!     |   |   |"), nl.

draw_stat(shell_molt) :-
    write("Lobachu's Defence decreased!"),
    write("Lobachu's Speed greatly increased!").

draw_stat(take_root) :-
    write("Mushlator's Speed decreased!"),
    write("Mushlator is healing each turn!").

draw_stat(take_root_heal) :-
    write("Mushlator heals itself!").

draw_stat(fire_dance) :-
    write("Charsine's Attack increased!").

draw_status(lobachu, confuse) :-
    write("Lobachu is confused!").

draw_status(mushlator, confuse) :-
    write("Mushlator is confused!").

draw_status(charsine, confuse) :-
    write("Charsine is confused!").

draw_status(lobachu, selfdmg) :-
    write("Lobachu hurt itself in confusion!").

draw_status(mushlator, selfdmg) :-
    write("Mushlator hurt itself in confusion!").

draw_status(charsine, confuse) :-
    write("Charsine hurt itself in confusion!").

draw_status(lobachu, paralysis) :-
    write("Lobachu is paralyzed!").

draw_status(mushlator, paralysis) :-
    write("Mushlator is paralyzed!").

draw_status(charsine, paralysis) :-
    write("Charsine is paralyzed!").

draw_status(lobachu, cantmove) :-
    write("Lobachu can't move!").

draw_status(mushlator, cantmove) :-
    write("Mushlator can't move!").

draw_status(charsine, cantmove) :-
    write("Charsine can't move!").

draw_status(lobachu, sleep) :-
    write("Lobachu sleep").

draw_status(mushlator, sleep) :-
    write("Mushlator is fast asleep!").

draw_status(charsine, sleep) :-
    write("Charsine is fast asleep!").

draw_status(lobachu, wake) :-
    write("Lobachu woke up!").

draw_status(mushlator, wake) :-
    write("Mushlator woke up").

draw_status(charsine, wake) :-
    write("Charsine woke up").

draw_status(lobachu, burn) :-
    write("Lobachu is burning!").

draw_status(mushlator, burn) :-
    write("Mushlator is burning!").

draw_status(charsine, burn) :-
    write("Charsine is burning!").

draw_faint(lobachu) :-
    write("Lobachu fainted!").

draw_faint(mushlator) :-
    write("Mushlator fainted!").

draw_faint(charsine) :-
    write("Charsine fainted!").