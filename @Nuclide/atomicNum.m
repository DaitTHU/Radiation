function [Z, A, N, X] = atomicNum(AX)
%{
% AUTHOR: Dait
% ATOMIC_NUM:
% INPUT:
%     AX: symbol, e.g. "222Rn" or "Rn-222", even "222rn"
% OUTPUT:
%     Z, A, N: atomic numbers
%     X: exactly the X of AX input by user
%}
arguments
    AX (:, 1) string
end
if ischar(AX)
    % e.g. '137Cs'
    AX = string(AX);
end
% X: Z x 1 string
X = extract(AX, lettersPattern);
% element: 118 x 1 string
[Z, ~] = find(upper(Material.element.symbol) == upper(X'));
assert(all(size(X) == size(Z)), 'not an element!')
A = NaN(size(AX));
haveA = contains(AX, digitsPattern);
A(haveA) = str2double(extract(AX(haveA), digitsPattern));
N = A - Z;
end
