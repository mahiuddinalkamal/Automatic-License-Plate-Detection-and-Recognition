%%
clc
clear all
close all
%% 
template(1);
Im=imread(uigetfile('*.jpg'));
Im=imresize(Im,[400 NaN]); 
figure();imshow(Im);

I= im2double(rgb2gray(Im));             % rgb to gray
figure();imshow(I)

%% 
IS=kirschedge(I);
IS    = IS.^2;                          
figure;imshow(IS)

%% 
IS    = (IS-min(IS(:)))/(max(IS(:))-min(IS(:))); % Normalization
% figure();imshow(IS)
%% 
level = graythresh(IS);                 % Threshold Based on Otsu Method
IS    = im2bw(IS,level);
figure();imshow(IS)

%%
S     = sum(IS,2);                      % Edge Horizontal Histogram
% figure();plot(1:size(S,1),S)
% view(90,90)
%Plot
figure()
subplot(1,2,1);imshow(IS)
subplot(1,2,2);plot(1:size(S,1),S)
axis([1 size(IS,1) 0 max(S)]);view(90,90)
%% 
T1    = 0.99;                           % Threshold On Edge Histogram
PR    = find(S > (T1*max(S)));          % Candidate Plate Rows
%% 
Msk   = zeros(size(I));
Msk(PR,:) = 1;                          
MB    = Msk.*IS;                        % Candidate Plate (Edge Image)
Dy    = strel('rectangle',[80,4]);      % Vertical Extension
MBy   = imdilate(MB,Dy);                % By Dilation
MBy   = imfill(MBy,'holes');            % Fill Holes
Dx    = strel('rectangle',[4,80]);      % Horizontal Extension
MBx   = imdilate(MB,Dx);                % By Dilation
MBx   = imfill(MBx,'holes');            % Fill Holes

%% 
BIM   = MBx.*MBy;                       % Joint Places
Dy    = strel('rectangle',[40,40]);     % Horizontal Extension
MM    = imdilate(BIM,Dy);               % By Dilation
MM    = imfill(MM,'holes');             % Fill Holes
Dr    = strel('line',40,0);             % Erosion
BL    = imerode(MM,Dr);

%% 
[L,num] = bwlabel(BL);                  % Label (Binary Regions)               
Areas   = zeros(num,1);
for i = 1:num                           % Compute Area Of Every Region
[r,c,v]  = find(L == i);                % Find Indexes
Areas(i) = sum(v);                      % Compute Area    
end 
[La,Lb] = find(Areas==max(Areas));      % Biggest Binary Region Index
%% 
[a,b]   = find(L==La);                  % Find Biggest Binary Region (Plate)
[nRow,nCol] = size(I);
FM      = zeros(nRow,nCol);             % Smooth and Enlarge Plate Place
T       = 30;                           % Extend Plate Region By T Pixel
jr      = (min(a)-T :max(a)+T);
jc      = (min(b)-T :max(b)+T);
jr      = jr(jr >= 1 & jr <= nRow);
jc      = jc(jc >= 1 & jc <= nCol);
FM(jr,jc) = 1; 
PL      = FM.*I;                        % Detected Plate
figure();imshow(FM)

% figure();imshow(PL)
%% Plot
figure();imshow(Im); title('Detected Plate')

hold on
rectangle('Position',[min(jc),min(jr),max(jc)-min(jc),max(jr)-min(jr)],'LineWidth',2,'EdgeColor','r');
hold off
b=imcrop(Im,[min(jc),min(jr),max(jc)-min(jc),max(jr)-min(jr)]);
figure();imshow(b);

I5=imresize(b,[300 NaN]);
g=rgb2gray(I5);
% figure()
% imshow(g);
g=medfilt2(g,[3 3]);
% figure()
% imshow(g);
level1 = graythresh(g);                 % Threshold Based on Otsu Method
g = ~im2bw(g,level1);
[a1 b1]=size(g);
imagen=g;
imagen = bwareaopen(g,20);
[r c]=size(imagen);
re=imagen;
cor_img=[];
while 1
    [fl re]=lines_crop(re);             %fl= first line, re= remaining image
    imgn=fl;    
    if(~(numel(fl)>0.001*numel(imagen)))
       r1=size(fl,1);
       tempcor_img=imresize(fl,[r1 c]);
       cor_img=[cor_img;tempcor_img];
    end
    if(numel(fl)>0.30*numel(imagen))
       ang=skewDetect(~fl);
       re1=imrotate(fl,max(-ang));
       while 1
       [fl1 re1]=lines_crop(re1);       
       imgn=fl1;
       r1=size(fl1,1);
       tempcor_img=imresize(fl1,[r1 c]);
       cor_img=[cor_img;tempcor_img];
    if(isempty(re1)) break;
    end
   end
  end
  if isempty(re)                     
     break;
   end
  end
  figure() 
  imshow(logical(cor_img));
  
  title('Final Image');
%%
final=bwareaopen(cor_img,floor((a1/40)*(b1/40)));  
final(1:floor(1.2*a1),1:2)=1;
figure()
imshow(final)

Iprops=regionprops(final,'BoundingBox','Image');
hold on
for n=1:size(Iprops,1)
    rectangle('Position',Iprops(n).BoundingBox,'EdgeColor','g','LineWidth',2); 
end
hold off
NR=cat(1,Iprops.BoundingBox);              
[r ttb]=connn(NR);
    xlow=floor(min(reshape(ttb(:,1),1,[])));
    xhigh=ceil(max(reshape(ttb(:,1),1,[])));
    xadd=ceil(ttb(size(ttb,1),3));
    ylow=floor(min(reshape(ttb(:,2),1,[])));%%area selection
    yadd=ceil(max(reshape(ttb(:,4),1,[])));
    final1=final(ylow:(ylow+yadd+(floor(max(reshape(ttb(:,2),1,[])))-ylow)),xlow:(xhigh+xadd));
    [a2 b2]=size(final1);
    final1=bwareaopen(final1,floor((a2/30)*(b2/30)));
    figure()
    imshow(final1)
    
    Iprops1=regionprops(final1,'BoundingBox','Image');
    I1={Iprops1.Image};
%%
   number=[];
   character=[];
   for i=1:size(Iprops1,1)
     N1=I1{1,i};
     figure(17)
     subplot(6,5,i);
     imshow(N1);
%    now = imresize(N1,[42 24]); imwrite(now,'one9.bmp');
   letter=readLetter(N1,1);
if isequal(letter,'0')==1||isequal(letter,'1')==1||isequal(letter,'2')==1||isequal(letter,'3')==1||isequal(letter,'4')==1||isequal(letter,'5')==1||isequal(letter,'6')==1||isequal(letter,'7')==1||isequal(letter,'8')==1||isequal(letter,'9')==1
     number=[number letter];
    else 
     character=[character letter];
    end
   end
   Carnum=[character,number];
   disp(Carnum);
% %  
% %     fid1 = fopen('carnum.txt', 'wt');
% %     fprintf(fid1,'%s',Carnum);
% %     fclose(fid1);
% %     winopen('carnum.txt') 