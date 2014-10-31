function printpop(pop)
global fid_pop;
fprintf(fid_pop,'%s','pop = {');
for i=1:length(pop)
    fprintf(fid_pop,'%s%s %s %s','{',cell2str(pop{i}{1}),cell2str(pop{i}{2}),cell2str(pop{i}{3}));
    fprintf(fid_pop,' %s %s',cell2str(pop{i}{4}),cell2str(pop{i}{5}));
    fprintf(fid_pop,'%s','} ');
end
fprintf(fid_pop,'%s\n','};');
