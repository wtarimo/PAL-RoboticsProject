pause on;
global point;
gen = pop_generation();
pop = {{3676 9496 [0 0] {[6 910] [5 14] [6 3185] [5 49]} 1}};
global num_moves; num_moves = 400;
gate = gates();
cam = camera();
fits = zeros(1,length(pop));
for i=1:length(pop)
    if i == 1
        activations = cam.prepare_robot();
        pause(activations + 1);
        activations = cam.prepare_robot();
        pause(activations + 1); 
    end
    gate.new_gate(pop{i});
    location1 = cam.find_robot();
    disp('Location 1')
    system('new_gate.bat');
    pause(13);
    location2 = cam.find_robot();
    disp('Location 2')
    distance = cam.get_distance(location1(1:2),location2(1:2))
    if i ~= length(pop)
        activations = cam.prepare_robot();
        pause(activations + 1);
        activations = cam.prepare_robot();
        pause(activations + 1);
    end
    fits(i) = distance;
end
pause off;
fits