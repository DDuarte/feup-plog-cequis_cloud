:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(clpfd)).
:- use_module(library(samsort)).

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

all_equal([], _).
all_equal([X|T], X) :-
    all_equal(T, X).

generate_task_types(L, AuthR, ScriptsR, StorageR) :-
    requests(R),
    auth_percentage(AP),
    scripts_percentage(SP),
    storage_percentage(StP),
    AuthR is round(R * (AP / 100)),
    ScriptsR is round(R * (SP / 100)),
    StorageR is round(R * (StP / 100)),
    length(AuthL, AuthR),
    length(ScriptsL, ScriptsR),
    length(StorageL, StorageR),
    all_equal(AuthL, 0),
    all_equal(ScriptsL, 1),
    all_equal(StorageL, 2),
    append([AuthL, ScriptsL, StorageL], List),
    random_permutation(List, L).

highest_request_time(Time) :-
    auth_request_time(Auth), storage_request_time(Storage), script_request_time(Script),
    max_member(Time, [Auth, Storage, Script]).

%% indexed by machine id (0 - auth, 1 - storage, 2 - script)
request_time(0, X) :- auth_request_time(X).
request_time(1, X) :- storage_request_time(X).
request_time(2, X) :- script_request_time(X).

request_disk(0, X) :- auth_request_disk(X).
request_disk(1, X) :- storage_request_disk(X).
request_disk(2, X) :- script_request_disk(X).

request_ram(0, X) :- auth_request_ram(X).
request_ram(1, X) :- storage_request_ram(X).
request_ram(2, X) :- script_request_ram(X).

request_cpu(0, X) :- auth_request_cpu(X).
request_cpu(1, X) :- storage_request_cpu(X).
request_cpu(2, X) :- script_request_cpu(X).

generate_tasks([], [], [], [], [], []).
generate_tasks([TaskType|TaskTypes], [TaskDisk|TaskDisks], [TaskRAM|TaskRAMs], [TaskCPU|TaskCPUs], [TaskST|TaskSTs], [TaskET|TaskETs]) :-
    request_time(TaskType, Time),
    request_disk(TaskType, Disk),
    request_ram(TaskType, RAM),
    request_cpu(TaskType, CPU),
    TaskDisk = task(TaskST, Time, TaskET, Disk, TaskType),
    TaskRAM = task(TaskST, Time, TaskET, RAM, TaskType),
    TaskCPU = task(TaskST, Time, TaskET, CPU, TaskType),
    generate_tasks(TaskTypes, TaskDisks, TaskRAMs, TaskCPUs, TaskSTs, TaskETs).

generate_machines_disk([machine(0, A), machine(1, B), machine(2, C)]) :-
    server_auth_disk(A),
    server_storage_disk(B),
    server_script_disk(C).

generate_machines_ram([machine(0, A), machine(1, B), machine(2, C)]) :-
    server_auth_ram(A),
    server_storage_ram(B),
    server_script_ram(C).

generate_machines_cpu([machine(0, A), machine(1, B), machine(2, C)]) :-
    server_auth_cpu(A),
    server_storage_cpu(B),
    server_script_cpu(C).

calculate_cost_queues(_, [], _, TempSlots, TempSlots).
calculate_cost_queues([StartTime|StartTimes], [NextTime|NextTimes], OldestTime, TempSlots, TotalSlots) :-
    DT is NextTime - StartTime,
    calc_time_and_slots(StartTime, OldestTime, DT, NewOldestTime, TempSlots, NewSlots),
    calculate_cost_queues(StartTimes, NextTimes, NewOldestTime, NewSlots, TotalSlots).

calc_time_and_slots(StartTime, OldestTime, DT, StartTime, TempSlots, TempSlots) :-
    routing_spd_time(RouteTime),
    highest_request_time(ReqTime),
    DT >= RouteTime,
    DTOld is StartTime - OldestTime,
    DTOld >= ReqTime.
    
calc_time_and_slots(StartTime, OldestTime, DT, OldestTime, TempSlots, TempSlots) :-
    routing_spd_time(RouteTime),
    highest_request_time(ReqTime),
    DT >= RouteTime,
    DTOld is StartTime - OldestTime,
    DTOld < ReqTime.  
 
