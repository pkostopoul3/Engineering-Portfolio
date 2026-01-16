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

% Δημιουργία Γράφου
sources = raw_data(:, 1);
targets = raw_data(:, 2);
G_init = digraph(sources, targets);
node_names = G_init.Nodes.Name;
num_nodes = numnodes(G_init);

% Αρχικοποίηση
cost_matrix = zeros(num_nodes);
cap_matrix = zeros(num_nodes); % Residual Capacity (Πόσο χώρο έχουμε)
flow_on_edge = zeros(num_nodes); % Πόση ροή τρέχει πραγματικά
orig_cap = zeros(num_nodes);

for k = 1:size(raw_data, 1)
    u = findnode(G_init, raw_data{k,1});
    v = findnode(G_init, raw_data{k,2});
    cap = raw_data{k,3};
    cost = raw_data{k,4};
    cap_matrix(u,v) = cap;
    orig_cap(u,v) = cap;
    cost_matrix(u,v) = cost;
end

s_node = findnode(G_init, 's');
t_node = findnode(G_init, 't');

% =========================================================================
%    ΦΑΣΗ 1: ΔΗΜΙΟΥΡΓΙΑ ΑΡΧΙΚΗΣ ΕΦΙΚΤΗΣ ΛΥΣΗΣ
%    (Χρησιμοποιούμε τη μέθοδο SSP μια φορά γρήγορα για να γεμίσουμε το δίκτυο)
% =========================================================================
fprintf('\n======================================================\n');
fprintf(' ΦΑΣΗ 1: ΕΥΡΕΣΗ ΑΡΧΙΚΗΣ ΕΦΙΚΤΗΣ ΛΥΣΗΣ\n');
fprintf(' (Γεμίζουμε το δίκτυο μέχρι κορεσμού)\n');
fprintf('======================================================\n');

while true
    % Βρίσκουμε οποιοδήποτε μονοπάτι (έστω και ακριβό)
    [u_idx, v_idx] = find(cap_matrix > 0);
    if isempty(u_idx), break; end
    
    weights = zeros(length(u_idx), 1);
    for k=1:length(u_idx), weights(k) = cost_matrix(u_idx(k), v_idx(k)); end
    
    G_temp = digraph(u_idx, v_idx, weights, num_nodes);
    [path, ~] = shortestpath(G_temp, s_node, t_node, 'Method', 'mixed');
    
    if isempty(path), break; end
    
    % Υπολογισμός Delta
    p_caps = [];
    for k = 1:length(path)-1
        p_caps(end+1) = cap_matrix(path(k), path(k+1));
    end
    delta = min(p_caps);
    
    % Ενημέρωση Ροών
    for k = 1:length(path)-1
        u = path(k); v = path(k+1);
        cap_matrix(u,v) = cap_matrix(u,v) - delta;
        cap_matrix(v,u) = cap_matrix(v,u) + delta;
        cost_matrix(v,u) = -cost_matrix(u,v);
        
        % Καταγραφή πραγματικής ροής (για υπολογισμό κόστους)
        if orig_cap(u,v) > 0
            flow_on_edge(u,v) = flow_on_edge(u,v) + delta;
        else % Είναι residual -> μειώνουμε την κανονική
            flow_on_edge(v,u) = flow_on_edge(v,u) - delta;
        end
    end
end

% Υπολογισμός Κόστους Φάσης 1
init_cost = sum(sum(flow_on_edge .* (cost_matrix .* (orig_cap>0))));
init_flow = sum(flow_on_edge(:, t_node));
fprintf(' -> Αρχική Ροή: %d (Πλήρης)\n', init_flow);
fprintf(' -> Αρχικό Κόστος: %d\n', init_cost);


% =========================================================================
%    ΦΑΣΗ 2: NETWORK SIMPLEX (ΒΕΛΤΙΣΤΟΠΟΙΗΣΗ)
%    (Εύρεση Αρνητικών Κύκλων / Reduced Costs και διόρθωση)
% =========================================================================
fprintf('\n======================================================\n');
fprintf(' ΦΑΣΗ 2: ΕΚΤΕΛΕΣΗ NETWORK SIMPLEX\n');
fprintf(' (Αναζήτηση Κύκλων Βελτίωσης Κόστους)\n');
fprintf('======================================================\n');

