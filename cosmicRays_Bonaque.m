% Created by PhD. Sergio Bonaque-González
% Optical Engineer
% sergiob@wooptix.com

function im=cosmicRays_Bonaque(im,TamanoSensor,exposuretime,numero,pintar)
%Function that estimates the number of cosmic rays hitting on a CCD and places them into de image.
%The probability is calculated as a function of average number of cosmic rays per 
%cm^2 and second, pixel size and exposure time.
%Density of cosmic rays is considered fixed in a quantity of 0.6/cm^2/15 seconds according to Kirk
%Gilmore. 

%im = Input image
%TamanoSensor = Sensor size
%exposuretime = exposure time
%pintar = Set to 1 if you want to draw results
%numero = This option places a minimum APROXIMATED fixed number of cosmic rays hitting the
%image. The more realistic situation for a serie of images is a minimum of
%0. So, it is likely that there are no cosmic rays in most of the images.

if numero ==0
    %(1). Estimation of the total number of cosmic rays in the sensor
    densidad=exposuretime*0.6/15; 
    densidad=TamanoSensor*100*densidad;
    
    %(2) Probability is calculated according to the estimated rays and number of pixels. 
    probabilidad=densidad/(length(im)*length(im));
    
    %(3) Placing the cosmic rays into the sensor.     
    loop=rand(length(im));
    loop(loop==1)=0.5;
    loop(loop<=probabilidad)=1;
    loop(loop<1)=0;
    
    [row,col]=find(loop==1);
    numerototal=numel(row); 
    numerototal2=numerototal;
    rayos = randi([1 130],1,numerototal);%choosing between the 130 pre-generated cosmic rays.
    
    rayopre=cell(1,numerototal);
    for i=1:numerototal
        nombre= sprintf(['iray' num2str(rayos(i)) '.txt']);
        rayo=importdata(nombre);
        
        rayo=rayo';
        rayo(isnan(rayo)==1)=[];
        rayopre{i}=rayo(:);
    end
    
    
    %(4) Ramdomly fliping the pre-generated cosmic rays
    
    for i=1:length(rayopre)
        Flip=randi([1 2],1,1);
        Orientacion=randi([1 4],1,1);
        if Flip==2
            rayopre{i}=flip(rayopre{i});
        end
        if Orientacion==2
            rayopre{i}=imrotate(rayopre{i},90);
        elseif Orientacion==3
            rayopre{i}=imrotate(rayopre{i},180);
        elseif Orientacion==4
            rayopre{i}=imrotate(rayopre{i},270);
        end
    end
    
    imparapintar=zeros(size(im));
    
    %(5) building the image
    for i =1:numerototal
        [a,b]=size(rayopre{i});
        if row(i)+a<length(im) && col(i)+b<length(im)
            im(row(i):row(i)+a-1,col(i):col(i)+b-1)=abs(rayopre{i});
            imparapintar(row(i):row(i)+a-1,col(i):col(i)+b-1)=abs(rayopre{i});
        else
            numerototal2=numerototal2-1;
        end
    end
    if numerototal2>0
        fprintf('%2.0f Cosmic rays hit in CCD.\n',numerototal2);
    end
    
    if numerototal>0
        if pintar==1
            figure
            set(gcf,'color','w');
            title('Result');
            imshow(imparapintar,[])
            xlabel({'Number of cosmic rays: ', numerototal2});
            colormap(hot)
        end
     end
end

        
%Case of user-fixed number of rays    
if numero >0 
    for j=1:numero
        [row(j)]=randi([1 length(im)],1); 
        [col(j)]=randi([1 length(im)],1);
    end
    numerototal=numel(row);
    numerototal2=numerototal;
    rayos = randi([1 130],1,numerototal);
    
    rayopre=cell(1,numerototal);
    for i=1:numerototal
        nombre= sprintf(['iray' num2str(rayos(i)) '.txt']);
        rayo=importdata(nombre);
        
        rayo=rayo';
        rayo(isnan(rayo)==1)=[];
        rayopre{i}=rayo(:);
    end
    
    
  
    for i=1:length(rayopre)
        Flip=randi([1 2],1,1);
        Orientacion=randi([1 4],1,1);
        if Flip==2
            rayopre{i}=flip(rayopre{i});
        end
        if Orientacion==2
            rayopre{i}=imrotate(rayopre{i},90);
        elseif Orientacion==3
            rayopre{i}=imrotate(rayopre{i},180);
        elseif Orientacion==4
            rayopre{i}=imrotate(rayopre{i},270);
        end
    end
    
    imparapintar=zeros(size(im));

    for i =1:numerototal
        [a,b]=size(rayopre{i});
        if row(i)+a<length(im) && col(i)+b<length(im)
            im(row(i):row(i)+a-1,col(i):col(i)+b-1)=abs(rayopre{i});
            imparapintar(row(i):row(i)+a-1,col(i):col(i)+b-1)=abs(rayopre{i});
        else
            numerototal2=numerototal2-1;
        end
    end

    if numerototal>0
        if pintar==1
            figure
            set(gcf,'color','w');
            imshow(imparapintar,[])
            title('Result');
            xlabel({'Number of cosmic rays: ', numerototal2});
            colormap(hot)
        end
    end
end
