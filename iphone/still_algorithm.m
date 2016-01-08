b=0.3; %the distance between two cameras
G=2733; %the parameter to determine the depth of object, f=4.1mm,m=1.5um. 

%lower picture    
imL=imread('left150_b=30.jpg');
%figure,subplot(2,1,1);%imshow(imL);title('Lower Image after Adding Rectangular Trunk');impixelinfo;
im1=rgb2gray(imL);
im1=medfilt2(im1,[3 3]); %Median filtering the image to remove noise%

%upper picture
imR=imread('right150_b=30.jpg');
%subplot(2,1,2);%imshow(imR);title('upper ');impixelinfo;
im2=rgb2gray(imR);
im2=medfilt2(im2,[3 3]);%Median filtering the image to remove noise%

%lower camera for edge detection
BW1 = edge(im1,'sobel'); %finding edges 
%figure,subplot(2,1,1);imshow(BW1);title('lower');
%upper camera for edge detection
BW2 = edge(im2,'sobel'); %finding edges 
%subplot(2,1,2);imshow(BW2);title('upper');impixelinfo;

BW1 = bwareaopen(BW1,60);% BW2 = bwareaopen(BW,P) removes from a binary image all connected components (objects) that have fewer than P pixels,
%figure,subplot(2,1,1);imshow(BW1);title('lower');

BW2 = bwareaopen(BW2,60);% BW2 = bwareaopen(BW,P) removes from a binary image all connected components (objects) that have fewer than P pixels,
%subplot(2,1,2);imshow(BW2);title('upper');impixelinfo;

[tempx,tempy,l]=find(BW1==1);
        a1=[tempx,tempy];
        [b1,i]=min(a1,[],1);
        left1=[a1(i(1,2),2),a1(i(1,2),1)];
        [c1,i]=max(a1,[],1);
        right1=[a1(i(1,2),2),a1(i(1,2),1)];
        bc1=right1(1,1)-left1(1,1);
        bb1 = [tempy(1,1),tempx(1,1),bc1,bc1];


%figure,subplot(2,1,1);imshow(BW1);title('Lower Image after Adding Rectangular Trunk');impixelinfo
    %hold on
    %rectangle('Position',bb1,'EdgeColor','r','LineWidth',2);
    %hold off
   
 [tempx,tempy,l]=find(BW2==1);
        a2=[tempx,tempy];
        [b2,i]=min(a2,[],1);
        left2=[a2(i(1,2),2),a2(i(1,2),1)];
        [c2,i]=max(a2,[],1);
        right2=[a2(i(1,2),2),a2(i(1,2),1)];
        bc2=right2(1,1)-left2(1,1);
        bb2 = [tempy(1,1),tempx(1,1),bc2,bc2];
%subplot(2,1,2);imshow(BW2);title('Upper Image after Adding Rectangular Trunk');impixelinfo;
    
 %hold on
 %rectangle('Position',bb2,'EdgeColor','b','LineWidth',2);
  %  hold off
     
     %depth and size calculation 
            d=abs(left1(1,1)-left2(1,1))+abs(right1(1,1)-right2(1,1));%parallax coefficient in pixcels
            D=2*b*(G)/(1*d); D=round(D*100)/100;
            L=2*b*.5*(bc2+bc1)/(1*d);

       
            
            
      figure;imshow(imR);
      D=calculate(D);
      if b==0.12
        L=20+D*1.05
      else
        L=20+D*0.61
      end
      hold on;
        %rectangle('Position',bb2,'EdgeColor','r','LineWidth',2)
        a=text(bc(1)-80,bc(2)-25, strcat('Depth(m): ', num2str(D), '    Length(cm): ', num2str(L)));
         set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 16, 'Color', 'black');
      hold off
            
            
            