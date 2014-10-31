function fit = evaluate_ind(ind)

coord = coord_inhib();
state = robot_state();
state.reset_robot();
fit = fitness();
global num_moves; num_moves = 400;
ind = coord.combine_ind(ind);

set(0,'RecursionLimit',1000)
constants();
global robot; robot=load('robot.txt');
global leg_height_equiv_dist; 
leg_height_equiv_dist = state.get_height_equiv_dist();
global prob_of_mutate; prob_of_mutate = 300;
global start; start = 0;
global temp; temp = 0;
global start_length; start_length = 1;
global loop_length; loop_length = 12;
    
fit = fit.get_ind_fitness(ind,ind);
