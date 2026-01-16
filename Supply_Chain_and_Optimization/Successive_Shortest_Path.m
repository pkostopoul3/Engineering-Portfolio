clc; clear; close all;

% --- 1. ΟΡΙΣΜΟΣ ΑΡΧΙΚΩΝ ΔΕΔΟΜΕΝΩΝ (CLEAN SLATE) ---
% Βάζουμε ΜΟΝΟ τις αρχικές ακμές, χωρίς residuals από προηγούμενες λύσεις.
raw_data = {
    's', '1', 120, 0; 
    's', '2', 96, 0;
    's', '4', 72, 0;
    '1', '2', 192, 48;
    '1', '3', 168, 52;
    '1', '4', 168, 6;
    '2', '3', 168, 57;   
    '2', '5', 168, 12;
    '3', '4', 168, 52;
    '3', '5', 192, 48;
    '3', '6', 96, 52;
    '3', '7', 72, 9;    
    '4', '6', 120, 72;
    '4', '7', 96, 26;
    '4', '8', 120, 72;
    '5', '6', 168, 96;
    '5', '8', 192, 76;
    '6', '7', 144, 52;
    '6', '8', 96, 38;
    '6', '9', 120, 9;
    '7', '8', 120, 9;
    '7', '9', 144, 38;
    '7', '10', 72, 39;
    '8', '9', 168, 96;
    '8', '10', 120, 26;
    '9', '10', 360, 6;
    '9', 't', 144, 0;
    '10', 't', 144, 0;
};


% Δημιουργία Γράφου (μόνο για τα ονόματα)
sources = raw_data(:, 1);
targets = raw_data(:, 2);
G_init = digraph(sources, targets);
node_names = G_init.Nodes.Name;
num_nodes = numnodes(G_init);

% Αρχικοποίηση Πινάκων
cost_matrix = zeros(num_nodes);
cap_matrix = zeros(num_nodes); 

for k = 1:size(raw_data, 1)
    u = findnode(G_init, raw_data{k,1});
    v = findnode(G_init, raw_data{k,2});
    cap = raw_data{k,3};
    cost = raw_data{k,4};
    cap_matrix(u,v) = cap;
    cost_matrix(u,v) = cost;
end

% =========================================================================
%        ΕΚΤΕΛΕΣΗ SSP (FIXED)
% =========================================================================
fprintf('\n======================================================\n');
fprintf(' ALGORITHM: SUCCESSIVE SHORTEST PATH (SSP)\n');
fprintf('======================================================\n');

total_flow = 0;
total_cost = 0;
iteration = 0;

s_node = findnode(G_init, 's');
t_node = findnode(G_init, 't');

while true
    iteration = iteration + 1;
    
    % --- FIX: Δημιουργία Γράφου ΜΟΝΟ με ανοιχτές ακμές ---
    [u_idx, v_idx] = find(cap_matrix > 0); % Βρες ποια ζεύγη έχουν χωρητικότητα
    if isempty(u_idx)
        break; % Αν δεν υπάρχουν ακμές, τέλος
    end
    
    weights = zeros(length(u_idx), 1);
    for k = 1:length(u_idx)
        weights(k) = cost_matrix(u_idx(k), v_idx(k));
    end
    
    % Φτιάχνουμε το γράφημα μόνο με τις ενεργές ακμές
    G_res = digraph(u_idx, v_idx, weights, num_nodes);
    
    % Εύρεση Συντομότερου Μονοπατιού (Mixed για αρνητικά κόστη)
    [path_indices, path_cost] = shortestpath(G_res, s_node, t_node, 'Method', 'mixed');
    
    % Αν δεν υπάρχει μονοπάτι (path_indices empty) ή το κόστος είναι Inf
    if isempty(path_indices) || isinf(path_cost)
        fprintf('\n>>> ΤΕΛΟΣ: Το δίκτυο γέμισε! Δεν υπάρχει άλλο μονοπάτι.\n');
        break;
    end
    
    % Υπολογισμός Delta
    path_caps = [];
    for k = 1:length(path_indices)-1
        u = path_indices(k);
        v = path_indices(k+1);
        path_caps(end+1) = cap_matrix(u,v);
    end
    delta = min(path_caps);
    
    % Εκτύπωση
    path_names = node_names(path_indices);
    path_str = strjoin(path_names, ' -> ');
    step_cost = delta * path_cost;
    
    fprintf('ΒΗΜΑ %d:\n', iteration);
    fprintf('   Διαδρομή: %s\n', path_str);
    fprintf('   Μοναδιαίο Κόστος: %d\n', path_cost);
    fprintf('   Ροή (Delta): %d\n', delta);
    fprintf('   Κόστος Βήματος: %d * %d = %d\n', delta, path_cost, step_cost);
    fprintf('------------------------------------------------------\n');
    
    % Ενημέρωση
    total_flow = total_flow + delta;
    total_cost = total_cost + step_cost;
    
    for k = 1:length(path_indices)-1
        u = path_indices(k);
        v = path_indices(k+1);
        
        cap_matrix(u,v) = cap_matrix(u,v) - delta; % Μείωση
        cap_matrix(v,u) = cap_matrix(v,u) + delta; % Αύξηση residual
        cost_matrix(v,u) = -cost_matrix(u,v);      % Κόστος residual
    end
end

fprintf('\n======================================================\n');
fprintf('ΤΕΛΙΚΑ ΑΠΟΤΕΛΕΣΜΑΤΑ:\n');
fprintf('Συνολική Ροή: %d\n', total_flow);
fprintf('Τελικό Κόστος: %d\n', total_cost);
fprintf('======================================================\n');