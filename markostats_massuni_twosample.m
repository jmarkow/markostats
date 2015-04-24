function [P TEST_STAT]=markostats_massuni_twosample(GROUP1,GROUP2,varargin)
%
%
%

% computes the difference between two groups alone each column, controlling
% for multiple comparisons via permutation

ncomparisons=size(GROUP1,2);
chk=size(GROUP2,2);

if ncomparisons~=chk
	error('The test requires that the matrices have the same number of columns (i.e. comparisons)');
end

n1=size(GROUP1,1);
n2=size(GROUP2,1);

P=ones(1,ncomparisons)*NaN;
TEST_STATS=ones(1,ncomparisons)*NaN;

for i=1:ncomparisons
	[P(i) TEST_STAT(i)]=test_stat(GROUP1(:,i),GROUP2(:,i));
end

end

function [P,TEST_STAT]=test_stat(GRP1,GRP2)
%
%

% compute the stat here

%[P,h,stats]=ranksum(GRP1,GRP2);
%TEST_STAT=stats.ranksum;

[~,P,~,stats]=ttest2(GRP1,GRP2,'Vartype','unequal');
TEST_STAT=stats.tstat;

end
