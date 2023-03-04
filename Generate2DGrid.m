%%% This function generates 2D grid containing nodes and elements 
% according to cell parameters and no. of cells
% Nrows, Ncolumns => % no of rows and columns in the grid
% LCell => Length of the unit cell evelulated from t and rho_rel
% Lh, Lv => horizontal and vertical components of LCell
% x0, y0 => starting point for the printing
% nelem, nnodes => no. of elements and nodes resp. %%%

function [l,lh,lv,ne,nn,nodeID,nx,ny,Nr,Nc,...
lhD,lvD] = Generate2DGrid(CellType,nH,nV,t, ...
rho_rel,theta)

switch CellType
    case 'StretchDominatedDiamond'
        Nr = 2*nH+1; Nc = 2*nV+1;
        l=round(2*sqrt(3)*t/rho_rel);  
        lh=l*cosd(theta); lv=l*sind(theta); 
        x0=40+2*nV*lv; y0=60; ne = 0; nn = 0;
        
        for i = 1:2:Nr % Co-ordinates and elements in odd rows
            for j = 2:2:Nc
                nn = nn + 1;
                nodeID(i,j) = ((i-1)*Nc + j)/2;
                nx(nodeID(i,j)) = x0 - lv * (i-1);
                ny(nodeID(i,j)) = y0 + lh * (j-1);
            end
            for j = 2:2:(Nc-2)
                ne = ne + 1;
                elemcon(ne,1) = nodeID(i,j);
                elemcon(ne,2) = nodeID(i,j+2);
            end
        end
        
        for i = 2:2:Nr % Co-ordinates and elements in even rows
            for j = 1:2:Nc
                nn = nn + 1;
                nodeID(i,j) = ((i-1)*Nc + j)/2;
                nx(nodeID(i,j)) = x0 - lv * (i-1);
                ny(nodeID(i,j)) = y0 + lh * (j-1);        
            end
            for j = 1:2:(Nc-2)
                ne = ne + 1;
                elemcon(ne,1) = nodeID(i,j);
                elemcon(ne,2) = nodeID(i,j+2);
            end
        end
                
        for i = 1:2:(Nr-1) % Connect inclined elements
            for j = 1:2:(Nc-2)
                ne = ne + 1;
                elemcon(ne,1) = nodeID(i,j+1);
                elemcon(ne,2) = nodeID(i+1,j);
                ne = ne + 1;
                elemcon(ne,1) = nodeID(i,j+1);
                elemcon(ne,2) = nodeID(i+1,j+2);
            end
        end       
        
        for i = 3:2:Nr % Connect inclined elements
            for j = 1:2:(Nc-2)
                ne = ne + 1;
                elemcon(ne,1) = nodeID(i,j+1);
                elemcon(ne,2) = nodeID(i-1,j);
                ne = ne + 1;
                elemcon(ne,1) = nodeID(i,j+1);
                elemcon(ne,2) = nodeID(i-1,j+2);  
            end
        end
               
        if (mod(Nr,2)==0) % Connect remaining inclined elements
            for i = 1:2:(Nr-1)
                ne = ne + 1;
                elemcon(ne,1) = nodeID(i,Nc);
                elemcon(ne,2) = nodeID(i+1,Nc-1);
            end
            for i = 2:2:(Nr-1)
                ne = ne + 1;  
                elemcon(ne,1) = nodeID(i,Nc-1);
                elemcon(ne,2) = nodeID(i+1,Nc);  
            end        
        end
        
        figure(1)
        for i = 1:ne
            node1 = elemcon(i,1); node2 = elemcon(i,2);
            L(i) = sqrt((nx(node1)-nx(node2))^2 + (ny(node1)-ny(node2))^2);
            plot([nx(node1) nx(node2)], [ny(node1) ny(node2)],'-r');
            hold on
        end
        
        % vertices of the rectangular domain
        nx(nn+1)=nx(nn); ny(nn+1)=ny(1)-lh; 
        nx(nn+2)=nx(1); ny(nn+2)=ny(1)-lh; 
        nx(nn+3)=nx(1); ny(nn+3)=ny(nn)+lh;
        nx(nn+4)=nx(nn); ny(nn+4)=ny(nn)+lh;
        lhD=nx(nn+2)-nx(nn+1); 
        lvD=ny(nn+4)-ny(nn+1);
        
        for i = 1:length(nx)
            text(nx(i),ny(i),num2str(i),'Fontsize',14,'Color','k');
