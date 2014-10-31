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
distance = cam.get_distance(location1(1:2),location2(1:2))
activations = cam.prepare_robot();
pause(activations + 7);
activations = cam.prepare_robot();
pause(activations + 7); 
if isnan(distance) || distance > 2700
    distance = get_actual_fit(ind);
end
output = distance;