iter = 0;
while true
    iter = iter + 1;
    
    % 1. Κατασκευή λίστας ακμών του Residual Graph
    [u_list, v_list] = find(cap_matrix > 0);
    edge_costs = zeros(length(u_list), 1);
    for k=1:length(u_list)
        edge_costs(k) = cost_matrix(u_list(k), v_list(k));
    end
    
    % 2. Bellman-Ford για εύρεση ΑΡΝΗΤΙΚΟΥ ΚΥΚΛΟΥ
    dist = zeros(num_nodes, 1);
    parent = zeros(num_nodes, 1);
    changed_node = -1;
    
    % Relaxation N φορές
    for i = 1:num_nodes
        changed_node = -1;
        for k = 1:length(u_list)
            u = u_list(k); v = v_list(k); w = edge_costs(k);
            if dist(u) + w < dist(v)
                dist(v) = dist(u) + w;
                parent(v) = u;
                changed_node = v;
            end
        end
    end
    
    % Αν δεν υπήρξε αλλαγή στο N-οστό βήμα, δεν υπάρχει αρνητικός κύκλος
    if changed_node == -1
        fprintf('\n>>> ΤΕΛΟΣ: Δεν βρέθηκαν άλλοι κύκλοι βελτίωσης. ΒΕΛΤΙΣΤΗ ΛΥΣΗ! <<<\n');
        break;
    end
    
    % 3. Ανακατασκευή Κύκλου (Backtracking)
    % Πάμε πίσω N βήματα για να σιγουρευτούμε ότι είμαστε μέσα στον κύκλο
    curr = changed_node;
    for i=1:num_nodes, curr = parent(curr); end
    
    cycle = [curr];
    next_node = parent(curr);
    while next_node ~= curr
        cycle = [next_node, cycle];
        next_node = parent(next_node);
    end
    cycle = [curr, cycle]; % Κλείσιμο κύκλου
    
    % 4. Υπολογισμός Θήτα (Theta)
    c_caps = [];
    cycle_cost = 0;
    for k=1:length(cycle)-1
        u = cycle(k); v = cycle(k+1); % Προσοχή: Ο κύκλος βγήκε ανάποδα (parent pointers)
        % Αλλά στον Simplex θέλουμε τη ροή προς τη σωστή κατεύθυνση του κύκλου
        % Επειδή το parent δείχνει "από πού ήρθα", η ροή είναι v->u
    end
    
    % ΔΙΟΡΘΩΣΗ ΦΟΡΑΣ ΚΥΚΛΟΥ:
    % Το parent(v) = u σημαίνει u -> v βελτιώνει το κόστος.
    % Άρα ακολουθούμε τα parents ανάποδα: v <- u.
    % Ο κύκλος που φτιάξαμε είναι [..., u, v, ...] όπου v = parent(u).
    % Άρα η ροή πρέπει να πάει u -> v (όπως δείχνει το dist update).
    
    % Ξαναφτιάχνουμε τον κύκλο σωστά (u -> v)
    cycle_nodes = [];
    curr = changed_node;
    for i=1:num_nodes, curr = parent(curr); end % Μπαίνουμε στον κύκλο
    start_cycle = curr;
    
    % Καταγραφή κύκλου με τη σωστή φορά
    cycle_path = [start_cycle];
    curr = parent(start_cycle); % Πάμε ανάποδα για να βρούμε τους προγόνους
    % ΑΛΛΑΓΗ ΣΤΡΑΤΗΓΙΚΗΣ: Χρησιμοποιούμε τη λίστα parents για να βρούμε τον κύκλο
    % Η ροή πάει parent(v) -> v.
    
    % Απλή μέθοδος: Βρες το μονοπάτι του κύκλου
    cycle_edges_u = [];
    cycle_edges_v = [];
    
    curr = start_cycle;
    while true
        prev = parent(curr);
        cycle_edges_u(end+1) = prev;
        cycle_edges_v(end+1) = curr;
        if prev == start_cycle, break; end
        curr = prev;
    end
    
    % Υπολογισμός Theta & Κόστους
    min_theta = inf;
    total_cycle_cost = 0;
    
    for k=1:length(cycle_edges_u)
        u = cycle_edges_u(k); v = cycle_edges_v(k);
        min_theta = min(min_theta, cap_matrix(u,v));
        total_cycle_cost = total_cycle_cost + cost_matrix(u,v);
    end
    
    % 5. Εκτύπωση και Ενημέρωση
    fprintf('ΒΗΜΑ %d (Pivot):\n', iter);
    fprintf('   Εντοπίστηκε Κύκλος: ');
    for k=length(cycle_edges_u):-1:1
        fprintf('%s -> ', node_names{cycle_edges_u(k)});
    end
    fprintf('%s\n', node_names{cycle_edges_v(1)});
    
    fprintf('   Reduced Cost Κύκλου: %d\n', total_cycle_cost);
    fprintf('   Theta (Ροή): %d\n', min_theta);
    fprintf('   Μείωση Κόστους: %d\n', abs(total_cycle_cost * min_theta));
    fprintf('------------------------------------------------------\n');
    
    % Ενημέρωση Ροών στο Δίκτυο
    for k=1:length(cycle_edges_u)
        u = cycle_edges_u(k); v = cycle_edges_v(k);
        
        cap_matrix(u,v) = cap_matrix(u,v) - min_theta;
        cap_matrix(v,u) = cap_matrix(v,u) + min_theta;
        cost_matrix(v,u) = -cost_matrix(u,v);
        
        % Ενημέρωση πραγματικής ροής
        if orig_cap(u,v) > 0
            flow_on_edge(u,v) = flow_on_edge(u,v) + min_theta;
        else
            flow_on_edge(v,u) = flow_on_edge(v,u) - min_theta;
        end
    end
end

% =========================================================================
%    ΤΕΛΙΚΑ ΑΠΟΤΕΛΕΣΜΑΤΑ
% =========================================================================
final_cost = 0;
for i=1:num_nodes
    for j=1:num_nodes
        if orig_cap(i,j) > 0
            final_cost = final_cost + flow_on_edge(i,j) * cost_matrix(i,j);
        end
    end
end

fprintf('\n======================================================\n');
fprintf('ΤΕΛΙΚΑ ΑΠΟΤΕΛΕΣΜΑΤΑ (NETWORK SIMPLEX):\n');
fprintf('Συνολική Ροή: %d\n', sum(flow_on_edge(:, t_node)));
fprintf('Τελικό Ελάχιστο Κόστος: %d\n', final_cost);
fprintf('======================================================\n');