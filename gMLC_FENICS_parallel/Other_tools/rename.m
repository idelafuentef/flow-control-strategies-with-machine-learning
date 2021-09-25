olds = 9:12;
No = numel(olds);
New = 20;

news=New:(New+No-1);
for p=1:No
mlc.load(['GMFM_gMLC_E3_',num2str(olds(p))]);
mlc.reName(['GMFM_gMLC_E3_',num2str(news(p))]);
end
