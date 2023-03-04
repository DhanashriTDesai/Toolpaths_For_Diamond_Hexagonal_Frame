%%% This function generates a tool-path, 
% according to no. of cells and nodal data,by defining a nodal-path 
% which entire frame structure is traced with minimal no. of brakes %%%

function [NodalPath] = GenerateNodalPath(CellType,nn,nH,nV)

NodalPath=[]; k=1;

switch CellType
    case 'StretchDominatedDiamond'                 
        DomainNodalPath=[nn+1 nn+2 nn+3 nn+4 nn+1];
        for i=1:size(DomainNodalPath,2)
            NodalPath(k)=DomainNodalPath(i); k=k+1;
        end

        HorizontalPath=zeros(nH-1,nV); 
        for i=1:(nH-1)
            for j=1:nV
                HorizontalPath(i,j)=2*i*nV+(j+i);
                NodalPath(k)=HorizontalPath(i,j); k=k+1;
            end
        end
        
        for itr=0:(nH-1) %  generalized zigzag path 
            if(rem(itr,2)==0)
                i = itr*(2*nV+1)+1;
                j = i+nV;
                b = j+nV;
                a = j-1;
                while(a>=i || b>=j)
                    if(b>=j)
                        NodalPath(k)=b; k=k+1;
                    end
                    if(a>=i)
                        NodalPath(k)=a; k=k+1;
                    end
                    a=a-1; 
                    b=b-1;
                end
                b = b+2;
                while(b<=j+nV)
                    NodalPath(k)=b; k=k+1;
                    b=b+1;
                end
                i = j;
                j = i+nV+1;
                a = j-2;
                b = j+nV-1;
                while(a>=i || b>=j)
                    if(b>=j)
                        NodalPath(k)=b; k=k+1;
                    end
                    if(a>=i)
                        NodalPath(k)=a; k=k+1;
                    end
                    a=a-1;
                    b=b-1;
                end
            else
                i = itr*(2*nV+1)+1;
                j = i+nV;
                a = i;
                b = j;
                while(a<i+nV || b<j+nV)
                    if(b<j+nV)
                        NodalPath(k)=b; k=k+1;
                    end
                    if(a<i+nV)
                        NodalPath(k)=a; k=k+1;
                    end
                    a=a+1;
                    b=b+1;
                end
                b = b;
                while(j<b)
                    NodalPath(k)=b; k=k+1;
                    b=b-1;
                end
                i = j;
                j = i+nV+1;
                a = i;
                b = j;
                while(a<i+nV+1 || b<j+nV)
                    if(a<i+nV+1)
                        NodalPath(k)=a; k=k+1;
                    end
                    if(b<j+nV)
                        NodalPath(k)=b; k=k+1;
                    end
                    a=a+1;
                    b=b+1;
                end
            end
        end
                    
    case 'BendingDominatedHexagon'
        if (mod(nH,2)==0)
            DomainNodalPath=[1 (nn+2) (nn+1) (nn-nH) 1];
        else
            DomainNodalPath=[1 (nH+1) nn (nn-nH) 1];
        end
        
        for i=1:size(DomainNodalPath,2)
            NodalPath(k)=DomainNodalPath(i); k=k+1;
        end
        
        if (mod(nH,2)==0) % generalized zigzag path 
                i = 0; j = 0; jump = fix(nH/2)*2+1;
                for itr=1:nV
                    i = i+jump;
                    a = i+1;
                    b = i-jump+2;
                    alim = i+jump-1;
                    blim = i;
                    while(a<=alim || b<=blim)
                        if(a<=alim)
                            NodalPath(k) = a; k=k+1;
                        end
                        a=a+1;
                        if(a<=alim)
                            NodalPath(k) = a; k=k+1;
                        end
                       
                        if(b<=blim)
                            NodalPath(k) = b; k=k+1;
                        end
                        b=b+1;
                        if(b<=blim)
                            NodalPath(k) = b; k=k+1;
                        end
                        a=a+1;
                        b=b+1;
                    end
                    i = i+jump;
                    a = i+jump;
                    b = i;
                    alim = i+1;
                    blim = i-jump+1;
                    while(a>=alim || b>=blim)
                        if(b>=blim)
                            NodalPath(k) = b; k=k+1;
                        end
                        b=b-1;
                        if(a>=alim)
                            NodalPath(k) = a; k=k+1;
                        end
                        a=a-1;
                        if(a>=alim)
                            NodalPath(k) = a; k=k+1;
                        end    
                        if(b>=blim)
                            NodalPath(k) = b; k=k+1;
                        end
                        a=a-1;
                        b=b-1;
                    end
                end
    
        else
                    i = 0; j = 0; jump = fix(nH/2)*2+2;
                    for itr=1:nV
                        i = i+jump;
                        a = i+1;
                        b = i-jump+2;
                        while(a<=i+jump && b<=i)
                            NodalPath(k) = a; k=k+1;
                            a=a+1;
                            if(a<=i+jump)
                                NodalPath(k) = a; k=k+1;
                            end
                            NodalPath(k) = b; k=k+1;
                            b=b+1;
                            if(b<=i)
                                NodalPath(k) = b; k=k+1;
                            end
                            a=a+1;
                            b=b+1;
                        end
                        i = i+jump;
                        a = i+jump;
                        b = i;
                        NodalPath(k) = a; k=k+1;
                        a=a-1;
                        while(a>=i+1 && b>=i-jump+1)
                            NodalPath(k) = b; k=k+1;
                            b=b-1;
                            if(b>=i-jump+1)
                                NodalPath(k) = b; k=k+1;
                            end
                            NodalPath(k) = a; k=k+1;
                            a=a-1;
                            if(a>=i+1)
                                NodalPath(k) = a; k=k+1;
                            end
                            a=a-1;
                            b=b-1;
                        end
                    end
        end
end
NodalPath=NodalPath';
end