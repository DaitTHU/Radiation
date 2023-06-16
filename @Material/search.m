function search(query)
% AUTHOR: Dait
% search by query
arguments
    query (1, 1) string
end
E = fieldnames(Material.element);
C = fieldnames(Material.compound);
disp('element:')
disp(E(contains(upper(E), upper(query))))
disp('compound:')
disp(C(contains(upper(C), upper(query))))
end