clc; clear; close all;

% --- 1. ΟΡΙΣΜΟΣ ΔΕΔΟΜΕΝΩΝ  ---
raw_data = {
    % --- Κανονικές Ακμές ---
    %'s', '1', 72, 0;
    %'s', '2', 24, 0;
    %'s', '4', 72, 0;    
    '1', '2', 192, 48;
    '1', '3', 144, 52;
    '1', '4', 72, 6;
    '2', '3', 120, 57;
    '2', '5', 120, 12;
    '3', '4', 168, 52;
    '3', '5', 192, 48;
    '3', '6', 96, 52;
    %'3', '7', 24, 9;     
    '4', '6', 48, 72;
    %'4', '7', 24, 26;     
    '4', '8', 120, 72;
    '5', '6', 120, 96;
    '5', '8', 192, 76;
    '6', '7', 144, 52;
    '6', '8', 96, 38;
    %'6', '9', 48, 9;
    %'7', '8', 24, 9;      
    '7', '9', 96, 38;
    '7', '10', 48, 39;
    '8', '9', 168, 96;
    %'8', '10', 24, 26;    
    '9', '10', 336, 6;
    %'9', 't', 24, 0;
    %'10', 't', 24, 0; 

    % Από 1η Επανάληψη      
    '7', '4', 72, -26;    
    '8', '7', 72, -9;     
    '10', '8', 72, -26; 

     % Από 2η Επανάληψη     
    '4', '1', 24, -6;

     % Από 3η Επανάληψη
    %'3', '1', 24, -52;    
    '7', '3', 24, -9;  

    % Από 4η Επανάληψη
    '6', '4', 72, -72;    
    '9', '6', 72, -9;  

    % Από 5η Επανάληψη     
    '5', '2', 48, -12;    
    '6', '5', 48, -96;

     % Από 6η Επανάληψη     
    '3', '2', 24, -57;       
    '9', '7', 24, -38;
    %'10', '9', 24, -6;

};
   

sources = raw_data(:, 1);
targets = raw_data(:, 2);
G = digraph(sources, targets);
node_names = G.Nodes.Name; 

% =========================================================================
%        ΒΗΜΑ 2: ΕΥΡΕΣΗ & ΤΑΞΙΝΟΜΗΣΗ ΚΥΚΛΩΝ
% =========================================================================
fprintf('\n======================================================\n');
fprintf(' ΑΝΑΖΗΤΗΣΗ ΒΕΛΤΙΣΤΟΥ ΑΡΝΗΤΙΚΟΥ ΚΥΚΛΟΥ\n');
fprintf(' (Κριτήρια: 1. Πιο Αρνητικό Κόστος, 2. Λιγότερες Ακμές)\n');
fprintf('======================================================\n');

num_nodes = numnodes(G);
cost_matrix = zeros(num_nodes);
cap_matrix = zeros(num_nodes);

% Γέμισμα πινάκων (Διορθωμένο για διπλές ακμές)
for k = 1:size(raw_data, 1)
    u = findnode(G, raw_data{k,1});
    v = findnode(G, raw_data{k,2});
    cap = raw_data{k,3};
    cost = raw_data{k,4};
    
    % Αν η ακμή έχει χωρητικότητα > 0, την λαμβάνουμε υπόψη
    if cap > 0
        % Αν είναι η πρώτη φορά που βλέπουμε ακμή ή αν βρήκαμε φθηνότερη
        if cap_matrix(u,v) == 0 || (cost < cost_matrix(u,v))
            cost_matrix(u,v) = cost;
            cap_matrix(u,v) = cap;
        end
    end
end

cycles_found = {}; 
costs_found = [];
caps_found = [];

for start_node = 1:num_nodes
    [cycles_found, costs_found, caps_found] = simple_dfs_cycle(...
        start_node, start_node, [], 0, inf, ...
        cost_matrix, cap_matrix, node_names, ...
        cycles_found, costs_found, caps_found);
end

if isempty(costs_found)
    fprintf(' -> Δεν βρέθηκαν κύκλοι!\n');
else
    % --- ΕΔΩ ΕΙΝΑΙ Η ΔΙΑΦΟΡΑ ---
    % 1. Υπολογίζουμε το μήκος κάθε κύκλου
    lengths = cellfun(@length, cycles_found) - 1; 
    
    % 2. Φτιάχνουμε πίνακα: [Index, Cost, Length]
    num_cycles = length(costs_found);
    data_to_sort = zeros(num_cycles, 3);
    for i = 1:num_cycles
        data_to_sort(i, :) = [i, costs_found(i), lengths(i)];
    end
    
    % 3. Ταξινομούμε: Πρώτα Κόστος (Αύξουσα), μετά Μήκος (Αύξουσα)
    sorted_data = sortrows(data_to_sort, [2, 3]);
    
    best_idx = sorted_data(1, 1);
    best_cost = sorted_data(1, 2);
    min_capacity = caps_found(best_idx);
    
    fprintf('Βρέθηκαν %d κύκλοι.\n', num_cycles);
    fprintf('>>> ΕΠΙΛΟΓΗ ΒΕΛΤΙΣΤΟΥ ΚΥΚΛΟΥ <<<\n');
    fprintf('Κύκλος: %s\n', strjoin(cycles_found{best_idx}, ' -> '));
    fprintf('Κόστος: %d\n', best_cost);
    fprintf('Ακμές: %d\n', sorted_data(1, 3));
    fprintf('Ελάχιστη Χωρητικότητα (Delta): %d\n', min_capacity);
    
    % Υπολογισμός αποτελέσματος
    current_total_cost = 25200; % (Το κόστος μετά τον 1ο κύκλο: 25632 - 432)
    reduction = abs(best_cost * min_capacity);
    new_cost = current_total_cost - reduction;
    
    fprintf('------------------------------------------------------\n');
    fprintf('Παλιό Κόστος: %d\n', current_total_cost);
    fprintf('Μείωση: %d * (%d) = -%d\n', min_capacity, best_cost, reduction);
    fprintf('ΝΕΟ ΤΕΛΙΚΟ ΚΟΣΤΟΣ: %d\n', new_cost);
    fprintf('------------------------------------------------------\n');
end

function [cycles, costs, caps] = simple_dfs_cycle(curr, start, path, cost_so_far, min_cap, C, CAP, names, cycles, costs, caps)
    path_nodes = [path, curr];
    neighbors = find(C(curr, :) ~= 0 | CAP(curr, :) ~= 0);
    
    for i = 1:length(neighbors)
        next_node = neighbors(i);
        if CAP(curr, next_node) > 0 
            edge_cost = C(curr, next_node);
            edge_cap = CAP(curr, next_node);
            
            if next_node == start && length(path_nodes) > 2
                cycle_path = [reshape(names(path_nodes), 1, []), names(start)];
                total_cost = cost_so_far + edge_cost;
                total_cap = min(min_cap, edge_cap);
                
                is_new = true;
                for k=1:length(costs)
                    if costs(k) == total_cost && length(cycles{k}) == length(cycle_path)
                         is_new = false; 
                    end
                end
                if is_new
                    cycles{end+1} = cycle_path;
                    costs(end+1) = total_cost;
                    caps(end+1) = total_cap;
                end
            elseif ~ismember(next_node, path_nodes)
                [cycles, costs, caps] = simple_dfs_cycle(next_node, start, path_nodes, ...
                    cost_so_far + edge_cost, min(min_cap, edge_cap), ...
                    C, CAP, names, cycles, costs, caps);
            end
        end
    end
end
    