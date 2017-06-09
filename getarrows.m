function [finallines,longest,newcenter] = getarrows(I,edges,center,maxxy,minxy,debug)
    %convert image to gray
    I = rgb2gray(I);
    I = imadjust(I);
    
    %get hough lines
    [H, theta, rho] = hough(edges);
    peaks = houghpeaks(H,70,'threshold',ceil(0.01*max(H(:))));
    lines = houghlines(edges, theta, rho, peaks,'FillGap',15,'MinLength',40);
    
    %show for testing
    if debug
        figure;
        subplot(1,3,1);
        imshow(I), hold on
        title('hough lines with center detected');
        scatter(center(1),center(2));
    end
    
    min_len = 0.1*min(maxxy - minxy);
    max_len = 0;
    newlines = struct('point1',{},'point2',{});
    i=1;
    newcenter = zeros(1,2);
    %get closer center
    for k = 1:length(lines)
        D1 = [lines(k).point1;center];
        D2 = [lines(k).point2;center];
        if xor(pdist(D1) <= min_len , pdist(D2) <= min_len)
            i = i+1;
            if(pdist(D1) <= min_len)
                newcenter = newcenter + lines(k).point1;
            else
                newcenter = newcenter + lines(k).point2;
            end
        end
        xy = [lines(k).point1; lines(k).point2];
        len = norm(lines(k).point1 - lines(k).point2);
        if ( len > max_len)
          max_len = len;
          longestxy = xy;
          longest = lines(k);
        end
        if debug
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
        end
    end
    
    %show for testing
    if debug
        %longest line
        plot(longestxy(:,1),longestxy(:,2),'LineWidth',2,'Color','red');
    end
    
    %new center
    newcenter = newcenter/(i-1);
    min_len = min_len/2;
    max_len = 0;
    i=1;
    
    %show for testing
    if debug
        subplot(1,3,2);
        imshow(I), hold on
        title('Hough Lines with closer center');
        scatter(newcenter(1),newcenter(2));
    end
    
    %lines close to the new center
    for k = 1:length(lines)
        D1 = [lines(k).point1;newcenter];
        D2 = [lines(k).point2;newcenter];
        if xor(pdist(D1) <= min_len , pdist(D2) <= min_len)
            newlines(i).point1 = lines(k).point1;
            newlines(i).point2 = lines(k).point2;
            if(pdist(D1) <= min_len)
                newlines(i).point1 = newlines(i).point2
                newlines(i).point2 = newcenter;
            else
                newlines(i).point2 = newcenter;
            end
            xy = [newlines(i).point1; newlines(i).point2];
            len = norm(newlines(i).point1 - newlines(i).point2);
            if ( len > max_len)
              max_len = len;
              longestxy = xy;
              longest = newlines(i);
            end
            if debug
                plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
            end
            i=i+1;
        end
    end
    
    %show for testing
    if debug
        %longest line
        plot(longestxy(:,1),longestxy(:,2),'LineWidth',2,'Color','red');
    end
    
    %get the final lines and combine close ones based on angel
    finallines = struct('point1',{},'point2',{});
    
    %show for testing
    if debug
        subplot(1,3,3);
        imshow(I), hold on
        title('final arrows with merging detected');
        scatter(newcenter(1),newcenter(2));
    end
    
    max_len = 0;
    i=1;
    for k = 1:length(newlines)
        maxline = newlines(k);
        for j = 1:length(newlines)
            v1 = newlines(k).point2 - newlines(k).point1;
            v2 = newlines(j).point2 - newlines(j).point1;
            v1 = [v1 0];
            v2 = [v2 0];
            angle = atan2d(norm(cross(v1,v2)),dot(v1,v2)) + 360*(norm(cross(v1,v2))<0);
            check = true;
            for x=1:length(finallines)
                if isequal(newlines(k),finallines(x)) || isequal(newlines(j),finallines(x))
                    check = false;
                end
            end
            if angle <= 15 && k ~= j
                if ~check
                    break
                end
                D1 = [maxline.point1;maxline.point2];
                D2 = [newlines(j).point1;newlines(j).point2];
                if pdist(D1) < pdist(D2)
                    maxline = newlines(j);
                end
            end
        end
        if check
            finallines(i) = maxline;
            
            xy = [finallines(i).point1; finallines(i).point2];
            len = norm(finallines(i).point1 - finallines(i).point2);
            if ( len > max_len)
                max_len = len;
                longestxy = xy;
                longest = finallines(i);
            end
            %show for testing
            if debug
                plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
            end
            i = i+1; 
        end
    end
    if debug
        %longest line
        plot(longestxy(:,1),longestxy(:,2),'LineWidth',2,'Color','red');
    end
end