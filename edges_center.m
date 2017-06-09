function [edges,center,maxxy,minxy] = edges_center(I,debug)
    %convert image to gray
    I = rgb2gray(I);
    I = imadjust(I);
    
    %show for testing
    if debug
        figure;
        subplot(2,3,1);
        imshow(I);
        title('Orignal Image');
    end
    
    %get edges using sobel
    ImB=medfilt2(I,[5 5]);
    edges = edge(ImB,'sobel');
    
    %show for testing
    if debug
        subplot(2,3,2);
        imshow(edges);
        title('Sobel Edges');
    end
    
    se = strel('disk',10);
    EnhancedEdges = imdilate(edges, se);    
    EdgeClean = bwareaopen(EnhancedEdges,1e3);
    
    %show for testing
    if debug
        subplot(2,3,3);
        imshow(EdgeClean);
        title('strel(edges)');
    end
    
    %get boundaries to get estimated center
    [B,L,N] = bwboundaries(EdgeClean,8,'noholes');
    
    %show for testing
    if debug
        subplot(2,3,4);
        imshow(I); hold on;
        title('Image boundaries');
        for k=1:length(B),
           boundary = B{k};
           if(k > N)
             plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
           else
             plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
           end
        end
    end
    
    [maxcellsize,maxcellind] = max(cellfun(@numel,B));
    maxxy = max(B{maxcellind},[],1);
    minxy = min(B{maxcellind},[],1);
    
    %center (y,x)
    center = (maxxy + minxy) / 2;
    temp = center(2);
    center(2) = center(1);
    center(1) = temp;
    
    if debug
        subplot(2,3,5);
        imshow(I); hold on;
        scatter(center(1),center(2));
        title('detected center');
    end
end