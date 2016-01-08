frameinterval=24; %the interval between consecutive images
b=0.12; %the distance between two cameras
G=230; %the parameter to determine the depth of object, we roughly take G=230

%read lower camera
readerobj = VideoReader('lower40.avi', 'tag', 'myreader1');   % Construct a multimedia reader object associated with file 'xylophone.mpg' with
       % user tag set to 'myreader1'
 vidFrames = read(readerobj);% Read in all video frames.
 numFrames = get(readerobj, 'NumberOfFrames');% Get the number of frames.
    for i=1:frameinterval:numFrames
       mov(i).cdata = vidFrames(:,:,:,i);
       strtemp=strcat('lower',int2str(i),'.','jpg');%transform every frame to the jpg format 
       imwrite(mov(i).cdata,strtemp,'jpg');
    end
%read upper camera
readerobj = VideoReader('upper40.avi', 'tag', 'myreader1');   % Construct a multimedia reader object associated with file 'xylophone.mpg' with
       % user tag set to 'myreader1'
 vidFrames = read(readerobj);% Read in all video frames.
 numFrames = get(readerobj, 'NumberOfFrames');% Get the number of frames.
    for i=1:frameinterval:numFrames
       mov(i).cdata = vidFrames(:,:,:,i);
       strtemp=strcat('upper',int2str(i),'.','jpg');%transform every frame to the jpg format 
       imwrite(mov(i).cdata,strtemp,'jpg');
    end
    %lower image after motion detection and edge detection
    im1=imread('lower1.jpg');%subplot(2,1,1);imshow(im1);title('lower image at first frame ');
    im2=imread('lower49.jpg');%subplot(2,1,2);imshow(im2);title('lower image at second frame');

    im3=im2-im1; %take the difference of the two consecutive image
    %figure;imshow(im3,[]);title('Subtraction of Two Consecutive Images')
    
    im3=rgb2gray(im3);  
    im3=medfilt2(im3,[3 3]); %filter out some noises
    
    BW1=edge(im3,'prewitt'); %subplot(2,1,1);imshow(BW1,[]);title('Soble Edge Detection without Gaussian Filter for lower image')
    BW1 = bwareaopen(BW1,30);%subplot(2,1,2);imshow(BW1,[]);title('Soble Edge Detection with Gaussian Filter for lower image')
    
   %upper image after motion detection and edge detection
    im5=imread('upper1.jpg');%subplot(2,1,1);imshow(im1);title('upper image at first frame');
    im6=imread('upper49.jpg');%subplot(2,1,2);imshow(im2);title('upper image at second frame');

    im4=im6-im5;
    %figure;imshow(im4,[]);title('Subtraction of Two Consecutive Images')
    
    im4=rgb2gray(im4); %take the difference of thetwo consecutive image
    im4=medfilt2(im4,[3 3]); %filter out some noises
    
    BW2=edge(im4,'prewitt'); %subplot(2,1,1);imshow(BW2,[]);title('Soble Edge Detection without Gaussian Filter for upper image')
    BW2 = bwareaopen(BW2,30);%subplot(2,1,2);imshow(BW2,[]);title('Soble Edge Detection with Gaussian Filter for upper image')
    
    %rectangular trunk for lower image
    [imx,imy]=size(BW1);
    L1 = bwlabel(BW1,8);% Calculating connected components
    mx2=max(max(L1));%the maximum value of the connected components for lower image


    stats1 = regionprops(L1, 'BoundingBox', 'Centroid');
    %figure;subplot(2,1,1);
    %imshow(BW1);impixelinfo;title('Add Rectangular Trunk for Moving Fish for lower image ')
    
    %hold on
    temp1=0,
    %This is a loop to bound the  objects in a rectangular box.
    for object1 = 1:length(stats1)
        bb1 = stats1(object1).BoundingBox; %stats(5).BoundingBox(1,3)the length of the rectangular.
        bc1 = stats1(object1).Centroid;
        %rectangle('Position',bb1,'EdgeColor','b','LineWidth',2)
        %plot(bc1(1),bc1(2), '-m+')
        area1=stats1(object1).BoundingBox(1,3)*stats1(object1).BoundingBox(1,4);
        if area1>temp1
            m1=object1; mxarea1=area1;
             temp1=area1;
        else
        end
        
    end
    
    %hold off
   
    %rectangular trunk for upper image
    
    [imx,imy]=size(BW2);
    L2 = bwlabel(BW2,8);% Calculating connected components
    mx2=max(max(L2));%the maximum value of the connected components for upper image


    stats2 = regionprops(L2, 'BoundingBox', 'Centroid');
    %subplot(2,1,2);
    %imshow(BW2);impixelinfo;title('Add Rectangular Trunk for Moving Fish for upper image ')
    
    %hold on
    temp2=0;
    %This is a loop to bound the  objects in a rectangular box.
    for object2 = 1:length(stats2)
        bb2 = stats2(object2).BoundingBox; %stats(5).BoundingBox(1,3)the length of the rectangular.
        bc2 = stats2(object2).Centroid;
        %rectangle('Position',bb2,'EdgeColor','r','LineWidth',2)
        %plot(bc2(1),bc2(2), '-m+');
        area2=stats2(object2).BoundingBox(1,3)*stats2(object2).BoundingBox(1,4);
        if area2>temp2
            m2=object2;mxarea2=area2;
            temp2=area2;
        else
        end
        
    end
    
    %hold off
       
    
        
        
    
    %depth and size calculation 
    d=abs(stats2(m2).BoundingBox(1,2)-stats1(m1).BoundingBox(1,2));%parallax coefficient in pixcels-?v
    D=b*(G)/(1*d);%apply f/m=205 in this case,D=(b¡Áf)/(?v*m) 
    L=b*.5*(stats1(m1).BoundingBox(1,3)+stats2(m2).BoundingBox(1,3))/(1*d);%L=(b*u)/d=(b*?u)/?v
    
    if (mxarea1> mxarea2)  
    figure;imshow(im1);
     hold on;
      bc = stats1(m1).Centroid;
      bb2 = stats1(m1).BoundingBox
      rectangle('Position',bb2,'EdgeColor','r','LineWidth',2)
        a=text(bc(1)-150,bc(2)-35, strcat('Depth(m): ', num2str(D), '    Length(m): ', num2str(L)));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 18, 'Color', 'black');
        hold off
    else
      figure;imshow(im5);
     hold on;
      bc = stats2(m2).Centroid;
      bb2 = stats2(m2).BoundingBox
      rectangle('Position',bb2,'EdgeColor','r','LineWidth',2)
        a=text(bc(1)-150,bc(2)-35, strcat('Depth(m): ', num2str(D), '    Length(m): ', num2str(L)));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 18, 'Color', 'black');
        hold off
    end