config_file('tp2_config.pl').

read_config :-
    config_file(F),
    open(F, read, Str),
    read_file(Str, _),
    close(Str).

read_file(Stream, []) :-
    at_end_of_stream(Stream).
read_file(Stream, [X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream, X),
    assert(X),
    read_file(Stream, L).
    
buy(disk, CostIn, DiskIn, CostOut, DiskOut) :-
    disk_unit(U),
    disk_price(P),
    CostOut is CostIn + P,
    DiskOut is DiskIn + U.

buy(ram, CostIn, RAMIn, CostOut, RAMOut) :-
    ram_unit(U),
    ram_price(P),
    CostOut is CostIn + P,
    RAMOut is RAMIn + U.
    
buy(cpu, CostIn, CPUIn, CostOut, CPUOut) :-
    cpu_unit(U),
    cpu_price(P),
    CostOut is CostIn + P,
    CPUOut is CPUIn + U.
    
buy(disk, CostIn, DiskIn, CostOut, DiskOut, Q) :-
    disk_unit(U),
    disk_price(P),
    CostOut is CostIn + (P * Q),
    DiskOut is DiskIn + (U * Q).
    
buy(ram, CostIn, RAMIn, CostOut, RAMOut, Q) :-
    ram_unit(U),
    ram_price(P),
    CostOut is CostIn + (P * Q),
    RAMOut is RAMIn + (U * Q).
    
buy(cpu, CostIn, CPUIn, CostOut, CPUOut, Q) :-
    cpu_unit(U),
    cpu_price(P),
    CostOut is CostIn + (P * Q),
    CPU is CPUIn + (U * Q).
 
init :-
    read_config,
    buy(ram, 0, 0, Cost, RAM, 3),
    write(Cost),
    nl,
    write(RAM). 