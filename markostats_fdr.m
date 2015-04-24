function [P_CUT]=markostats_perm_mc(P,Q,METHOD)
% false discovery rate, method specifies (1) standard step-up or (2) no dependence assumption

if nargin<3
	METHOD=1;
else
	METHOD=2;
end

P=sort(P(:));
np=length(P);
ivec=(1:np)';

if METHOD==1
	P_CUT=P(max(find(P<=ivec/np*Q)));
else
	tmp=sum(1./(1:np));
	P_CUT=P(max(find(P<=ivec/np*Q/tmp)));
end

