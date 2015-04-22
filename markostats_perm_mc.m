function [P TEST_STAT PERM_MAX]=markostats_perm_mc(GROUP1,GROUP2,varargin)
%
%
%

% computes the difference between two groups alone each column, controlling
% for multiple comparisons via permutation

nperms=1000; % 1e3 recommended for p=.05 5e3 for p=.01
ncomparisons=size(GROUP1,2);
test_stat=@(GRP1,GRP2) abs(mean(GRP1)-mean(GRP2))./std([GRP1(:);GRP2(:)]);


chk=size(GROUP2,2);

if ncomparisons~=chk
	error('The test requires that the matrices have the same number of columns (i.e. comparisons)');
end

n1=size(GROUP1,1);
n2=size(GROUP2,1);

idx1=repmat([1:ncomparisons],[n1 1]);
idx2=repmat([1:ncomparisons],[n2 1]);

% reshape the matrices for simpler permutation

GROUP1=GROUP1(:);
idx1=idx1(:);
idx1n=n1*ncomparisons;

GROUP2=GROUP2(:);
idx2=idx2(:);
idx2n=n2*ncomparisons;

PERM_MAX=zeros(1,nperms);
P=ones(1,ncomparisons)*NaN;
TEST_STATS=ones(1,ncomparisons)*NaN;

parfor i=1:nperms
	
	% permute each set of labels

	rnd1=idx1(randperm(idx1n));
	rnd2=idx2(randperm(idx2n));
	
	tmp=zeros(1,ncomparisons);
	for j=1:ncomparisons

		% get the difference in the test_stat of choice

		tmp(j)=test_stat(GROUP1(rnd1==j),GROUP2(rnd2==j));

	end

	PERM_MAX(i)=max(tmp);

end

parfor i=1:ncomparisons
	TEST_STAT(i)=test_stat(GROUP1(idx1==i),GROUP2(idx2==i));
	P(i)=mean(PERM_MAX>TEST_STAT(i));
end
