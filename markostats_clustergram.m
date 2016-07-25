function [HANDLE,CLUSTER_COLORS]=markolab_clustergram(DATA,LINKAGE,DIST,C,varargin)
%
%
%
%
%
%

HANDLE=[];
CLUSTER_COLORS=[];

nparams=length(varargin);
trials=[];
data_t=[];
cluster_colors=[];

if mod(nparams,2)>0
	error('Parameters must be specified as parameter/value pairs');
end

% just in case add the hot colormap at the end

for i=1:2:nparams
	switch lower(varargin{i})
		case 'trials'
			trials=varargin{i+1};
		case 'data_t'
			data_t=varargin{i+1};
		case 'cluster_colors'
			cluster_colors=varargin{i+1};
		case 'ax'
			ax=varargin{i+1};
		end
end


clustern=length(unique(C));
clusters=unique(C);

leaf_order=optimalleaforder(LINKAGE,DIST);

imagesc(data_t,[1:length(C)],DATA(:,leaf_order)');


colormap(parula);
axis xy;
ylabel('Trial');
xlabel('Time (s)');
box off;
dend_dist=.01;
dend_width=.15;
cbar_dist=.1;
cbar_width=.03;

hold on;

colors=[1 0 0; 0 1 0; 0 0 0];
%colors=[1 .7 .25;1 0 1;.9 .9 .9];
tpoint=xlim();
tpoint=tpoint(end);
edgecolor='none';
%ax=findall(gcf,'type','axes');
set(ax(end),'tickdir','out');

if ~isempty(trials)
	for i=1:length(C)
		if any(trials.fluo_include.daf==leaf_order(i))
			fill([tpoint tpoint-.05 tpoint-.05 tpoint],[i+.5 i+.5 i-.5 i-.5],'k-',...
				'facecolor',colors(1,:),'edgecolor','none');
		elseif any(trials.fluo_include.other==leaf_order(i))
			fill([tpoint tpoint-.05 tpoint-.05 tpoint],[i+.5 i+.5 i-.5 i-.5],'k-',...
				'facecolor',colors(2,:),'edgecolor','none');
		else
			fill([tpoint tpoint-.05 tpoint-.05 tpoint],[i+.5 i+.5 i-.5 i-.5],'k-',...
				'facecolor',colors(3,:),'edgecolor','none');
		end
	end
end

%clims=get(gca,'clim');
pos=get(ax(end),'position');
set(ax(end),'Position',[pos(1) pos(2)+cbar_dist+cbar_width pos(3) pos(4)-cbar_dist-cbar_width]);
hc = colorbar('location','southoutside','position',...
	[pos(1) pos(2) pos(3) cbar_width],'fontsize',10);

for i=1:length(ax)
	i
	pos=get(ax(i),'position')
	set(ax(i),'position',[pos(1) pos(2) pos(3)-dend_width-dend_dist pos(4)]);
end

pos=get(hc,'position');
set(hc,'position',[pos(1) pos(2) pos(3)-dend_width-dend_dist pos(4)]);

linkaxes(ax,'x');
if ~isempty(data_t)
	xlim([data_t(1) data_t(end)]);
end

newpos=get(ax(end),'position');
ax(end+1)=axes('position',[newpos(1)+newpos(3)+dend_dist newpos(2) dend_width newpos(4)]);

if clustern>2
	HANDLE=dendrogram(LINKAGE,0,'reorder',leaf_order,'orientation','right','colorthreshold',LINKAGE(end-clustern+2,3)-eps);

	% get the cluster colors
	
	line_colors_cell=get(HANDLE,'color');
	line_colors=cell2mat(line_colors_cell);
	[~,tmp]=unique(LINKAGE(:,1:2)','first');
	tmp=ceil(tmp/2);
	line_colors=line_colors(tmp(leaf_order),:); % re-orders by leaf order

	[uniq_colors,~,color_idx]=unique(line_colors,'rows','first');

	for i=1:size(uniq_colors,1)

		% get cluster idx for each color
		
		% get first color_idx from each cluster
		
		tmp2=leaf_order(min(find(color_idx==i))); % maps color back to original order
		%tmp2=tmp(leaf_order(min(find(color_idx==i))));

		for j=1:clustern
			if any(tmp2==find(C==clusters(j)))
				CLUSTER_COLORS=[CLUSTER_COLORS;[uniq_colors(i,:) clusters(j) color_idx(i)]];
			end
		end
	
	end

	if ~isempty(CLUSTER_COLORS)
		CLUSTER_COLORS=sortrows(CLUSTER_COLORS,4);
	end

	for i=1:size(CLUSTER_COLORS,1)
		if CLUSTER_COLORS(i,1:3)==[0 0 0]
			CLUSTER_COLORS(i,:)=[];
			break;
		end
	end

	% recolor if user provides colors

	if ~isempty(cluster_colors)
		for i=1:size(CLUSTER_COLORS,1)
			h1=findobj(HANDLE,'flat','color',CLUSTER_COLORS(i,1:3));
			set(h1,'color',cluster_colors(i,:));
			CLUSTER_COLORS(i,1:3)=cluster_colors(i,:);
		end
	end

else
	HANDLE=dendrogram(LINKAGE,0,'reorder',leaf_order,'orientation','right');
	CLUSTER_COLORS=[];
end

%set(h,'linewidth',1,'color','k');
set(ax(end),'ytick',[],'tickdir','out','ylim',[1 length(C)]);
xlabel('Euclidean distance');


