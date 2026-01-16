clc; clear; close all;

% --- 1. ΟΡΙΣΜΟΣ ΑΡΧΙΚΩΝ ΔΕΔΟΜΕΝΩΝ (CLEAN SLATE) ---
% Βάζουμε ΜΟΝΟ τις αρχικές ακμές, χωρίς residuals από προηγούμενες λύσεις.
raw_data = {
    %'s', '1', 120, 0; 
    %'s', '2', 96, 0;
    's', '4', 72, 0;
    %'1', '2', 192, 48;
    %'1', '3', 168, 52;
    '1', '4', 168, 6;
    '2', '3', 168, 57;   
    %'2', '5', 168, 12;
    %'3', '4', 168, 52;
    %'3', '5', 192, 48;
    %'3', '6', 96, 52;
    '3', '7', 72, 9;    
    %'4', '6', 96, 72;
    '4', '7', 96, 26;
    %'4', '8', 120, 72;
    %'5', '6', 168, 96;
    '5', '8', 192, 76;
    '6', '7', 48, 52;
    %'6', '8', 24, 38;
    '6', '9', 72, 9;
    %'7', '8', 24, 9;
    %'7', '9', 144, 38;
    %'7', '10', 72, 39;
    %'8', '9', 168, 96;
    '8', '10', 120, 26;
    %'9', '10', 216, 6;
    '9', 't', 144, 0;
    '10', 't', 144, 0;
};
sources = raw_data(:, 1);
targets = raw_data(:, 2);
G = digraph(sources, targets);

% --- 2. ΑΥΤΟΜΑΤΗ ΑΝΤΙΣΤΟΙΧΙΣΗ (Cost vs Capacity) ---
edge_labels = cell(numedges(G), 1);
text_3_7 = ''; 

for i = 1:numedges(G)
    u = G.Edges.EndNodes{i, 1};
    v = G.Edges.EndNodes{i, 2};
    
    found = false;
    for j = 1:size(raw_data, 1)
        if strcmp(raw_data{j, 1}, u) && strcmp(raw_data{j, 2}, v)
            cap = raw_data{j, 3};
            cost = raw_data{j, 4};
            
            % --- ΓΕΝΙΚΟΣ ΚΑΝΟΝΑΣ ---
            % Ανάποδη θεωρείται αν:
            % 1. Έχει αρνητικό κόστος (π.χ. -26)
            % 2. Ή καταλήγει στο 's' (π.χ. 4->s)
            % 3. Ή ξεκινάει από το 't' (π.χ. t->10)
            is_backward = (cost < 0) || strcmp(v, 's') || strcmp(u, 't');
            
            if is_backward
                % Ανάποδες: Δείχνουμε Κόστος
                label_str = sprintf('%d', cost); 
            else
                % Κανονικές: Δείχνουμε Χωρητικότητα
                label_str = sprintf('%d', cap);
            end
            
            edge_labels{i} = label_str;

            found = true;
            break;
        end
    end
end

% --- 3. ΣΧΕΔΙΑΣΗ ---
figure('Color', 'k', 'Position', [10, 10, 1400, 800]); 
h = plot(G, 'Layout', 'layered', 'Direction', 'right', 'EdgeLabel', edge_labels);

% Στυλ
h.NodeColor = [1, 0.5, 0]; h.MarkerSize = 10; h.NodeFontSize = 14; 
h.NodeFontWeight = 'bold'; h.NodeLabelColor = 'w';
h.EdgeColor = [0.2, 0.8, 1]; h.LineWidth = 1.2; h.ArrowSize = 10;
h.EdgeFontSize = 10; h.EdgeLabelColor = 'w';
set(gca, 'Color', 'k'); axis off;
title('Δίκτυο Ροής Ελάχιστου Κόστους (Χωρητικότητα / Κόστος)', 'FontSize', 14, 'Color', 'w');

% --- FIXED POSITIONS (ΒΑΣΙΣΜΕΝΕΣ ΣΤΗ ΦΩΤΟΓΡΑΦΙΑ ΣΟΥ) ---

