function [fl re]=lines_crop(im_texto)
% Divide text in lines
im_texto=clip(im_texto);
num_filas=size(im_texto,1);
for s=1:num_filas
    if sum(im_texto(s,:))==0
        nm=im_texto(1:s-1, :); % First line matrix

        rm=im_texto(s:end, :);% Remain line matrix
     
        fl = (nm);
     
        re=(rm);
    

        break
    else
        fl=im_texto;%Only one line.
        re=[ ];
    end
end
function img_out=clip(img_in)
[f c]=find(img_in);    % to remove spaces
img_out=img_in(min(f):max(f),min(c):max(c));

