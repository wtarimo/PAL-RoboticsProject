function cam = camera()
cam.find_robot = @find_robot;
cam.get_distance = @get_distance;
cam.prepare_robot = @prepare_robot;

function output = find_robot()
snapshot = imread('http://136.244.15.250/-wvhttp-01-/GetOneShot');
snapshot = imcrop(snapshot,[109 13 461 461]);
dim=size(snapshot);
y_dim=dim(1);
x_dim=dim(2);
rt = 60;
bt = 25;
gt = 20;
wt = 200;
%snapshot(26:28,390:392,1:3)= 0;
%snapshot(27,391,1:3)
coordinates = {[0 0] [0 0] [0 0] [0 0]};
for i=1:x_dim
    for j=1:y_dim
        r=snapshot(j,i,1);
        g=snapshot(j,i,2);
        b=snapshot(j,i,3); 
        if (b-g>bt) && (b-r>bt)
            %snapshot(j,i,1:3) = 0;
            coordinates{2} = [i j];
        elseif (r-g>rt) && (r-b>rt)
            %snapshot(j,i,1:3)= 0;
            coordinates{1} = [i j];
        elseif (g-r>gt) && (g-b>gt)
            coordinates{3} = [i j];
            %snapshot(j,i,1:3)= 0;
        elseif (r>wt && g>wt && b>wt)
            coordinates{4} = [i j];
            %snapshot(j,i,1:3)= 0;
        end
    end
end
%display_image(1,snapshot,'SnapShot');
output = coordinates; %{R B G W}

function output = prepare_robot()
global point;
gate = gates();
location = find_robot();

red = location{1};
blue = location{2};
if ((red(1)<30 && blue(1)>red(1)) || (red(1)>437 && blue(1)<red(1)) || (red(2)<30 && blue(2)>red(2)) || (red(2) > 437 && blue(2)<red(2)))
    pause on;
    system('moveback.bat');
    pause(4);
    location = find_robot();
   
elseif ((blue(1)<30 && red(1)>blue(1)) || (blue(1)>437 && red(1)<blue(1)) || (blue(2)<30 && red(2)>blue(2)) || (blue(2) > 437 && red(2)<blue(2)))
    pause on;
    system('moveforward.bat');
    pause(4);
    location = find_robot();
end

mid = [(location{1}(1)+location{2}(1))/2 (location{1}(2)+location{2}(2))/2];
points = {[0 0] [0 462] [462 0] [462 462]};
far = 0;
for i=1:4
    distance = sqrt((points{i}(1)-mid(1))^2 + (points{i}(2)-mid(2))^2);
    if distance >= far
        far = distance;
        point = points{i};
    end
end
a = sqrt((point(1)-location{1}(1))^2 + (point(2)-location{1}(2))^2);
b = sqrt((point(1)-location{2}(1))^2 + (point(2)-location{2}(2))^2);
c = sqrt((location{2}(1)-location{1}(1))^2 + (location{2}(2)-location{1}(2))^2);
angleA = ceil(abs((180/pi) * acos((b^2 + c^2 - a^2)/(2*b*c))));

%Distances from the right and left of robot to the point
rd = sqrt((location{4}(1)-point(1))^2 + (location{4}(2)-point(2))^2);
ld = sqrt((location{3}(1)-point(1))^2 + (location{3}(2)-point(2))^2);

if (rd >= ld)
    angleA = -angleA;
end
activations = gate.rotate_gate(angleA);
system('rotaterobot.bat');
output = activations;

function output = get_distance(pts1,pts2)
global point;
scale = 4.829224524027680; %mm/pxl
m1 = (pts1{2}(2) - pts1{1}(2))/(pts1{2}(1) - pts1{1}(1));
m2 = (-1.0)/m1;
mid2 = [(pts2{1}(1)+pts2{2}(1))/2 (pts2{1}(2)+pts2{2}(2))/2];
mid1 = [(pts1{1}(1)+pts1{2}(1))/2 (pts1{1}(2)+pts1{2}(2))/2];
far = sqrt((point(1)-mid1(1))^2 + (point(2)-mid1(2))^2);
dst2 = sqrt((point(1)-mid2(1))^2 + (point(2)-mid2(2))^2);
d = mid2(2) - (m2 * mid2(1));
c = mid1(2) - (m1 * mid1(1));
x = (d-c)/(m1 - m2);
y = (m1*x) + c;
if dst2 > far
    output = -scale * sqrt((x-mid1(1))^2 + (y-mid1(2))^2);
else
    output = scale * sqrt((x-mid1(1))^2 + (y-mid1(2))^2);
end

function display_image(figure_num, im, title_text)
% This function displays the image 'im' in Figure 'figure_num'
% and displays the title 'title_text'
figure( figure_num);
set( gcf, 'color', 'k' );
image( im );
axis image;
axis off;
title( title_text );
set(gcf, 'Units','pixels','Position',[100 100 size(im,2) size(im,1)] );
set(gca,'Position',[0 0 1 1]);