%%% This function generates the feed rate data according to 
% cell parameters, no. of cells and no. of layers
% by incrementing the extrusion co-rdinate (E) through constant value 
% nExtr => no of extrusion moves %%%

function [E,nExtr] = GenerateFeedRate(CellType,E0,ne,dLdE, ...
    l,lv,lhD,lvD,nH,nV,Nr,nL)

switch CellType
    case 'StretchDominatedDiamond'
        nExtr=ne-2*(nV-1)+4; 
        for i=1:nL
            for j=1:nExtr
                if i==1 && j==1
                    E((i-1)*nExtr+j)=E0+lhD/dLdE;
                elseif j==1 || j==3
                    E((i-1)*nExtr+j)=E((i-1)*nExtr+j-1)+lhD/dLdE;
                elseif j==2 || j==4
                    E((i-1)*nExtr+j)=E((i-1)*nExtr+j-1)+lvD/dLdE;
                else 
                    E((i-1)*nExtr+j)=E((i-1)*nExtr+j-1)+l/dLdE;
                end
            end
        end

    case 'BendingDominatedHexagon'
        nDoubleExtr=0;
        if(mod(nH,2)==0)
             for i=2:(Nr-1)
                nDoubleExtr=nDoubleExtr+fix(nH/2);
            end
            nExtr=ne+4+nDoubleExtr; 
            for i=1:nL
                for j=1:nExtr
                    if i==1 && j==1
                        E((i-1)*nExtr+j)=E0+lhD/dLdE;
                    elseif j==1 || j==3
                        E((i-1)*nExtr+j)=E((i-1)*nExtr+j-1)+lhD/dLdE;
                    elseif j==2 || j==4
                        E((i-1)*nExtr+j)=E((i-1)*nExtr+j-1)+lvD/dLdE;
                    else 
                        E((i-1)*nExtr+j)=E((i-1)*nExtr+j-1)+l/dLdE;
                    end
                end
            end

        else
            for i=2:(Nr-1)
                if mod(i,2)==0
                    nDoubleExtr=nDoubleExtr + (fix(nH/2)+1);
                else
                    nDoubleExtr=nDoubleExtr + fix(nH/2);
                end
            end
            nExtr=ne+4+nDoubleExtr+nV;
            jump(1)=5+(2*nH+1);
            for i=2:nV
                jump(i) = jump(i-1) + 2*(2*nH+1) + 1;
            end
            for i=1:nL
                for j=1:nExtr
                    if i==1 && j==1
                        E((i-1)*nExtr+j)=E0+lhD/dLdE;
                    elseif j==1 || j==3
                        E((i-1)*nExtr+j)=E((i-1)*nExtr+j-1)+lhD/dLdE;
                    elseif j==2 || j==4
                        E((i-1)*nExtr+j)=E((i-1)*nExtr+j-1)+lvD/dLdE;
                    elseif ismember(j,jump)
                        E((i-1)*nExtr+j)=E((i-1)*nExtr+j-1)+ (2*lv/dLdE);
                    else 
                        E((i-1)*nExtr+j)=E((i-1)*nExtr+j-1)+l/dLdE;
                    end
                end
            end

        end
end
E=E';
end