%             text(nx(i),(ny(i)-5),num2str([nx(i) ny(i)]),'Fontsize',10,'Color','b');
            plot(nx(i),ny(i),'b*',MarkerSize=4);
            plot(nx(i),ny(i),'bo',MarkerSize=4);
        end
        axis equal; xlim([0 230]); ylim([0 230]); 

    case 'BendingDominatedHexagon'
        Nr = 2*nV+1; Nc = 2*nH+2; 
        l=round(2/sqrt(3)*t/rho_rel);
        lh = l*cosd(theta); lv = l*sind(theta); 
        x0=40; y0=60; ne = 0; nn = 0;
        
        for i = 1:2:Nr % Co-ordinates and elements in odd rows
            for j = 4:4:Nc
                nn = nn + 1;
                nodeID(i,j) = ((i-1)*Nc+j)/2;
                nx(nodeID(i,j)) = x0+(j/2)*lh + (j/2-1)*l;
                ny(nodeID(i,j)) = y0+lv * (i-1);
            end
            for j = 5:4:Nc
                nn = nn + 1;
                nodeID(i,j) = ((i-1)*Nc+j+1)/2;
                nx(nodeID(i,j)) = x0+(j-1)/2*(lh+l);
                ny(nodeID(i,j)) = y0+lv * (i-1);
            end
            nn = nn + 1;
            nodeID(i,1) = (i-1)/2*Nc + 1;
            nx(nodeID(i,1)) = x0;
            ny(nodeID(i,1)) = y0+lv * (i-1);
            for j = 4:4:(Nc-1)
                ne = ne + 1;
                elemcon(ne,1) = nodeID(i,j);
                elemcon(ne,2) = nodeID(i,j+1);
            end
        end
        
        for i = 2:2:Nr % Co-ordinates and elements in even rows
            for j = 2:4:Nc
                nn = nn + 1;
                nodeID(i,j) = ((i-1)*Nc+j)/2;
                nx(nodeID(i,j)) = x0+(j/2)*lh + (j-2)/2*l;
                ny(nodeID(i,j)) = y0+lv * (i-1);        
            end
            for j = 3:4:Nc
                nn = nn + 1;
                nodeID(i,j) = ((i-1)*Nc+j+1)/2;
                nx(nodeID(i,j)) = x0+(j-1)/2*(lh+l);
                ny(nodeID(i,j)) = y0+lv * (i-1);        
            end
             for j = 2:4:(Nc-1)
                ne = ne + 1;
                elemcon(ne,1) = nodeID(i,j);
                elemcon(ne,2) = nodeID(i,j+1);
            end
        end
        
        if (mod(nH,2)==0) % additional nodes for tracing domain
            nx(nn+1)=nx(nn)+lh; ny(nn+1)=ny(nn);
            nx(nn+2)=nx(nH+1)+lh; ny(nn+2)=ny(1); 
            lhD=nx(nn+2)-nx(1); lvD=ny(nn+1)-ny(1); k=nn+2;
        else
            lhD=nx(nH+1)-nx(1); lvD=ny(nn)-ny(1); k=nn;
        end
        
        for i = 1:2:(Nr-1) % Connect inclined elements in odd rows
            for j = 1:4:(Nc-1)
                ne = ne + 1;
                elemcon(ne,1) = nodeID(i,j);
                elemcon(ne,2) = nodeID(i+1,j+1);
            end
            for j = 4:4:Nc
                ne = ne + 1;
                elemcon(ne,1) = nodeID(i,j);
                elemcon(ne,2) = nodeID(i+1,j-1);
            end
        end  
        
        for i = 2:2:Nr % Connect inclined elements in even rows
            for j = 2:4:Nc
                ne = ne + 1;
                elemcon(ne,1) = nodeID(i,j);
                elemcon(ne,2) = nodeID(i+1,j-1);
            end
            for j = 3:4:(Nc-1)
                ne = ne + 1;
                elemcon(ne,1) = nodeID(i,j);
                elemcon(ne,2) = nodeID(i+1,j+1);  
            end
        end
        
        % Plot the ground structure - elements + nodes
        figure(1)
        for i = 1:ne
            node1 = elemcon(i,1); node2 = elemcon(i,2);
            L(i) = sqrt((nx(node1)-nx(node2))^2 + (ny(node1)-ny(node2))^2);
            plot([nx(node1) nx(node2)], [ny(node1) ny(node2)],'-r');
            hold on
        end
        
        for i = 1:k
            text(nx(i),ny(i),num2str(i),'Fontsize',14,'Color','k');
%                 text(nx(i)-15,ny(i)-5,num2str([nx(i) ny(i)]),'Fontsize',10,'Color','b');
            plot(nx(i),ny(i),'b*',MarkerSize=4);
            plot(nx(i),ny(i),'bo',MarkerSize=4);
        end
        axis equal; xlim([0 270]); ylim([0 270]);
end
end