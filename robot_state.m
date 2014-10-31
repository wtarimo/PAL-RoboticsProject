function robotstate = robot_state()
robotstate.reset_robot=@reset_robot;
robotstate.move_leg_v=@move_leg_v;
robotstate.move_leg_h=@move_leg_h;
robotstate.get_height_equiv_dist=@get_height_equiv_dist;
robotstate.set_temp=@set_temp;
robotstate.set_prob_of_mutate=@set_prob_of_mutate;

function reset_robot()
% resets all legs to the normal rest position
constants();
global robot;
robot(1:6,7)=0;
robot(1:6,1)=0;
    
function move_leg_v(leg,input)
% Moves the specified leg up or down as specified at the up/down rate 
%stored for that leg
global robot;
switch lower(input)
    case 'up'
        new_up = robot(leg,1)+robot(leg,4);
        if ((new_up > robot(leg,2)))
            robot(leg,1) = robot(leg,2);
        else
            robot(leg,1) = new_up;
        end
    case 'down'
        new_up = robot(leg,1)-robot(leg,4);
        if ((new_up < robot(leg,3)))
            robot(leg,1) = robot(leg,3);
        else
            robot(leg,1) = new_up;
        end
end
     
function change = move_leg_h(leg,input)
%Moves the specified leg forward or back as specified at the rate
%stored for that leg
global last_fwd_h;
global leg_start_h;
global robot;

switch lower(input)
    case 'back'
        if (last_fwd_h(leg) ~= 1)
            add_to_leg_start_h(leg);
        elseif (last_fwd_h(leg) == 1)
            last_fwd_h(leg) = 0;
            reset_leg_start_h(leg);
        end
        new_back = robot(leg,7)+ (robot(leg,9)*leg_start_h(leg));
       
        if (new_back > robot(leg,8))
            change = robot(leg,8) - robot(leg,7);
            robot(leg,7) = robot(leg,8);
        else
            change = new_back - robot(leg,7);
            robot(leg,7) = new_back;
        end
    case 'forward'
        if (last_fwd_h(leg) == 1)
            add_to_leg_start_h(leg);
        else
            last_fwd_h(leg) = 1;
            reset_leg_start_h(leg);
        end
        new_back = robot(leg,7)- (robot(leg,9)*leg_start_h(leg));
       
        if (new_back < 0)
            change = 0 - robot(leg,7);
            robot(leg,7) = 0;
        else
            change = new_back - robot(leg,7);
            robot(leg,7) = new_back;
        end
end

function add_to_leg_start_h(leg)
global leg_start_h;
leg_start_h(leg) = leg_start_h(leg)*2;
if (leg_start_h(leg) > 1)
    leg_start_h(leg) = 1;
end

function reset_leg_start_h(leg)
global leg_start_h;
leg_start_h(leg)=0.125;

function [distance] = get_height_equiv_dist()
dist = get_height_equiv_dist2();
if (dist < 1)
    distance = 1;
else
    distance = dist;
end

function [dist2] = get_height_equiv_dist2()
minrate = get_min_rate(1,100000);
minheight = get_min_height(1,100000)/20;
if (minrate < minheight)
    dist2 = minheight;
else
    dist2 = minrate;
end

function min_rate = get_min_rate(num,min)
global robot;
if (num > 5)
    min_rate = min;
else
    min1 = robot(num,4);
    min2 = robot(num,5);
    if (min1 < min2)
        min3 = min1;
    else
        min3 = min2;
    end
    if (min3 < min)
        min_rate = get_min_rate(num+1,min3);
    else
        min_rate = get_min_rate(num+1,min);
    end
end

function min_height = get_min_height(num,min)
global robot;
if (num > 5)
    min_height = min;
else
    min1 = robot(num,2) - robot(num,3);
    if (min1 < min)
        min_height = get_min_height(num+1,min1);
    else
        min_height = get_min_height(num+1,min);
    end
end

function set_temp(count,total_count)
global temp;
temp = round((count/total_count)*100);

function set_prob_of_mutate(temp,same_count)
global prob_of_mutate;
global ind_per_pop;
pom = 300 - temp - round((same_count/(sqrt(ind_per_pop)))*100);
if pom < 20
    prob_of_mutate = 20;
else
    prob_of_mutate = pom;
end