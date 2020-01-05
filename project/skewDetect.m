function r=skewDetect(o_img)
global next_point;
global theta_max;          
       theta_max =60;
global T_ratio;           
       T_ratio=0.05;
global lamda lamda_max;    
Im = not(o_img);         
[Ywin, Xwin] = size(Im);
Im_RLSA = logical(zeros(Ywin, Xwin));          
vertical_lines = logical(zeros(Ywin, Xwin));    

T =  fix(T_ratio * Xwin);   
thresold = false;

for i=1:Ywin
    j=1;
    while j<Xwin
        Im_RLSA(i,j)=Im(i,j);
        if ( Im(i,j)==1 ) && ( Im(i,j+1)==0)
            for k=j+2:min(j+1+T,Xwin)
                if (Im(i, k)==1) && (thresold==false)
                    thresold = true; 
                    next_point=k;
                    break;
                end
            end
            if (thresold == true)
                for k=j+1:next_point , Im_RLSA(i,k)=1; end
                j=next_point - 1;
                thresold = false;
            end
        end
        j=j+1;
    end
end
T_2 = fix(T/2);
x_win_3 = fix( Xwin / 3);
D1=x_win_3; D2=2*x_win_3;
for j=D1:D1:D2+1
    for i=1:Ywin
        for k=j-T_2:j+T_2
            if Im_RLSA(i,k)>0               
                vertical_lines(i,j) = 1;    
                break                       
            end                             
        end

    end
end
L = fix( (D2-D1) * tan(2*pi*theta_max / 360.0) );  

P = (xcorr(double( vertical_lines(:,D1)) , double( vertical_lines(:,D2)) , L )); 
lamda_max = find (P == max(P)) - (L + 1);                  

skew_theta = atan(lamda_max / (D2 - D1)) * 360 / (2 * pi);  
r=skew_theta;

