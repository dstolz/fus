function mask = create_mask(obj,threshold)

if nargin < 2 || isempty(threshold), threshold = 2; end

gw = gausswin(5);

D = std(obj.Data,0,3);
m = max(abs(D(:)));
D = conv2(gw',gw,D,'same');
D = D ./ max(abs(D(:))) .* m;

mask = D >= threshold;

