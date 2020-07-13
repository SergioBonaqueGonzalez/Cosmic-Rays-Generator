% Created by PhD. Sergio Bonaque-González
% Optical Engineer
% sergiob@wooptix.com

function im = cosmicRays_Bonaque(im,sensorSize,exposureTime,numberOfRays,paintResult)
%COSMICRAYS_BONAQUE estimates the number of cosmic rays hitting on a CCD and places them into the image.
%The probability is calculated as a function of average number of cosmic rays per
%cm^2 and second, pixel size and exposure time.
%Density of cosmic rays is considered fixed in a quantity of 0.6/cm^2/15 seconds according to Kirk
%Gilmore.

% Inputs :
%   im = Input image
%   sensorSize = Sensor size
%   exposureTime = exposure time
%   paintResult = Set to 'true' if you want to draw results
%   numberOfRays = This option places a minimum APROXIMATED fixed number of cosmic rays hitting the
%       image. The more realistic situation for a serie of images is a minimum of 0. So, it is likely that there are no cosmic rays in most of the images.
% Returns :
%   im = the input image with added cosmic rays

    if nargin<5
        paintResult = false;
    end
    if nargin<4
        numberOfRays = 0;
    end


    if numberOfRays ==0
        %(1). Estimation of the total number of cosmic rays in the sensor
        density = exposureTime*0.6/15;
        density = sensorSize*100*density;

        %(2) Probability is calculated according to the estimated rays and number of pixels.
        probability = density/(length(im)*length(im));

        %(3) Placing the cosmic rays into the sensor.
        loop = rand(length(im));
        loop(loop == 1) = 0.5;
        loop(loop <= probability) = 1;
        loop(loop < 1) = 0;

        [row,col] = find(loop == 1);
        totalNumber = numel(row);
        totalNumber2 = totalNumber;
        rays = randi([1 130],1,totalNumber); %choosing between the 130 pre-generated cosmic rays.

        rayPre = cell(1,totalNumber);
        for i = 1:totalNumber
            name = sprintf(['iray' num2str(rays(i)) '.txt']);
            ray = importdata(name);

            ray = ray';
            ray(isnan(ray) == 1) = [];
            rayPre{i} = ray(:);
        end

        %(4) Ramdomly fliping the pre-generated cosmic rays
        for i = 1:length(rayPre)
            flipped = randi([1 2],1,1);
            orientation = randi([1 4],1,1);
            if flipped == 2
                rayPre{i} = flip(rayPre{i});
            end
            if orientation == 2
                rayPre{i} = imrotate(rayPre{i},90);
            elseif orientation == 3
                rayPre{i} = imrotate(rayPre{i},180);
            elseif orientation == 4
                rayPre{i} = imrotate(rayPre{i},270);
            end
        end

        im2Display = zeros(size(im));

        %(5) building the image
        for i = 1:totalNumber
            [a,b] = size(rayPre{i});
            if row(i)+a<length(im) && col(i)+b<length(im)
                im(row(i):row(i)+a-1,col(i):col(i)+b-1) = abs(rayPre{i});
                im2Display(row(i):row(i)+a-1,col(i):col(i)+b-1) = abs(rayPre{i});
            else
                totalNumber2 = totalNumber2-1;
            end
        end
        if totalNumber2 > 0
            fprintf('%2.0f Cosmic rays hit in CCD.\n',totalNumber2);
        end

        if totalNumber > 0
            if paintResult
                figure
                set(gcf,'color','w');
                title('Result');
                imshow(im2Display,[])
                xlabel({'Number of cosmic rays: ', totalNumber2});
                colormap(hot)
            end
        end


    else  %Case of user-fixed number of rays
        for j = 1:numberOfRays
            [row(j)] = randi([1 length(im)],1);
            [col(j)] = randi([1 length(im)],1);
        end

        totalNumber = numel(row);
        totalNumber2 = totalNumber;
        rays = randi([1 130],1,totalNumber);

        rayPre = cell(1,totalNumber);

        for i = 1:totalNumber
            name = sprintf(['iray' num2str(rays(i)) '.txt']);
            ray = importdata(name);

            ray = ray';
            ray(isnan(ray) == 1) = [];
            rayPre{i} = ray(:);
        end

        for i = 1:length(rayPre)
            flipped = randi([1 2],1,1);
            orientation = randi([1 4],1,1);
            if flipped == 2
                rayPre{i} = flip(rayPre{i});
            end
            if orientation == 2
                rayPre{i} = imrotate(rayPre{i},90);
            elseif orientation == 3
                rayPre{i} = imrotate(rayPre{i},180);
            elseif orientation == 4
                rayPre{i} = imrotate(rayPre{i},270);
            end
        end

        im2Display = zeros(size(im));

        for i = 1:totalNumber
            [a,b] = size(rayPre{i});
            if row(i)+a<length(im) && col(i)+b<length(im)
                im(row(i):row(i)+a-1,col(i):col(i)+b-1) = abs(rayPre{i});
                im2Display(row(i):row(i)+a-1,col(i):col(i)+b-1) = abs(rayPre{i});
            else
                totalNumber2 = totalNumber2-1;
            end
        end

        if totalNumber>0
            if paintResult
                figure
                set(gcf,'color','w');
                imshow(im2Display,[])
                title('Result');
                xlabel({'Number of cosmic rays: ', totalNumber2});
                colormap(hot)
            end
        end
    end
end