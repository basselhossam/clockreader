%read Images
imageurl = '11.jpg';
I = imread(imageurl);

debug = true;

[edges,center,maxxy,minxy] = edges_center(I,debug);

[arrowslines,longest,center] = getarrows(I,edges,center,maxxy,minxy,debug);

if isempty(arrowslines)
    info = imfinfo(imageurl);
    center(1) = info.Width/2;
    center(2) = info.Height/2;
    maxxy = [info.Width info.Height];
    minxy = [0 0];
    [arrowslines,longest,center] = getarrows(I,edges,center,maxxy,minxy,debug);
end
finallines = struct('point1',{},'point2',{});
if length(arrowslines) == 1
    newlongest = arrowslines(1);
    finallines(1) = arrowslines(1);
    finallines(2) = arrowslines(1);
end
max_len = 0;
j=1;
if length(arrowslines) == 3
    for i = 1 : length(arrowslines)
        if ~isequal(arrowslines(i),longest)
            finallines(j) = arrowslines(i);
            len = norm(finallines(j).point1 - finallines(j).point2);
            if ( len > max_len)
              max_len = len;
              newlongest = arrowslines(i);
            end
            j = j+1;
        end
    end
elseif length(arrowslines) == 2
    finallines = arrowslines;
    newlongest = longest;
end
if isequal(finallines(1),newlongest)
    vminute = finallines(1).point2 - finallines(1).point1;
    vhour = finallines(2).point2 - finallines(2).point1;
else
    vhour = finallines(1).point2 - finallines(1).point1;
    vminute = finallines(2).point2 - finallines(2).point1;
end
vminute = [vminute 0];
vhour = [vhour 0];
v2 = [0 1 0];
angle1 =  atan2d(norm(cross(vminute,v2)),dot(vminute,v2)) + 360*(norm(cross(vminute,v2))<0);
angle2 =  atan2d(norm(cross(vhour,v2)),dot(vhour,v2)) + 360*(norm(cross(vhour,v2))<0);

if vminute(1) > 0
    angle1 = 360 - angle1;
end

if vhour(1) > 0
    angle2 = 360 -angle2;
end

minute = (angle1/6) + 60*(angle1/6 < 0);
hour = floor(angle2/30) + 12*(floor(angle2/30) <= 0);

disp(['The Clock is probably ',num2str(hour),':',num2str(minute)])