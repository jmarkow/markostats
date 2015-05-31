function [P TEST_STAT PERMS] = markostats_perm_mc(DATAMAT1,DATAMAT2,varargin)
%
%
%

% computes the difference between two groups alone each column, controlling
% for multiple comparisons via permutation

nperms=500; % 1e3 recommended for p=.05 5e3 for p=.01

% take the lda projection of the data, and permutations of the groups

[ld,score1,score2]=markostats_lda(DATAMAT1,DATAMAT2);

% get the test statistic


TEST_STAT=abs(median(score1)-median(score2));

npool1=length(score1);
npool2=length(score2);

agg_pool=[score1(:);score2(:)];
nagg=npool1+npool2;

PERMS=zeros(1,nperms);

for i=1:nperms

	rndind=randperm(nagg);

	rnd1=agg_pool(rndind(1:npool1));
	rnd2=agg_pool(rndind(npool1+1:npool1+npool2));

	PERMS(i)=abs(median(rnd1)-median(rnd2));
end

P=mean(PERMS>TEST_STAT);