calc_time_and_slots(StartTime, OldestTime, DT, OldestTime, TempSlots, NewSlots) :-
    routing_spd_time(RouteTime),
    highest_request_time(ReqTime),
    DT < RouteTime,
    DTOld is StartTime - OldestTime,
    DTOld < ReqTime,
    NewSlots is TempSlots + 1.
    
calc_time_and_slots(StartTime, OldestTime, DT, StartTime, TempSlots, NewSlots) :-
    routing_spd_time(RouteTime),
    highest_request_time(ReqTime),
    DT < RouteTime,
    DTOld is StartTime - OldestTime,
    DTOld >= ReqTime,
    NewSlots is TempSlots + 1. 
 
ordered_start_times([], TempList, List) :-
    samsort(TempList, List). %% samsort does not remove duplicates
ordered_start_times([Task|Tasks], TempList, List) :-
    arg(1, Task, ST), %% task(ST, DT, ET, Resc, Mach), arg is 1-indexed
    append(TempList, [ST], TempList1),
    ordered_start_times(Tasks, TempList1, List).

euro_unicode(8364).

write_profit_or_loss(X) :-
    X > 0,
    write('+'), write(X).
write_profit_or_loss(X) :-
    write(X).

init :-
    read_config,
    generate_task_types(Types, AuthR, StorageR, ScriptsR),
    requests(R),
    length(TaskDisks, R), length(TaskRAMs, R), length(TaskCPUs, R), %% needed?
    length(TaskSTs, R), length(TaskETs, R),
    generate_tasks(Types, TaskDisks, TaskRAMs, TaskCPUs, TaskSTs, TaskETs),
    generate_machines_disk(MachineDisks),
    generate_machines_ram(MachineRAMs),
    generate_machines_cpu(MachineCPUs),
    routing_spd_time(RouteTime),
    MaxTaskTime is 1000*60*60*24,
    domain(TaskSTs, RouteTime, MaxTaskTime),
    domain(TaskETs, RouteTime, MaxTaskTime),
    domain([End],   RouteTime, MaxTaskTime),
    maximum(End, TaskETs),
    cumulatives(TaskDisks, MachineDisks, [bound(upper)]),
    cumulatives(TaskRAMs,  MachineRAMs,  [bound(upper)]),
    cumulatives(TaskCPUs,  MachineCPUs,  [bound(upper)]),
    append(TaskSTs, [End], Vars),
    labeling([], Vars), %% program doesn't run if we use [minimize(End)]
    write('===== FD Statistics ====='), nl,
    fd_statistics, nl,
    ordered_start_times(TaskDisks, [], [StartTime|StartTimes]),
    calculate_cost_queues([StartTime|StartTimes], StartTimes, StartTime, 0, Slots),
    write('======= Statistics ======'), nl,
    statistics, nl,
    spd_slot_price(SlotPrice),
    server_auth_price(AuthPrice),
    server_storage_price(StoragePrice),
    server_script_price(ScriptPrice),
    Cost is AuthPrice + StoragePrice + ScriptPrice + (Slots * SlotPrice), %% SPD slots only
    budget(Budget),
    euro_unicode(Euro),
    ProfitLoss is Budget - Cost,
    write('======== Results ========'), nl,
    write('Number of Authentication Requests: '),   write(AuthR), nl,
    write('Number of Storage Requests: '),          write(StorageR), nl,
    write('Number of Script Execution Requests: '), write(ScriptsR), nl,
    write('Number of SPD slots bought: '),          write(Slots), nl,
    write('Number of SSD slots bought: '),          write(0), nl,
    write('Number of Authentication Servers: '),    write(1), nl,
    write('Number of Storage Servers: '),           write(1), nl,
    write('Number of Script Execution Servers: '),  write(1), nl,
    write('Available budget: '),                    write(Budget), put_code(Euro), nl,
    write('Total cost: '),                          write(Cost), put_code(Euro), nl,
    write('Profit/Loss: '),                         write_profit_or_loss(ProfitLoss), put_code(Euro), nl.