% --- 4. ΧΡΩΜΑΤΙΣΜΟΣ ΑΚΜΩΝ (ΕΔΩ ΕΙΝΑΙ Η ΠΡΟΣΘΗΚΗ) ---
% Αυτό μπαίνει ΤΕΛΟΣ για να "πατήσει" πάνω στο γράφημα
edge_colors = repmat([0.2, 0.8, 1], numedges(G), 1); % Default: Light Blue

for i = 1:numedges(G)
    u = G.Edges.EndNodes{i, 1};
    v = G.Edges.EndNodes{i, 2};

    % --- ΕΙΔΙΚΗ ΠΕΡΙΠΤΩΣΗ: 6 -> 8 ΚΙΤΡΙΝΟ ---
    if strcmp(u, '6') && strcmp(v, '8')
        edge_colors(i, :) = [1, 1, 0]; % Yellow
        continue; % Πηγαίνουμε στην επόμενη ακμή, αγνοώντας τα παρακάτω
    end

    % --- ΕΙΔΙΚΗ ΠΕΡΙΠΤΩΣΗ: 6 -> 9 ΚΙΤΡΙΝΟ ---
    if strcmp(u, '6') && strcmp(v, '9')
        edge_colors(i, :) = [1, 1, 0]; % Yellow
        continue; % Πηγαίνουμε στην επόμενη ακμή, αγνοώντας τα παρακάτω
    end

    % --- ΕΙΔΙΚΗ ΠΕΡΙΠΤΩΣΗ: 6 -> 9 ΚΙΤΡΙΝΟ ---
    if strcmp(u, '9') && strcmp(v, 't')
        edge_colors(i, :) = [1, 1, 0]; % Yellow
        continue; % Πηγαίνουμε στην επόμενη ακμή, αγνοώντας τα παρακάτω
    end
    
    % Ψάχνουμε στα δεδομένα
    for j = 1:size(raw_data, 1)
        if strcmp(raw_data{j, 1}, u) && strcmp(raw_data{j, 2}, v)
            cost = raw_data{j, 4};
            % Αν είναι "ανάποδη" -> Γίνεται LIGHT GREEN
            if cost < 0 || strcmp(v, 's') || strcmp(u, 't')
                edge_colors(i, :) = [0.4, 1, 0.4]; 
            end
            break;
        end
    end
end
h.EdgeColor = edge_colors; % Εφαρμογή χρωμάτων στις γραμμές

% --- FIXED POSITIONS (FIXΓΙΑ ΠΑΛΙΟΤΕΡΟ MATLAB) ---
% Παίρνουμε τα ονόματα από το G.Nodes.Name που είναι πιο ασφαλές
node_names = G.Nodes.Name; 

for k = 1:numnodes(G)
    % Βρίσκουμε ποιος κόμβος είναι (π.χ. 's', '1', κλπ)
    current_name = node_names{k};
    
    switch current_name
        case 's',  h.XData(k) = 0;  h.YData(k) = 3;
        case '1',  h.XData(k) = 1;  h.YData(k) = 1;
        case '2',  h.XData(k) = 1.5;  h.YData(k) = 5;
        case '3',  h.XData(k) = 2;  h.YData(k) = 3;
        case '4',  h.XData(k) = 3;  h.YData(k) = 0;
        case '5',  h.XData(k) = 3.5;  h.YData(k) = 6;
        case '6',  h.XData(k) = 4;  h.YData(k) = 4;
        case '7',  h.XData(k) = 5;  h.YData(k) = 1.3;
        case '8',  h.XData(k) = 6.5;  h.YData(k) = 3;
        case '9',  h.XData(k) = 7;  h.YData(k) = 5;
        case '10', h.XData(k) = 8;  h.YData(k) = 1;
        case 't',  h.XData(k) = 9;  h.YData(k) = 3;
    end
end

% ΥΠΟΛΟΓΙΣΜΟΣ ΤΕΛΙΚΟΥ ΚΟΣΤΟΥΣ 

c1 = 61 * 72;
c2 = 67 * 24;
c3 = 87 * 96;
c4 = 101 * 24;
c5 = 104 * 48;
c6 = 118 * 24;

total_f = 72 + 24 + 96 + 24 + 48 + 24 ;
total_c = c1 + c2 + c3 + c4 + c5 + c6 ;

fprintf(' Συνολική Ροή: %d μονάδες\n', total_f);
fprintf(' Ελάχιστο Κόστος: %d\n', total_c);


