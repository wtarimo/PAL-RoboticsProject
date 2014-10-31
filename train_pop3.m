function training = train_pop3()
training.train = @train;

function output = train(pop,count)
global fid_pop; fid_pop = fopen('pop.txt','wt');
global fid_bestfit; fid_bestfit = fopen('bestfits.txt','wt');
global fid_avrgfit; fid_avrgfit = fopen('avrgfits.txt','wt');
global fid_bestinds; fid_bestinds = fopen('bestinds.txt','wt');
output = train2(pop,count);

function output = train2(pop,count)
cam = camera();
fit = fitness();
myga = ga();
gbyg = genebygene();
state = robot_state();
global same_count;
global ind_per_pop;
global generations;
global temp;
global fid_bestfit;
global fid_avrgfit;
global fid_bestinds;
done = 0;
while ~done
    same_count = 0;
    if count < 0
        fclose(fid_bestfit);
        fclose(fid_avrgfit);
        fclose(fid_bestinds);
        fclose(fid_pop);
        done=1;
        output = pop;
    else
        fit_list = fit.evaluate(pop);
        generation = generations - count;
        test_gen = mod(generation,10)==0;
            
        %Find actual fits from population tests on robot
        if test_gen
            pause on;
            activations = cam.prepare_robot();
            pause(activations + 4);
            activations = cam.prepare_robot();
            pause(activations + 4);
            actual_fits = cellfun(@get_actual_fit,pop);
            bias_list = actual_fits ./ fit_list;
            bias_list(isnan(bias_list))=0;
            pop = cellfun(@mypop.set_bias,pop,num2cell(bias_list),'UniformOutput',false);
            fit_list = actual_fits;
            
        %Calculate simulation fitness
        else
            fit_list = cellfun(@mypop.get_bias,pop).*fit_list;
        end
        fit_list(isnan(fit_list))=0;
        best_fits = find(fit_list==max(fit_list));
        best_index = best_fits(1);
        
        %Save evolution data to files, pop best and pop average fitness
        a = (mod(generation,10)==0 || test_gen);
        %b = ((generation > 99) && (generation < 300) && mod(generation,20)==0);
        %c = ((generation > 299) && (generation < 800) && mod(generation,50)==0);
        %d = (generation > 799 && mod(generation,100)==0);
        %if (a || b || c || d)
        if (a)
            disp(generation)
            bestfit = fit_list(best_index);
            best_ind = pop{best_index};
            avrg = (sum(fit_list)/ind_per_pop);
            fprintf(fid_bestinds,'%s%s %s %s','{',cell2str(best_ind{1}),cell2str(best_ind{2}),cell2str(best_ind{3}));
            fprintf(fid_bestinds,' %s %s',cell2str(best_ind{4}),cell2str(best_ind{5}));
            fprintf(fid_bestinds,'%s\n','}');
            fprintf(fid_bestfit,'%s\n',num2str(bestfit));
            fprintf(fid_avrgfit,'%s\n',num2str(avrg));
            printpop(pop);
        end 
        if min(fit_list)<=0
            fit_list = fit_list - min(fit_list) + 1;
        end
        sum_fits = cumsum(fit_list);
        total_fit_int = sum(fit_list);
        new_popa = myga.evolve(pop,sum_fits,total_fit_int,best_index,1);
        new_popb = [new_popa(1) gbyg.gene_by_gene_pop(new_popa(2:end))];
        pop =  cellfun(@check_lengths,new_popb,'UniformOutput',false);
        state.set_temp(count,generations);
        state.set_prob_of_mutate(temp,same_count);
        count = count - 1;
    end
end 

function output = get_actual_fit(ind)
gate = gates();
cam = camera();

gate.new_gate(ind);
pause on;
location1 = cam.find_robot();
disp('Location 1')
system('new_gate.bat');
pause(15);
location2 = cam.find_robot();
disp('Location 2')
distance = cam.get_distance(location1(1:2),location2(1:2));
activations = cam.prepare_robot();
pause(activations + 4);
activations = cam.prepare_robot();
pause(activations + 4); 
if (isnan(distance) || distance > 3000 || distance < -100)
    distance = get_actual_fit(ind);
end
output = distance;

function output = check_lengths(ind)
mypop = pop_generation();
if sum(cellfun(@mypop.get_moves,mypop.get_loop(ind))) <= 0
    output = mypop.make_random_ind();
else
    output = ind;
end

function display_list(in_list)
if ~isempty(in_list)
    disp(in_list(1));
    disp('');
    display_list(in_list(2:end));
end